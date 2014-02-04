//
//  YPImageCache.m
//  YandexPhotos
//
//  Created by Nikita Rodin on 04.02.14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPImageCache.h"

@interface YPImageCache ()

@property (strong) NSMutableDictionary* cachedImages;

@end

@implementation YPImageCache

#pragma mark - singleton

+ (YPImageCache*)sharedCache {
	static YPImageCache *sharedCache = nil;
	
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedCache = [[super allocWithZone:NULL] init];
	});
	
    return sharedCache;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedCache];
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#pragma mark - interface

- (UIImage*)imageForPath:(NSString*)filePath
{
	return self.cachedImages[filePath];
}

- (void)cacheImage:(UIImage*)image forPath:(NSString*)filePath
{
	self.cachedImages[filePath] = image;
}

#pragma mark - init & clean cache

- (id)init
{
	if (self = [super init]) {
		self.cachedImages = [NSMutableDictionary new];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	return self;
}

- (void)cleanCache
{
	[self.cachedImages removeAllObjects];
}

@end