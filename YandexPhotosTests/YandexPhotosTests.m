//
//  YandexPhotosTests.m
//  YandexPhotosTests
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YandexPhotosTests.h"
#import "YPRSSLoader.h"

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
	
	NSAssert([YPRSSLoader itemsFromRSSDictionary:rss], @"couldn't parse rss dictionary into models");
}

@end
