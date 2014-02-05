//
//  YPCachingImageView.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPCachingImageView : UIImageView <NSURLConnectionDataDelegate>

- (void)setImageWithURL:(NSURL*)imageURL;

@property (nonatomic, assign) BOOL useMemoryCache; // default YES; avoid stockpiling large images in memory

@end
