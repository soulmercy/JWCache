//
//  SAMCacheTests.m
//  SAMCacheTests
//
//  Created by Sam Soffes on 9/15/13.
//  Copyright (c) 2013 Sam Soffes. All rights reserved.
//

@import XCTest;
#import "SAMCache.h"

@interface SAMCache (Private)
@property (nonatomic, readonly) NSCache *cache;
@end

@interface SAMCacheTests : XCTestCase

@property (nonatomic) SAMCache *cache;

@end

@implementation SAMCacheTests

@synthesize cache = _cache;

- (void)setUp {
	self.cache = [[SAMCache alloc] initWithName:@"test"];
}


- (void)tearDown {
	[self.cache removeAllObjects];
}


- (void)testReadingAndWriting {
	[self.cache setObject:@42 forKey:@"answer"];
	XCTAssertEqualObjects(@42, [self.cache objectForKey:@"answer"], @"Reading from memory cache");

	// Reset memory cache
	[self.cache.cache removeAllObjects];

	XCTAssertEqualObjects(@42, [self.cache objectForKey:@"answer"], @"Reading from disk cache");
}


- (void)testDeleting {
	[self.cache setObject:@2 forKey:@"deleting"];
	[self.cache removeObjectForKey:@"deleting"];
	XCTAssertNil([self.cache objectForKey:@"deleting"], @"Reading deleted object");
}


- (void)testSettingNilDeletes {
	[self.cache setObject:@3 forKey:@"niling"];
	[self.cache setObject:nil forKey:@"niling"];
	XCTAssertNil([self.cache objectForKey:@"niling"], @"Reading nil'd object");
}

@end
