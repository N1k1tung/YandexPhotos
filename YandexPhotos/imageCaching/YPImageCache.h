//
//  YPImageCache.h
//  YandexPhotos
//
//  Created by Nikita Rodin on 04.02.14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPImageCache : NSObject

+ (YPImageCache*)sharedCache;

- (UIImage*)imageForPath:(NSString*)filePath;
- (void)cacheImage:(UIImage*)image forPath:(NSString*)filePath;

@end
