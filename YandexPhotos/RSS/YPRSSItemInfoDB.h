//
//  RSSItemInfoDB.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/2/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YPRSSItemInfoDB : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * aDescription;
@property (nonatomic, retain) id content;
@property (nonatomic, retain) id thumbnail;

@end
