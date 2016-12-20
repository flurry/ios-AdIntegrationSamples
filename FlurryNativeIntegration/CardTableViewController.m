//
//  CardTableViewController.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/15/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "CardTableViewController.h"
#import "CardCell.h"
#import "Utils.h"
#import "NewsDetailViewController.h"
#import "FlurryAdNative.h"
#import "FlurryCardCell.h"
#import "GeminiDemoConfiguration.h"
#import "FlurryAdNativeDelegate.h"

@interface CardTableViewController () <FlurryAdNativeDelegate>

@property (nonatomic, strong) NSMutableArray *newsItems;
@property (nonatomic, strong) NewsDetailViewController *newsDetail;
@property (nonatomic, retain) NSMutableArray* nativeAds;

@end

static const int INIT_MAX_ADS = 5;
static const int SECTION_START = 2;
static const int SECTION_SKIP = 3;

@implementation CardTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self)
    {
        self.nativeAds = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CardCell" bundle:nil] forCellReuseIdentifier:@"CardCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CardLandscapeCell" bundle:nil] forCellReuseIdentifier:@"CardLandscapeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FlurryCardCell" bundle:nil] forCellReuseIdentifier:@"FlurryCardCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FlurryCardLandscapeCell" bundle:nil] forCellReuseIdentifier:@"FlurryCardLandscapeCell"];
    [self loadNews];
    [self performSelector :@selector(loadAds) withObject:nil afterDelay:1];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"smaller_logo"]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) loadAds
{
    NSUInteger count = INIT_MAX_ADS;
    NSString* adSpace = [[GeminiDemoConfiguration sharedInstance] adSpace];
    for (int ix = 0; ix < count; ix++)
    {
        FlurryAdNative* nativeAd = [[FlurryAdNative alloc] initWithSpace:adSpace];
        
        nativeAd.adDelegate = self;
        nativeAd.viewControllerForPresentation = self;
        [nativeAd fetchAd];
        [self.nativeAds addObject:nativeAd];
    }
}


- (void) refresh
{
    self.nativeAds = [NSMutableArray array];
    [self performSelectorInBackground:@selector(loadAds) withObject:nil];
    [self loadNews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)loadNews
{
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
    self.nativeAds = [NSMutableArray array];
    [self loadAds];

    [self.refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isAd:indexPath.row] && [self adIndexForIndexPathRow:indexPath.row] < self.nativeAds.count)
    {
        NSInteger adIx = [self adIndexForIndexPathRow:indexPath.row];
        if ([[self.nativeAds objectAtIndex:adIx] assetList].count > 0) {
            FlurryAdNative *item = [self.nativeAds objectAtIndex:adIx];
            return [FlurryCardCell getHeightForAd:item withBounds:self.view.bounds.size];
        } else {
            return 0;
        }
    }
    else
    {
        NewsItem *item = [self.newsItems objectAtIndex:[self contentIndexForIndexPathRow:indexPath.row]];
        if (item)
        {
            return [CardCell heightForNewsItem:item withBounds:self.view.bounds.size];
        }
        return 200;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isAd:indexPath.row] && [self adIndexForIndexPathRow:indexPath.row] < self.nativeAds.count)
    {
        NSString *cellType = [Utils isPortrait] ? @"FlurryCardCell" : @"FlurryCardLandscapeCell";
        FlurryCardCell*  cardCell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
        
        NSInteger adIx = [self adIndexForIndexPathRow:indexPath.row];
        FlurryAdNative* nativeAd = [self.nativeAds objectAtIndex:adIx];
        if (adIx < self.nativeAds.count  && [nativeAd ready] == YES)
        {
            if ([nativeAd expired])
            {
                [nativeAd fetchAd];
                cardCell.hidden = YES;
            }
            else
            {
                FlurryAdNative* nativeAd = [self.nativeAds objectAtIndex:adIx];
                [cardCell setupWithFlurryNativeAd:nativeAd atPosition:indexPath.row];
                cardCell.hidden = NO;
            }
        } else {
            cardCell.hidden = YES;
        }
        return cardCell;
    }
    else
    {
        NSString *cellType = [Utils isPortrait] ? @"CardCell" : @"CardLandscapeCell";
        CardCell *newsCell = [tableView dequeueReusableCellWithIdentifier:cellType];
        [newsCell setupWithNewsItem:[self.newsItems objectAtIndex:[self contentIndexForIndexPathRow:indexPath.row]] atPosition:indexPath.row];
        return newsCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsItem *newsItem = [self.newsItems objectAtIndex:[self contentIndexForIndexPathRow:indexPath.row]];
    if (self.newsDetail == nil) {
        self.newsDetail = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    }
    self.newsDetail.newsItem = newsItem;
    [self.navigationController pushViewController:self.newsDetail animated:YES];
}

#pragma mark - ad helper routines

- (BOOL)isAd:(NSUInteger)row
{
    if (row < SECTION_START) {
        return NO;
    } else {
        return (row - SECTION_START) % SECTION_SKIP == 0;
    }
}

- (NSInteger) adIndexForIndexPathRow: (NSInteger) row
{
    return (row - SECTION_START) / SECTION_SKIP;
}

- (NSInteger) contentIndexForIndexPathRow: (NSInteger) row
{
    if (row < SECTION_START) {
        return row;
    } else {
        return row - ((row - SECTION_START) / SECTION_SKIP) - 1;
    }
}

#pragma mark - ad delegates

- (void) adNativeDidFetchAd:(FlurryAdNative *)flurryAd
{    
    [self.tableView reloadData];
}

- (void) adNative:(FlurryAdNative *)flurryAd adError:(FlurryAdError)adError errorDescription:(NSError *)errorDescription
{
    NSLog(@"====== Native Ad error %d, error description %@", adError, errorDescription);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration: (NSTimeInterval)duration {
    [self.tableView reloadData];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self.tableView reloadData];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void) adNativeWillDismiss:(FlurryAdNative *)nativeAd
{
    NSLog(@"====== Native Ad Will Dismiss %@", nativeAd);
}

- (void) adNativeDidDismiss:(FlurryAdNative *)nativeAd
{
    NSLog(@"====== Native Ad Did Dismiss %@", nativeAd);
}




@end
