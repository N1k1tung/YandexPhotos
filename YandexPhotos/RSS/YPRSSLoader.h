//
//  YPRSSLoader.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPRSSLoader : NSObject

+ (NSDictionary*)loadRSS:(NSError**)error;
+ (NSArray*)itemsFromRSSDictionary:(NSDictionary*)rssDict;

@end
