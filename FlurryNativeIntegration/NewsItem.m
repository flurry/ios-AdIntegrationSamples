//
//  NewsItem.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/4/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.title = dictionary[@"title"];
        self.summary = dictionary[@"summary"];
        self.publisher = dictionary[@"publisher"];
        self.published = dictionary[@"published"];
        self.link = dictionary[@"link"];
        self.category = dictionary[@"category"];
        
        NSArray *images = dictionary[@"images"];
        for (NSDictionary *image in images) {
            if (image[@"url"] != nil) {
                NSArray *tags = image[@"tags"];
                for (NSString *tag in tags) {
                    if ([@"size=original" isEqualToString:tag]) {
                        self.imageOriginalURL = [NSURL URLWithString:image[@"url"]];
                    } else if ([@"ios:size=square_large" isEqualToString:tag]) {
                        self.image140x140URL = [NSURL URLWithString:image[@"url"]];
                    } else if ([@"ios:size=large_new_fixed" isEqualToString:tag]) {
                        self.image640x530URL = [NSURL URLWithString:image[@"url"]];
                    } else if ([@"ios:size=extra_large" isEqualToString:tag]) {
                        self.imageExtraLargeURL = [NSURL URLWithString:image[@"url"]];
                    }
                }
            }
        }
    }
    return self;
}

@end