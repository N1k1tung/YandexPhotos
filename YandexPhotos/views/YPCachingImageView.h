//
//  YPCachingImageView.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPCachingImageView : UIImageView <NSURLConnectionDataDelegate>

@property (nonatomic, assign) BOOL fitContents; // default is NO

- (void)setImageWithURL:(NSURL*)imageURL;

@end
