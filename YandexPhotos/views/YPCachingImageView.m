//
//  YPCachingImageView.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPCachingImageView.h"

@implementation YPCachingImageView

- (void)setImageWithURL:(NSURL*)imageURL
{
	
}

static inline NSURL* FileURLForURLString(NSString* urlString)
{
	NSURL* cachesURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
	return [cachesURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.jpg", IMAGES_DIR, urlString]];
}

- (void)cacheImage:(UIImage*)image forURLString:(NSString*)urlString {
	NSURL* fileURL = FileURLForURLString(urlString);
	[UIImageJPEGRepresentation(image, 1.0f) writeToURL:fileURL atomically:YES];
}

- (UIImage*)cachedImageWithURLString:(NSString*)urlString {
	NSURL* fileURL = FileURLForURLString(urlString);
	UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:fileURL]];
	return image;
}

@end
