//
//  YPRSSLoader.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPRSSLoader.h"
#import "XMLReader.h"
#import "YPRSSItem.h"

@implementation YPRSSLoader

+ (NSDictionary*)loadRSS:(NSError**)outError
{
	NSMutableURLRequest *request = [NSMutableURLRequest new];
	[request setURL:[NSURL URLWithString:API_RSS]];
	[request setHTTPMethod:@"GET"];
	
	NSError *error = nil;
	NSURLResponse  *response = nil;
	NSData *rssData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (error) {
		*outError = error;
		return nil;
	}
	
	YPLog(@"RSS loaded: %@", [[NSString alloc] initWithData:rssData encoding:NSUTF8StringEncoding]);
	
	return [XMLReader dictionaryForXMLData:rssData error:outError];
}

+ (NSArray*)itemsFromRSSDictionary:(NSDictionary*)rssDict
{
	NSMutableArray* items = nil;
	@try {
		NSArray* itemDicts = rssDict[@"rss"][@"channel"][@"item"];
		items = [NSMutableArray arrayWithCapacity:itemDicts.count];
		for (NSDictionary *dict in itemDicts) {
			[items addObject:[[YPRSSItemInfo alloc] initWithDictionary:dict]];
		}
	}
	@catch (NSException *exception) {
		YPLog(@"exception %@ while parsing rss dictionary: %@", exception, rssDict);
		return nil;
	}
	return items;
}

@end
