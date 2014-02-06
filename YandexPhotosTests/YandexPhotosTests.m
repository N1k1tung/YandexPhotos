//
//  YandexPhotosTests.m
//  YandexPhotosTests
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YandexPhotosTests.h"
#import "YPRSSLoader.h"
#import "YPDataStorage.h"
#import "YPRSSItem.h"
#import "YPRSSItemInfoDB.h"

@implementation YandexPhotosTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testRSSLoader
{
	NSError* error = nil;
	NSDictionary* rss = [YPRSSLoader loadRSS:&error];
	
	NSAssert(rss, @"failed to load or parse rss with error %@", error.localizedDescription);
	
	NSLog(@"RSS dictionary: %@", rss);
	
	NSAssert([YPRSSLoader itemsFromRSSDictionary:rss].count, @"couldn't parse rss dictionary into models or items array was just empty");
}

- (void)testDB
{
	YPRSSItemInfo* badItem = [YPRSSItemInfo new];
	badItem.author = (NSString*)@1;
	badItem.title = (NSString*)@[@23];
	
	YPRSSItemInfo* goodItem = [YPRSSItemInfo new];
	goodItem.author = @"vasya";
	goodItem.title = @"puppan";
	
	[[YPDataStorage sharedStorage] rewriteItems:@[badItem, goodItem]];
	
	NSArray* items = [[YPDataStorage sharedStorage] fetchItems];
	NSAssert(items.count == 1, @"only good shall prevail!");
	
	YPRSSItemInfoDB* goodItemDB = items.lastObject;
	NSAssert([goodItem.author isEqualToString:goodItemDB.author] && [goodItem.title isEqualToString:goodItemDB.title], @"The db item somehow ended up being different");
}

@end
