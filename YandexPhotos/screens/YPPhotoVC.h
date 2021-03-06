//
//  YPPhotoVC.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPPhotoImageView.h"

@class YPRSSItemInfo;

@interface YPPhotoVC : UIViewController <YPPhotoImageViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) YPRSSItemInfo* itemInfo;

@end
