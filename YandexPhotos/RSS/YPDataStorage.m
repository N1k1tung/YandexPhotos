//
//  YPDataStorage.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/2/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPDataStorage.h"
#import "RSSItemInfoDB.h"
#import "YPRSSItem.h"
#import "YPAppDelegate.h"
#import <objc/runtime.h>

static NSString* const kItemInfoEntity = @"RSSItemInfoDB";

@implementation YPDataStorage

#pragma mark - singleton

+ (YPDataStorage*)sharedStorage
{
	static YPDataStorage* shared = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[super allocWithZone:NULL] init];
	});
	
	return shared;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self sharedStorage];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

#pragma mark - db

- (NSManagedObjectContext*)context
{
	return [YPAppDelegate sharedDelegate].managedObjectContext;
}

- (void)saveContext
{
	[[YPAppDelegate sharedDelegate] saveContext];
}

- (NSArray*)fetchItems
{
	return [self fetchItems:NO];
}

- (NSArray*)fetchItems:(BOOL)managedIDsOnly
{
	NSManagedObjectContext* context = self.context;
	NSFetchRequest* fetch = [NSFetchRequest new];
	fetch.entity = [NSEntityDescription entityForName:kItemInfoEntity inManagedObjectContext:context];
	if ((fetch.includesPropertyValues = !managedIDsOnly)) {
		NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
		if (sortDescriptor)
			fetch.sortDescriptors = @[sortDescriptor];
	}

	NSError* error = nil;
	NSArray* items = [context executeFetchRequest:fetch error:&error];
	if (error) {
		YPLog(@"%s: Error while fetching items table: %@", __PRETTY_FUNCTION__, error);
	}
	return items;
}

- (void)rewriteItems:(NSArray*)newItems
{
	[self deleteAllItems];
	NSManagedObjectContext* context = self.context;
	for (YPRSSItemInfo* item in newItems) {
		RSSItemInfoDB* dbItem = [NSEntityDescription insertNewObjectForEntityForName:kItemInfoEntity inManagedObjectContext:context];
		[YPDataStorage mapFrom:item to:dbItem];
	}
	[self saveContext];
}

- (void)deleteAllItems
{
	NSArray* items = [self fetchItems:YES];
	NSManagedObjectContext* context = self.context;
	for (RSSItemInfoDB* item in items) {
		[context deleteObject:item];
	}
	
	[self saveContext];
}

+ (void)mapFrom:(id)fromVar to:(id)toVar 
{
	uint count = 0;
	objc_property_t *propertyList = NULL;
    Class classForMapping = [fromVar class];
	while (classForMapping != [NSObject class])
    {
		propertyList = class_copyPropertyList(classForMapping, &count);
		@try {
			for (uint i = 0; i < count; ++i)
			{
				NSString* propertyName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
				[toVar setValue:[fromVar valueForKey:propertyName] forKey:propertyName];
			}
		}
		@catch (NSException *exception) {
			YPLog(@"%s: Exception during mapping from %@ to %@: %@", __PRETTY_FUNCTION__, fromVar, toVar, exception);
		}
		if (propertyList) {
			free(propertyList);
			propertyList = NULL;
		}
		classForMapping = [classForMapping superclass];
	}
	
}


@end
