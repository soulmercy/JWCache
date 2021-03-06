//
//  JWCache.h
//  JWCache
//
//  Created by Jeffery Wang on 8/18/16.
//

@import Foundation;

@interface JWCache : NSObject

///-----------------
/// @name Properties
///-----------------

/**
 The name of the cache.
 */
@property (nonatomic, readonly) NSString *name;


/**
 The directory of the on-disk cache.
 */
@property (nonatomic, readonly) NSString *directory;


///-------------------------------
/// @name Getting the Shared Cache
///-------------------------------

/**
 Shared cache suitable for all of your caching needs.

 @return A shared cache.
 */
+ (JWCache *)sharedCache;


///-------------------
/// @name Initializing
///-------------------

/**
 Initialize a separate cache from the shared cache. It may be handy to make a separate cache from the shared cache in
 case you need to call `removeAllObjects` or change the location.
 
 The on-disk cache will be stored at `~/Library/Caches/cn.wandougongzhu.jwcache/NAME/`.

 @param name A string to identify the cache.

 @return A new cache.
 */
- (instancetype)initWithName:(NSString *)name;

/**
 Initialize a separate cache from the shared cache. It may be handy to make a separate cache from the shared cache in
 case you need to call `removeAllObjects` or change the location.

 @param name A string to identify the cache.
 
 @param directory A path to the on-disk cache directory. It will be created if it does not exist. If you pass `nil` it
 will default to `~/Library/Caches/cn.wandougongzhu.jwcache/NAME/`.

 @return A new cache.
 */
- (instancetype)initWithName:(NSString *)name directory:(NSString *)directory;


///-----------------------------
/// @name Getting a Cached Value
///-----------------------------

/**
 Synchronously get an object from the cache.

 @param key The key of the object.

 @return The object for the given key or `nil` if it does not exist.
 */
- (id)objectForKey:(NSString *)key;

/**
 Asynchronously get an object from the cache.

 @param key The key of the object.

 @param block A block called on an arbitrary queue with the requested object or `nil` if it does not exist.
 */
- (void)objectForKey:(NSString *)key usingBlock:(void (^)(id <NSCopying> object))block;

/**
 Synchronously check if an object exists in the cache without retriving it.

 @param key The key of the object.

 @return A boolean specifying if the object exists or not.
 */
- (BOOL)objectExistsForKey:(NSString *)key;


///----------------------------------------
/// @name Adding and Removing Cached Values
///----------------------------------------

/**
 Synchronously set an object in the cache for a given key.

 @param object The object to store in the cache.

 @param key The key of the object.
 */
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

/**
 Remove an object from the cache.

 @param key The key of the object.
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 Remove all objects from the cache.
 */
- (void)removeAllObjects;


///-------------------------------
/// @name Accessing the Disk Cache
///-------------------------------

/**
 Returns the path to the object on disk associated with a given key.

 @param key An object identifying the value.

 @return Path to object on disk or `nil` if no object exists for the given `key`.
 */
- (NSString *)pathForKey:(NSString *)key;


///-------------------
/// @name Subscripting
///-------------------

/**
 Synchronously get an object from the cache.

 @param key The key of the object.

 @return The object for the given key or `nil` if it does not exist.

 This method behaves the same as `objectForKey:`.
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/**
 Synchronously set an object in the cache for a given key.

 @param object The object to store in the cache.

 @param key The key of the object.

 This method behaves the same as `setObject:forKey:`.
 */
- (void)setObject:(id <NSCoding>)object forKeyedSubscript:(NSString *)key;

@end


#if TARGET_OS_IPHONE
#import <JWCache/JWCache+Image.h>
#endif
