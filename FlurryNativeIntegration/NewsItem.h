//
//  NewsItem.h
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/4/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;

@property (nonatomic, strong) NSString *publisher;
@property (nonatomic, strong) NSString *published;
@property (nonatomic, strong) NSString *link;

@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSURL *imageOriginalURL;
@property (nonatomic, strong) NSURL *image140x140URL;
@property (nonatomic, strong) NSURL *image640x530URL;
@property (nonatomic, strong) NSURL *imageExtraLargeURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
