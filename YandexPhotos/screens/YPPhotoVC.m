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

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) YPCachingImageView* imageView;
@property (nonatomic, strong) UILabel* authorLabel;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* bottomPanel;

@end

@implementation YPPhotoVC

static const CGFloat kBottomPanelHeight = 44.f;

- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.imageView = [[YPCachingImageView alloc] initWithFrame:self.view.bounds];
	_imageView.fitContents = YES;
	[self.view addSubview:_imageView];
	
	self.bottomPanel = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kBottomPanelHeight, CGRectGetWidth(self.view.bounds), kBottomPanelHeight)];
	_bottomPanel.userInteractionEnabled = NO;
	_bottomPanel.alpha = 0.4f;
	_bottomPanel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;	
	[self.view addSubview:_bottomPanel];
	
	self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomPanel.bounds), kBottomPanelHeight/2)];
	_authorLabel.textAlignment = NSTextAlignmentCenter;
	_authorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_bottomPanel addSubview:_authorLabel];
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kBottomPanelHeight/2, CGRectGetWidth(_bottomPanel.bounds), kBottomPanelHeight/2)];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_bottomPanel addSubview:_titleLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.imageView setImageWithURL:[NSURL URLWithString:_itemInfo.content.url]];
	_authorLabel.text = _itemInfo.author;
	_titleLabel.text = _itemInfo.title;
}

#pragma mark - autorotation

- (BOOL)shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}


@end
