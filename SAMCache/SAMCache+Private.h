//
//  SAMCache+Private.h
//  SAMCache
//
//  Created by Sam Soffes on 9/5/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

@interface SAMCache()

@property (nonatomic) NSCache *cache;
@property (nonatomic) dispatch_queue_t diskQueue;

- (NSString *)_pathForKey:(NSString *)key;

@end
