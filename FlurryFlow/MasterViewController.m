//
//  MasterViewController.m
//  FlurryIntegrationSamples
//
//  Created by Flurry on 3/24/14.
//  Copyright (c) 2014 Flurry. All rights reserved.
//

#import "MasterViewController.h"



@interface MasterViewController () {
    NSMutableArray *options;
}
@end

@implementation MasterViewController


- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!options) {
         options = [[NSMutableArray alloc] initWithObjects:@"Flurry Banners", @"Flurry Takovers",     nil];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToOrientationOnRotation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (void) updateToOrientationOnRotation {
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#if __IPHONE_6_0 >= __IPHONE_OS_VERSION_MAX_ALLOWED
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL) shouldAutorotate {
    return YES;
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *object = options[indexPath.row] ;
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selection = options[indexPath.row];
    
    if ([selection isEqualToString:@"Flurry Banners"]) {
        [self performSegueWithIdentifier:@"banners" sender:self];
    }
    else
        if ([selection isEqualToString:@"Flurry Takovers"]) {
            [self performSegueWithIdentifier:@"takeovers" sender:nil];
        }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
   
    if ([[segue identifier] isEqualToString:@"banners"]) {
        //we dont have any specific action here
    }
    if ([[segue identifier] isEqualToString:@"takeovers"]) {
        
        //we dont have any specific action here
    }
}

@end
