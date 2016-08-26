//
//  JWCache.m
//  JWCache
//
//  Created by Jeffery Wang on 8/18/16.
//

#import "JWCache.h"
#import "JWCache+Private.h"

@interface JWCache ()
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *directory;
@property (nonatomic, readonly) NSFileManager *fileManager;
@property (nonatomic) dispatch_queue_t callbackQueue;
@end

@implementation JWCache

#pragma mark - Accessors

@synthesize name = _name;
@synthesize directory = _directory;
@synthesize cache = _cache;
@synthesize fileManager = _fileManager;
@synthesize callbackQueue = _callbackQueue;
@synthesize diskQueue = _diskQueue;

- (NSCache *)cache {
	if (!_cache) {
		_cache = [[NSCache alloc] init];
	}
	return _cache;
}


- (NSFileManager *)fileManager {
	if (!_fileManager) {
		_fileManager = [[NSFileManager alloc] init];
	}
	return _fileManager;
}


#pragma mark - NSObject

- (id)init {
	NSLog(@"[JWCache] You must initalize JWCache using `initWithName:`.");
	return nil;
}


- (void)dealloc {
	[self.cache removeAllObjects];
}


#pragma mark - Getting the Shared Cache

+ (JWCache *)sharedCache {
	static JWCache *sharedCache = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedCache = [[JWCache alloc] initWithName:@"cn.wandougongzhu.jwcache.shared" directory:nil];
	});
	return sharedCache;
}


#pragma mark - Initializing

- (instancetype)initWithName:(NSString *)name {
	return [self initWithName:name directory:nil];
}

- (instancetype)initWithName:(NSString *)name directory:(NSString *)directory {
	NSParameterAssert(name);

	if ((self = [super init])) {
		self.name = [name copy];
		self.cache.name = self.name;
		self.callbackQueue = dispatch_queue_create([[name stringByAppendingString:@".callback"] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
		self.diskQueue = dispatch_queue_create([[name stringByAppendingString:@".disk"] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);

		if (!directory) {
			NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
			directory = [cachesDirectory stringByAppendingFormat:@"/cn.wandougongzhu.jwcache/%@", self.name];
		}
		self.directory = directory;

		if (![self.fileManager fileExistsAtPath:self.directory]) {
			NSError *error;
			[self.fileManager createDirectoryAtPath:self.directory withIntermediateDirectories:YES attributes:nil error:&error];

			if (error) {
				NSLog(@"Failed to create caches directory: %@", error);
			}
			else {
				[self _excludeFileFromBackup:[NSURL fileURLWithPath:self.directory]];
			}
		}
	}
	return self;
}


#pragma mark - Getting a Cached Value

- (id)objectForKey:(NSString *)key {
	NSParameterAssert(key);

	// Look for the object in the memory cache.
	__block id object = [self.cache objectForKey:key];
	if (object) {
		return object;
	}

	// See if the object has a path on disk.
	NSString *path = [self pathForKey:key];
	if (!path) {
		return nil;
	}

	dispatch_sync(self.diskQueue, ^{
		// Load object from disk, synchronously.
		object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
		if (!object) {
			// Object was removed from disk before we could read it.
			return;
		}
	});

	// Store the object from disk in the memory cache.
	if (object) {
		[self.cache setObject:object forKey:key];
	}

	return object;
}


- (void)objectForKey:(NSString *)key usingBlock:(void (^)(id <NSCopying> object))block {
	NSParameterAssert(key);
	NSParameterAssert(block);

	dispatch_async(self.callbackQueue, ^{
		block([self objectForKey:key]);
	});
}


- (BOOL)objectExistsForKey:(NSString *)key {
	NSParameterAssert(key);

	__block BOOL exists = [self.cache objectForKey:key] != nil;
	if (exists) {
		return YES;
	}

	dispatch_sync(self.diskQueue, ^{
		exists = [self.fileManager fileExistsAtPath:[self _pathForKey:key]];
	});
	return exists;
}


#pragma mark - Adding and Removing Cached Values

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key {
	NSParameterAssert(key);

	// If there's no object, delete the key.
	if (!object) {
		[self removeObjectForKey:key];
		return;
	}

	// Save to memory cache
	[self.cache setObject:object forKey:key];

	dispatch_async(self.diskQueue, ^{
		// Save to disk cache
		NSString *path = [self _pathForKey:key];
		if ([NSKeyedArchiver archiveRootObject:object toFile:path]) {
			[self _excludeFileFromBackup:[NSURL fileURLWithPath:path]];
		}
	});
}


- (void)removeObjectForKey:(NSString *)key {
	NSParameterAssert(key);

	[self.cache removeObjectForKey:key];

	dispatch_async(self.diskQueue, ^{
		[self.fileManager removeItemAtPath:[self _pathForKey:key] error:nil];
	});
}


- (void)removeAllObjects {
	[self.cache removeAllObjects];

	dispatch_async(self.diskQueue, ^{
		for (NSString *path in [self.fileManager contentsOfDirectoryAtPath:self.directory error:nil]) {
			[self.fileManager removeItemAtPath:[self.directory stringByAppendingPathComponent:path] error:nil];
		}
	});
}


#pragma mark - Accessing the Disk Cache

- (NSString *)pathForKey:(NSString *)key {
	NSParameterAssert(key);

	if ([self objectExistsForKey:key]) {
		return [self _pathForKey:key];
	}
	return nil;
}


#pragma mark - Subscripting

- (id)objectForKeyedSubscript:(NSString *)key {
	NSParameterAssert(key);

	return [self objectForKey:(NSString *)key];
}


- (void)setObject:(id <NSCoding>)object forKeyedSubscript:(NSString *)key {
	NSParameterAssert(key);

	[self setObject:object forKey:key];
}


#pragma mark - Private

- (NSString *)_sanitizeFileNameString:(NSString *)fileName {
	NSParameterAssert(fileName);

	static NSCharacterSet *illegalFileNameCharacters = nil;
	static dispatch_once_t illegalCharacterCreationToken;
	dispatch_once(&illegalCharacterCreationToken, ^{
		illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString: @"\\?%*|\"<>:"];
	});

	return [[fileName componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}


- (NSString *)_pathForKey:(NSString *)key {
	NSParameterAssert(key);

	key = [self _sanitizeFileNameString: key];
	return [self.directory stringByAppendingPathComponent:key];
}

- (BOOL)_excludeFileFromBackup:(NSURL *)fileUrl {
	NSParameterAssert(fileUrl);
	NSParameterAssert([[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]]);

	NSError *error;
	BOOL result = [fileUrl setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
	if (error) {
		NSLog(@"Failed to exclude file from backup: %@", error);
	}
	return result;
}

@end
