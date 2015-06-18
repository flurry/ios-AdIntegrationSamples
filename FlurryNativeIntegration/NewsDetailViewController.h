//
//  NewsDetailViewController.h
//  GeminiSyndicationDemo
//
//  Created by Dan Dosch on 10/14/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"
//#import "NewsSelectionDelegate.h"

@interface NewsDetailViewController : UIViewController< UISplitViewControllerDelegate>

@property (nonatomic, strong) NewsItem *newsItem;

- (void)setupWithNewsItem:(NewsItem *)newsItem;

@end
