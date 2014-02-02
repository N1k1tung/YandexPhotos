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
		objc_property_t* props = NULL;
		uint count = 0;
		Class currentClass = [self class];
		
		while ([YPRSSItem class] != currentClass) {
			@try {
				props = class_copyPropertyList(currentClass, &count);
				for (uint i = 0; i < count; ++i) {
					NSString* propName = [NSString stringWithUTF8String:property_getName(props[i])];
					[self setValue:dict[propName] forKey:propName];
				}
			}
			@catch (NSException *exception) {
				YPLog(@"%s: exception while mapping fields: %@", __PRETTY_FUNCTION__, exception);
			}
			@finally {
				if (props) {
					free(props);
					props = NULL;
				}
			}
			currentClass = [currentClass superclass];
		}
	}
	return self;
}

@end


@implementation YPRSSImageInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if ([aCoder allowsKeyedCoding])
	{
		[aCoder encodeObject:self.medium forKey:@"medium"];
		[aCoder encodeObject:self.type forKey:@"type"];
		[aCoder encodeObject:self.url forKey:@"url"];
	} else
	{
		[aCoder encodeObject:self.medium];
		[aCoder encodeObject:self.type];
		[aCoder encodeObject:self.url];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		if ([aDecoder allowsKeyedCoding])
		{
			self.medium = [aDecoder decodeObjectForKey:@"medium"];
			self.type = [aDecoder decodeObjectForKey:@"type"];
			self.url = [aDecoder decodeObjectForKey:@"url"];
		} else
		{
			self.medium = [aDecoder decodeObject];
			self.type = [aDecoder decodeObject];
			self.url = [aDecoder decodeObject];
		}
	}
	return self;
}

@end


@implementation YPRSSItemInfo

- (id)initWithDictionary:(NSDictionary*)dict
{
	if (self = [super initWithDictionary:dict]) {
		@try {
			self.content = [[YPRSSImageInfo alloc] initWithDictionary:dict[@"media:content"]];
			self.thumbnail = [[YPRSSImageInfo alloc] initWithDictionary:dict[@"media:thumbnail"]];
			
			self.aDescription = dict[@"description"];
			
			static NSDateFormatter* sDateFormatter = nil;
			
			static dispatch_once_t onceToken;
			dispatch_once(&onceToken, ^{
				sDateFormatter = [NSDateFormatter new];
				sDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
				sDateFormatter.dateFormat = @"EE, dd MMM yyyy HH:mm ZZZ"; //Tue, 28 Jan 2014 00:17 +0400
			});
			
			self.pubDate = [sDateFormatter dateFromString:(NSString *)_pubDate];
		}
		@catch (NSException *exception) {
			YPLog(@"%s: exception while mapping fields: %@", __PRETTY_FUNCTION__, exception);
		}
	}
	return self;
}

@end