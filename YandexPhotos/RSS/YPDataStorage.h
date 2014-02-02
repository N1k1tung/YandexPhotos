//
//  YPDataStorage.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/2/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPDataStorage : NSObject

+ (YPDataStorage*)sharedStorage;

- (NSArray*)fetchItems;
- (void)rewriteItems:(NSArray*)newItems;

@end
