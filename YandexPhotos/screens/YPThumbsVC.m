//
//  YPThumbsVC.m
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#import "YPThumbsVC.h"
#import "YPRSSLoader.h"
#import "YPRSSItem.h"
#import "YPThumbCell.h"
#import "YPPhotoVC.h"

@interface YPThumbsVC ()
{
	YPPhotoVC* _photoVC;
	UIActivityIndicatorView* _activityIndicator;
}

@property (strong) NSArray* items;

@end

@implementation YPThumbsVC

static NSString* const kCellID = @"collectionCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self) {
//        self.useLayoutToLayoutNavigationTransitions = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.collectionView registerClass:[YPThumbCell class] forCellWithReuseIdentifier:kCellID];
	if (!_activityIndicator) {
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_activityIndicator.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	}
	[self.collectionView addSubview:_activityIndicator];
	UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
	refreshControl.tintColor = [UIColor grayColor];
	[self.collectionView addSubview:refreshControl];
	self.collectionView.alwaysBounceVertical = YES;
	
	[self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	_photoVC = nil;
}

- (void)refresh
{
	[_activityIndicator startAnimating];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSError* error = nil;
		NSDictionary* rss = [YPRSSLoader loadRSS:&error];
		if (rss) {
			self.items = [YPRSSLoader itemsFromRSSDictionary:rss];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
			});
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			[_activityIndicator stopAnimating];
		});

	});
	
}

#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.items.count;
}

- (YPRSSItemInfo*)itemInfoForIndexPath:(NSIndexPath*)indexPath
{
	return _items[indexPath.row];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	YPThumbCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
	
	[cell.imageView setImageWithURL:[NSURL URLWithString:[self itemInfoForIndexPath:indexPath].thumbnail.url]];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end
