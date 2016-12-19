//
//  DemoTableViewController.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 7/18/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//
#import "FlurryAdNative.h"
#import "FlurryAdNativeDelegate.h"

#import "StreamTableViewController.h"
#import "StreamCell.h"
#import "Utils.h"
#import "NewsDetailViewController.h"

#import "FlurryStreamCell.h"
static const int SECTION_SKIP = 3;


@interface StreamTableViewController () <FlurryAdNativeDelegate>

@property (nonatomic, strong) NSMutableArray *newsItems;
@property (nonatomic, strong) NewsDetailViewController *newsDetail;

@property (nonatomic, retain) NSMutableArray* nativeAds;

@end

@implementation StreamTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self)
    {
        self.nativeAds = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self.tableView registerNib:[UINib nibWithNibName:@"StreamCell" bundle:nil] forCellReuseIdentifier:@"StreamCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FlurryStreamCell" bundle:nil] forCellReuseIdentifier:@"FlurryStreamCell"];
    
    [self loadNews];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadNews) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void) loadAds:(NSUInteger) count
{
   
    NSString* plistFile =[ [NSBundle mainBundle] pathForResource: @"StreamAdSpaceList"  ofType: @"plist" ];
    NSMutableDictionary* info;
    info = [NSMutableDictionary dictionaryWithContentsOfFile:plistFile];
    
    NSString* adSpace = [ info objectForKey:@"adSpace"] ;
    
    for (int ix = 0; ix < count; ix++)
    {
        FlurryAdNative* nativeAd = [[FlurryAdNative alloc] initWithSpace:adSpace];
        
        FlurryAdTargeting* adTargeting = [FlurryAdTargeting targeting];
        adTargeting.testAdsEnabled = YES;
        nativeAd.targeting = adTargeting;
        
        nativeAd.adDelegate = self;
        nativeAd.viewControllerForPresentation = self;        
        [nativeAd fetchAd];
        [self.nativeAds addObject:nativeAd];
    }
}

- (void)loadNews {
    self.newsItems = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i = 0; i < 15; i++) {
        NewsItem *newsItem = [[NewsItem alloc] initWithDictionary:[NSDictionary
                                                                   dictionaryWithObjectsAndKeys:@"Lorem ipsum dolor", @"title",
                                                                   @"Lorem ipsum dolor sit amet, putent nusquam placerat ne pri, cu eum paulo sapientem.", @"summary",
                                                                   @"NEWS", @"category",
                                                                   @"News Publisher", @"publisher",
                                                                   nil]];
        [self.newsItems addObject:newsItem];
    }
    static const int INIT_MAX_ADS = 10;
    self.nativeAds = [NSMutableArray array];
    [self loadAds:INIT_MAX_ADS];

    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger adIx = [self adIndexForIndexPathRow:indexPath.row];
    if ([self isAd:indexPath.row] && adIx < self.nativeAds.count && [[self.nativeAds objectAtIndex:adIx] assetList].count > 0)
    {
        FlurryAdNative *item = [self.nativeAds objectAtIndex:adIx];
        return [FlurryStreamCell getHeightForAd:item withBounds:self.view.bounds.size];
    }
    else
    {
        NewsItem *item = [self.newsItems objectAtIndex:indexPath.row];
        if (item) {
            return [StreamCell heightForNewsItem:item withBounds:self.view.bounds.size];
        }
        return 144;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = nil;
    FlurryStreamCell* streamCell = nil;
    NSInteger adIx = [self adIndexForIndexPathRow:indexPath.row];
    if ([self isAd:indexPath.row] && adIx < self.nativeAds.count && [[self.nativeAds objectAtIndex:adIx] assetList].count > 0)
    {
        streamCell = [tableView dequeueReusableCellWithIdentifier:@"FlurryStreamCell" forIndexPath:indexPath];
        if (streamCell == nil)
        {
            streamCell = [[FlurryStreamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlurryStreamCell"];
        }
        FlurryAdNative* nativeAd = [self.nativeAds objectAtIndex:adIx];
        [streamCell setupWithFlurryNativeAd:nativeAd atPosition:indexPath.row];
        cell = streamCell;
    }
    else
    {
        StreamCell* newsCell = [tableView dequeueReusableCellWithIdentifier:@"StreamCell" forIndexPath:indexPath];
        if (newsCell == nil)
        {
            newsCell = [[StreamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StreamCell"];
        }
        [newsCell setupWithNewsItem:[self.newsItems objectAtIndex:indexPath.row] atPosition:indexPath.row];
        cell = newsCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsItem *newsItem = [self.newsItems objectAtIndex:indexPath.row];
   // if (IDIOM == IPAD) {
   //     [self.newsDelegate setupWithNewsItem:newsItem];
   // } else {
        if (self.newsDetail == nil) {
            self.newsDetail = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
        }
        [self.newsDetail setupWithNewsItem:newsItem];
        [self.navigationController pushViewController:self.newsDetail animated:YES];
    //}
}

- (void) adNativeDidFetchAd:(FlurryAdNative *)flurryAd
{
    NSLog(@"=========== Native Ad for Space [%@] Did Receive Ad ================ ", flurryAd.space);
    
}

- (void) adNativeDidFailToFetchAd:(FlurryAdNative*)flurryAd error:(NSError *)error
{
    NSLog(@"=========== Native Ad for Space [%@] Did Fail to Receive Ad ================ ", flurryAd.space);
    
}

- (void) adNativeWillPresent:(FlurryAdNative*)flurryAd
{
    NSLog(@"=========== Native Ad for Space [%@] Will Present ================ ", flurryAd.space);
    
}


- (void) adNativeDidFailToPresent:(FlurryAdNative*)flurryAd error:(NSError *)error
{
    NSLog(@"=========== Native Ad for Space [%@] Did Fail to Present ================ ", flurryAd.space);
    
}
- (void) adNativeWillLeaveApplication:(FlurryAdNative*)flurryAd
{
    NSLog(@"=========== Native Ad for Space [%@] Will Leave Application ================ ", flurryAd.space);
    
}

- (void) adNativeWillDismiss:(FlurryAdNative*)flurryAd
{
    NSLog(@"=========== Native Ad for Space [%@] Will Dismiss ================ ", flurryAd.space);
    
}

- (void) adNativeDidDismiss:(FlurryAdNative*)flurryAd {
    NSLog(@"=========== Native Ad for Space [%@] Did Dismiss ================ ", flurryAd.space);
    
}


- (void) adNativeDidReceiveClick:(FlurryAdNative*)flurryAd
{
    NSLog(@"=========== Native Ad for Space [%@] Did Receive Click ================ ", flurryAd.space);
}




- (BOOL)isAd:(NSUInteger)row
{
    return row % SECTION_SKIP == 0;
}


- (NSInteger) adIndexForIndexPathRow: (NSInteger) row
{
    return row / SECTION_SKIP;
}

@end
