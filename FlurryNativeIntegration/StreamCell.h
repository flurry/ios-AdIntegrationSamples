//
//  DemoCell.h
//  ios_ads_standalone
//
//  Created by Dan Dosch on 7/18/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"

@interface StreamCell : UITableViewCell

- (void)setupWithNewsItem:(NewsItem *)newsItem atPosition:(NSInteger)position;

+ (CGFloat)heightForNewsItem:(NewsItem *)newsItem withBounds:(CGSize)bounds;

@end
