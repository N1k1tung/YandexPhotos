//
//  YPPhotoVC.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPPhotoVC.h"
#import "YPCachingImageView.h"
#import "YPRSSItem.h"

@interface YPPhotoVC ()

@property (nonatomic, strong) YPCachingImageView* imageView;
@property (nonatomic, strong) UILabel* authorLabel;
@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation YPPhotoVC

static const CGFloat kBottomPanelHeight = 44.f;

- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.imageView = [[YPCachingImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_imageView];
	
	UIView* bottomPanel = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.imageView.bounds) - kBottomPanelHeight, CGRectGetWidth(self.imageView.bounds), kBottomPanelHeight)];
	bottomPanel.userInteractionEnabled = NO;
	bottomPanel.alpha = 0.4f;
	[self.imageView addSubview:bottomPanel];
	
	self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottomPanel.bounds), kBottomPanelHeight/2)];
	_authorLabel.textAlignment = NSTextAlignmentCenter;
	[bottomPanel addSubview:_authorLabel];
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kBottomPanelHeight/2, CGRectGetWidth(bottomPanel.bounds), kBottomPanelHeight/2)];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	[bottomPanel addSubview:_titleLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.imageView setImageWithURL:[NSURL URLWithString:_itemInfo.content.url]];
	_authorLabel.text = _itemInfo.author;
	_titleLabel.text = _itemInfo.title;
}

@end
