//
//  YPRSSItem.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPRSSItem.h"
#import <objc/runtime.h>

@implementation YPRSSItem

- (id)initWithDictionary:(NSDictionary*)dict
{
	if (self = [super init]) {
		uint count = 0;
		objc_property_t* props = class_copyPropertyList([self class], &count);
		for (uint i = 0; i < count; ++i) {
			NSString* propName = [NSString stringWithUTF8String:property_getName(props[i])];
			[self setValue:dict[propName] forKey:propName];
		}
		if (props)
			free(props);
	}
	return self;
}

@end


@implementation YPRSSImageInfo
@end


@implementation YPRSSItemInfo

- (id)initWithDictionary:(NSDictionary*)dict
{
	if (self = [super initWithDictionary:dict]) {
		self.content = [[YPRSSImageInfo alloc] initWithDictionary:dict[@"media:content"]];
		self.thumbnail = [[YPRSSImageInfo alloc] initWithDictionary:dict[@"media:thumbnail"]];
		
		static NSDateFormatter* sDateFormatter = nil;
		
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			sDateFormatter = [NSDateFormatter new];
			sDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
			sDateFormatter.dateFormat = @"EE, dd MMM yyyy HH:mm ZZZ"; //Tue, 28 Jan 2014 00:17 +0400
		});
		
		self.pubDate = [sDateFormatter dateFromString:(NSString *)_pubDate];
	}
	return self;
}

@end