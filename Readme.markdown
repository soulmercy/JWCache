# JWCache

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Simple in memory and on disk cache. It's backed by an [NSCache](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/NSCache_Class/Reference/Reference.html) in memory, so it automatically purges itself when memory gets low. Purged memory keys will automatically be loaded from disk the next time the are requested.

## Usage

The API is simple.

``` objective-c
- (id)objectForKey:(NSString *)key;
- (void)objectForKey:(NSString *)key usingBlock:(void (^)(id <NSCopying> object))block;
- (void)setObject:(id <NSCopying>)object forKey:(NSString *)key;
```

You can also use subscripts:

``` objective-c
JWCache *cache = [JWCache sharedCache];
cache[@"answer"] = @42;
NSLog(@"The answer is %@", cache[@"answer"]);
```

See [JWCache.h](JWCache/JWCache.h) for the full list of methods.

## Adding to Your Project

Simply add `JWCache.h` and `JWCache.m` to your project or if you're using CocoaPods, simply add 'JWCache' to your Podfile.
