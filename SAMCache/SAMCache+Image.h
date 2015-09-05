//
//  SAMCache+Image.h
//  SAMCache
//
//  Created by Sam Soffes on 9/5/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

#import "SAMCache.h"

@class UIImage;

@interface SAMCache (UIImageAdditions)

/**
 Returns the path to the raw image on disk associated with a given key.

 @param key An object identifying the value.

 @return Path to object on disk or `nil` if no object exists for the given `key`.
 */
- (NSString *)imagePathForKey:(NSString *)key;

/**
 Synchronously get an image from the cache.

 @param key The key of the image.

 @return The image for the given key or `nil` if it does not exist.
 */
- (UIImage *)imageForKey:(NSString *)key;

/**
 Asynchronously get an image from the cache.

 @param key The key of the image.

 @param block A block called on an arbitrary queue with the requested image or `nil` if it does not exist.
 */
- (void)imageForKey:(NSString *)key usingBlock:(void (^)(UIImage *image))block;

/**
 Synchronously store a PNG representation of an image in the cache for a given key.

 @param image The image to store in the cache.

 @param key The key of the image.
 */
- (void)setImage:(UIImage *)image forKey:(NSString *)key;

/**
 Synchronously check if an image exists in the cache without retriving it.

 @param key The key of the image.

 @return A boolean specifying if the image exists or not.
 */
- (BOOL)imageExistsForKey:(NSString *)key;

/**
 Remove an image from the cache.

 @param key The key of the image.
 */
- (void)removeImageForKey:(NSString *)key;

@end
