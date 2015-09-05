//
//  SAMCache+Image.m
//  SAMCache
//
//  Created by Sam Soffes on 9/5/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

#import "SAMCache+Image.h"
#import "SAMCache+Private.h"

@import UIKit.UIImage;

#if TARGET_OS_IOS
	@import UIKit.UIScreen;
#elif TARGET_OS_WATCH
	@import WatchKit.WKInterfaceDevice;
#endif

@implementation SAMCache (UIImageAdditions)

- (NSString *)imagePathForKey:(NSString *)key {
	NSParameterAssert(key);

	key = [[self class] _keyForImageKey:key];
	NSString *path = [self pathForKey:key];
	return path;
}

- (UIImage *)imageForKey:(NSString *)key {
	NSParameterAssert(key);

	key = [[self class] _keyForImageKey:key];

	__block UIImage *image = [self.cache objectForKey:key];
	if (image) {
		return image;
	}

	// Get path if object exists
	NSString *path = [self pathForKey:key];
	if (!path) {
		return nil;
	}

	// Load object from disk
	image = [UIImage imageWithContentsOfFile:path];

	// Store in cache
	[self.cache setObject:image forKey:key];

	return image;
}


- (void)imageForKey:(NSString *)key usingBlock:(void (^)(UIImage *image))block {
	NSParameterAssert(key);
	NSParameterAssert(block);

	key = [[self class] _keyForImageKey:key];

	dispatch_sync(self.diskQueue, ^{
		UIImage *image = [self.cache objectForKey:key];
		if (!image) {
			image = [[UIImage alloc] initWithContentsOfFile:[self _pathForKey:key]];
			[self.cache setObject:image forKey:key];
		}
		__block UIImage *blockImage = image;
		block(blockImage);
	});
}


- (void)setImage:(UIImage *)image forKey:(NSString *)key {
	NSParameterAssert(key);

	// If there's no image, delete the key.
	if (!image) {
		[self removeObjectForKey:key];
		return;
	}

	key = [[self class] _keyForImageKey:key];

	dispatch_async(self.diskQueue, ^{
		NSString *path = [self _pathForKey:key];

		// Save to memory cache
		[self.cache setObject:image forKey:key];

		// Save to disk cache
		[UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
	});
}


- (BOOL)imageExistsForKey:(NSString *)key {
	NSParameterAssert(key);
	return [self objectExistsForKey:[[self class] _keyForImageKey:key]];
}


- (void)removeImageForKey:(NSString *)key {
	NSParameterAssert(key);
	[self removeObjectForKey:[[self class] _keyForImageKey:key]];
}


#pragma mark - Private

+ (NSString *)_keyForImageKey:(NSString *)imageKey {
	NSParameterAssert(imageKey);

	#if TARGET_OS_IOS
		CGFloat screenScale = [[UIScreen mainScreen] scale];
	#elif TARGET_OS_WATCH
		CGFloat screenScale = [[WKInterfaceDevice currentDevice] screenScale];
	#endif

	NSString *scale = screenScale > 1.0 ? [NSString stringWithFormat:@"@%0.0fx", screenScale] : @"";
	return [imageKey stringByAppendingFormat:@"%@.png", scale];
}

@end
