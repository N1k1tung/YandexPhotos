//
//  YPPhotoVC.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPPhotoVC.h"
#import "YPRSSItem.h"

@interface YPPhotoVC ()
{
	BOOL _needRefresh;
}

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) YPPhotoImageView* imageView;
@property (nonatomic, strong) UILabel* authorLabel;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* bottomPanel;

@end

@implementation YPPhotoVC

static const CGFloat kBottomPanelHeight = 44.f;

- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor whiteColor];
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.minimumZoomScale = 0.25f;
	_scrollView.maximumZoomScale = 1.f;
	_scrollView.bouncesZoom = YES;
	_scrollView.delegate = self;
	[self.view addSubview:_scrollView];
	
	self.imageView = [[YPPhotoImageView alloc] initWithFrame:self.scrollView.bounds];
	_imageView.userInteractionEnabled = NO;
	_imageView.delegate = self;
	[self.scrollView addSubview:_imageView];
	
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
	
	_needRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (_needRefresh) {
		_needRefresh = NO;
		[self refresh];
	}
}

- (void)refresh
{
	_imageView.image = nil;
	[self resetScale];
	if (_itemInfo.content.url.length)
		[_imageView setImageWithURL:[NSURL URLWithString:_itemInfo.content.url]];
	else
		[[[UIAlertView alloc] initWithTitle:nil message:@"Can't find image's URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	
	_authorLabel.text = _itemInfo.author;
	self.navigationItem.title = _titleLabel.text = _itemInfo.title;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	_needRefresh = YES;
}

- (void)resetScale
{
	_scrollView.zoomScale = 1.f;
	_scrollView.contentSize = CGSizeZero;
	_scrollView.contentOffset = CGPointMake(0, -_scrollView.contentInset.top);
	_imageView.frame = _scrollView.bounds;
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

#pragma mark - image view delegate

- (void)imageViewDidLoadImage:(YPPhotoImageView*)imageView
{
	_scrollView.contentSize = imageView.bounds.size;
	_scrollView.zoomScale = 0.5f;
	_scrollView.contentOffset = CGPointMake(0, -_scrollView.contentInset.top);
}

- (void)imageViewFailedToLoadImage:(YPPhotoImageView*)imageView
{
	[[[UIAlertView alloc] initWithTitle:nil message:@"Failed to load image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _imageView;
}

@end
