//
//  NewsDetailViewController.m
//  GeminiSyndicationDemo
//
//  Created by Dan Dosch on 10/14/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (nonatomic, strong) NSString *lastLink;
@property (weak, nonatomic) IBOutlet UIWebView *newsWebView;
@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadLink];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupWithNewsItem:(NewsItem *)newsItem {
    if (self.popover != nil) {
        [self.popover dismissPopoverAnimated:YES];
    }
    self.newsItem = newsItem;
    [self loadLink];
}

- (void)loadLink {
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.newsItem.link]];
    [self.newsWebView loadRequest:req];
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    self.popover = pc;
    barButtonItem.title = @"Yahoo! News";
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.popover = nil;
}

@end
