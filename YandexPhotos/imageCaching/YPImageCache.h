//
//  YPImageCache.h
//  YandexPhotos
//
//  Created by Nikita Rodin on 04.02.14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageProcessBlock)(UIImage* cachedImage);
typedef void (^OnFailBlock)();

@interface YPImageCache : NSObject

+ (YPImageCache*)sharedCache;

- (void)cachedImageForURL:(NSURL*)URL onSuccess:(ImageProcessBlock)onSuccess onFail:(OnFailBlock)onFail useMemoryCache:(BOOL)useMemoryCache;
- (void)cachedImageForURL:(NSURL*)URL onSuccess:(ImageProcessBlock)onSuccess onFail:(OnFailBlock)onFail;
- (void)cacheImage:(UIImage*)image forURL:(NSURL*)URL cacheToMemory:(BOOL)cacheToMemory;
- (void)cacheImage:(UIImage*)image forURL:(NSURL*)URL;

@end
