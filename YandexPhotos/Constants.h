//
//  Constants.h
//  YandexPhotos
//
//  Created by n1k1tung on 2/1/14.
//  Copyright (c) 2014 n1k1tung. All rights reserved.
//

#ifndef YandexPhotos_Constants_h
#define YandexPhotos_Constants_h

#define API_RSS @"http://fotki.yandex.ru/calendar/rss2"
#define IMAGES_DIR	@"images"

#if DEBUG
#	define	YPLog(...) NSLog(__VA_ARGS__)
#else
#	define	YPLog(...) {}
#endif

#endif
