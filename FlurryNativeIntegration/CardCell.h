//
//  CardCell.h
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/15/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"

@interface CardCell : UITableViewCell

- (void)setupWithNewsItem:(NewsItem *)newsItem atPosition:(NSInteger)position;

+ (CGFloat)heightForNewsItem:(NewsItem *)newsItem withBounds:(CGSize)bounds;

@end
