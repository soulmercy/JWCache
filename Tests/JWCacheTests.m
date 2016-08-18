//
//  JWCacheTests.m
//  JWCacheTests
//
//  Created by Jeffery Wang on 8/18/16.
//

@import XCTest;
#import "JWCache.h"

@interface JWCache (Private)
@property (nonatomic, readonly) NSCache *cache;
@end

@interface JWCacheTests : XCTestCase

@property (nonatomic) JWCache *cache;

@end

@implementation JWCacheTests

@synthesize cache = _cache;

- (void)setUp {
	self.cache = [[JWCache alloc] initWithName:@"test" directory:nil];
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


- (void)testSettingWithSubscript {
	self.cache[@"subscriptSet"] = @"subset";
	XCTAssertEqualObjects(@"subset", [self.cache objectForKey:@"subscriptSet"], @"Setting an object with a subscript");
}


- (void)testReadingWithSubscript {
	[self.cache setObject:@"subread" forKey:@"subscriptRead"];
	XCTAssertEqualObjects(@"subread", self.cache[@"subscriptRead"], @"Reading an object with a subscript");
}

@end
