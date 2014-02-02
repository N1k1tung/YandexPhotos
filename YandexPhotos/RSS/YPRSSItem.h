//
//  YPRSSItem.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPRSSItem : NSObject

- (id)initWithDictionary:(NSDictionary*)dict;

@end

@interface YPRSSImageInfo : YPRSSItem <NSCoding>

@property (nonatomic, strong) NSString* medium;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* url;

@end

@interface YPRSSItemInfo : YPRSSItem

@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* aDescription;
@property (nonatomic, strong) NSString* link;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSDate* pubDate;
@property (nonatomic, strong) YPRSSImageInfo* content;
@property (nonatomic, strong) YPRSSImageInfo* thumbnail;

@end