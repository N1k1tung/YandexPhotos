//
//  YPCachingImageView.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPCachingImageView.h"

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
		self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activity.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
		_activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:_activity];
	}
	return self;
}

- (void)setImageWithURL:(NSURL*)imageURL
{
	[_activeConnection cancel];
	
	self.image = nil;
	if (!imageURL)
		return;
	[_activity startAnimating];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* cachePath = [self cachePathForURLString:imageURL.absoluteString];
		UIImage* cachedImage = nil;
		if (cachePath.length && [[NSFileManager defaultManager] fileExistsAtPath:cachePath] && (cachedImage = [UIImage imageWithContentsOfFile:cachePath])) {
			dispatch_async(dispatch_get_main_queue(), ^{
				self.image = cachedImage;
				[_activity stopAnimating];
			});
		} else
			dispatch_async(dispatch_get_main_queue(), ^{
				[self startRequestWithURL:imageURL];
			});
	});

}

- (void)startRequestWithURL:(NSURL*)imageURL
{
	NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
	self.responseData = [NSMutableData new];
	self.activeConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)setImage:(UIImage *)image
{
	[super setImage:image? image : [UIImage imageNamed:@"blankImage"]];
	if (image && _fitContents) {
		CGFloat scale = MAX(1.f, self.contentScaleFactor);
		self.bounds = CGRectMake(0, 0, image.size.width/scale, image.size.height/scale);
	}
}

#pragma mark - image caching

- (NSString*)cachePathForURLString:(NSString*)urlString
{
	NSString* cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	
	return [cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.jpg", IMAGES_DIR, [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)cacheImage:(UIImage*)image forURLString:(NSString*)urlString {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* filePath = [self cachePathForURLString:urlString];
        [UIImageJPEGRepresentation(image, 1.0f) writeToFile:filePath atomically:YES];
    });
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
		[self cacheImage:image forURLString:_url.absoluteString];
	self.image = image;
	self.responseData = nil;
	self.activeConnection = nil;
	[_activity stopAnimating];
}

@end
