//
//  YPThumbCell.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPThumbCell.h"

@implementation YPThumbCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.imageView = [[YPCachingImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_imageView];
	}
    return self;
}


@end
