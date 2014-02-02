//
//  YPPhotoImageView.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/2/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPCachingImageView.h"

@protocol YPPhotoImageViewDelegate;

@interface YPPhotoImageView : YPCachingImageView

@property (nonatomic, weak) id <YPPhotoImageViewDelegate> delegate;

@end


@protocol YPPhotoImageViewDelegate <NSObject>

@optional
- (void)imageViewDidLoadImage:(YPPhotoImageView*)imageView;
- (void)imageViewFailedToLoadImage:(YPPhotoImageView*)imageView;

@end
