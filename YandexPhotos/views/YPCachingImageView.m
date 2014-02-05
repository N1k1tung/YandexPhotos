//
//  YPCachingImageView.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPCachingImageView.h"
#import "YPImageCache.h"

@interface YPCachingImageView () {
}

@property (nonatomic, strong) NSURLConnection* activeConnection;
@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) UIActivityIndicatorView* activity;

@end

@implementation YPCachingImageView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_activity.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
		_activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:_activity];
		self.useMemoryCache = YES;
	}
	return self;
}

#pragma mark - custom set image

- (void)setImageWithURL:(NSURL*)imageURL
{
	[_activeConnection cancel];
	[_activity stopAnimating];
	
	self.image = nil;
	if (!imageURL)
		return;
	[_activity startAnimating];
		
	[[YPImageCache sharedCache] cachedImageForURL:imageURL onSuccess:^(UIImage *cachedImage) {
		self.image = cachedImage;
		[self.activity stopAnimating];
	} onFail:^{
		[self startRequestWithURL:imageURL];
	} useMemoryCache:_useMemoryCache];
}

- (void)startRequestWithURL:(NSURL*)imageURL
{
	NSURLRequest *request = [NSURLRequest requestWithURL:imageURL]; // by default also caching images here
	self.responseData = [NSMutableData new];
	self.url = imageURL;
	self.activeConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)setImage:(UIImage *)image
{
	[super setImage:image? image : [UIImage imageNamed:@"blankImage"]];
}

#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.activeConnection = nil;
	[_activity stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	UIImage *image = [UIImage imageWithData:_responseData];
	if (image)
		[[YPImageCache sharedCache] cacheImage:image forURL:_url cacheToMemory:_useMemoryCache];
	self.image = image;
	self.responseData = nil;
	self.activeConnection = nil;
	self.url = nil;
	[_activity stopAnimating];
}

@end


