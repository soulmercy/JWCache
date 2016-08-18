//
//  JWCache+Private.h
//  JWCache
//
//  Created by Jeffery Wang on 8/18/16.
//

@interface JWCache()

@property (nonatomic) NSCache *cache;
@property (nonatomic) dispatch_queue_t diskQueue;

- (NSString *)_pathForKey:(NSString *)key;

@end
