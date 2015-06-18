//
//  BannerViewController.m
//  FlurryIntegrationSamples
//
//  Created by Flurry on 3/28/14.
//  Copyright (c) 2014 Flurry. All rights reserved.
//

#import "BannerViewController.h"
#import "FlurryAdBannerDelegate.h"
#import "FlurryAdBanner.h"

@interface BannerViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, retain) NSArray *flurryAdSpaces;

@property (nonatomic, retain) IBOutlet UIPickerView *adTypePicker;
@property (nonatomic, retain) IBOutlet UIButton     *showAd;

@property (nonatomic, retain) IBOutlet UILabel      *statusLbl;
@property (retain, nonatomic) IBOutlet UILabel *infoLbl;

- (IBAction)infoButton:(UIButton *)sender forEvent:(UIEvent *)event;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundView;




@end

@implementation BannerViewController
@synthesize adTypePicker;
@synthesize showAd;
@synthesize statusLbl;
@synthesize infoLbl;
@synthesize flurryAdSpaces;
//@synthesize adBanner;

float currentViewWidth, currentViewHeight, containerViewWidth, containerViewHeight;
int width, height ;
FlurryAdBanner* adBanner;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    infoLbl.text = @"FlurrySDK v6.3";
   
    //BannerAdSpaceList.plist contains the list of ad spaces used in this sample
    
    NSString* plistFile = [[NSBundle mainBundle] pathForResource: @"BannerAdSpaceList"
                                                          ofType: @"plist"];
    
    //  the sample points to a number of different ad spaces - each is configured with different settings on the dev.flurry.com
    //  integration for each banner ad is the same regardless of the configuration on the server side.
    //  all the entities in flurryAdSpaces refer to the ad space configured on dev.flurry.com
    //  under Publishers tab, left-hand nav Inventory / Ad Spaces
    self.flurryAdSpaces = [[NSArray alloc] initWithContentsOfFile:plistFile ];
    
    self.adTypePicker.dataSource = self;
    self.adTypePicker.delegate = self;
    
    showAd.layer.borderWidth=0.5f;
    showAd.layer.borderColor=[[UIColor grayColor] CGColor];
    showAd.layer.cornerRadius = 10;
    
    // for device rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToOrientationOnRotation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
   
    [self.infoLbl setHidden:YES];
    
    
    // if no ads are returned, set enableTestAds to YES
    // Please note that the test ads are available for FLurry Network only
    // the test mode does not apply for RTB ads
    
    // Fetch and display banner ad for a given ad space.
    // Note: Choose an adspace name that
    // will uniquely identifiy the ad's placement within your app
    NSUInteger adTypeIx  = [self.adTypePicker selectedRowInComponent:0];
    NSString *adSpaceName = [self.flurryAdSpaces objectAtIndex:adTypeIx];
    
   [self fetchAndDisplay:adSpaceName];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateToOrientationOnRotation];
}

- (void) fetchAndDisplay:(NSString *)adspaceName {
    
    
    
    adBanner = [[FlurryAdBanner alloc] initWithSpace:adspaceName];
    adBanner.adDelegate = self;
    [adBanner fetchAdForFrame:self.view.frame];
    
    self.statusLbl.textColor = [UIColor orangeColor];
    self.statusLbl.text = @"Ad being fetched for ";
    self.statusLbl.text= [self.statusLbl.text stringByAppendingString:[adBanner space]] ;
}


#pragma UI Component handlers

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.flurryAdSpaces.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [self.flurryAdSpaces objectAtIndex:row];
}


- (void) adBannerDidFetchAd:(FlurryAdBanner*)bannerAd{
    NSLog(@" Ad Space [%@] Did Receive Ad ===== ", bannerAd );
    self.statusLbl.text = @"Ad fetched for ";
    self.statusLbl.text= [self.statusLbl.text stringByAppendingString:[bannerAd space]] ;
    [bannerAd displayAdInView:self.view viewControllerForPresentation:self];
}

- (void) adBannerDidRender:(FlurryAdBanner*)bannerAd {
    NSLog(@" Ad Space [%@] Did Display Ad ===== ", [bannerAd space]);
    self.statusLbl.text = @"Ad displayed for ";
    self.statusLbl.text= [self.statusLbl.text stringByAppendingString:[bannerAd space]] ;

}

- (void) adBannerWillPresentFullscreen:(FlurryAdBanner*)bannerAd{
    NSLog(@" Ad Space [%@] Will Present Fullscreen Ad ===== ", [bannerAd space]);
}

- (void) adBanner:(FlurryAdBanner*) bannerAd adError:(FlurryAdError) adError errorDescription:(NSError*) errorDescription{
  NSLog(@" Ad Space [%@] Did Fail to Receive Ad with error [%@] ===== ", [bannerAd space], errorDescription);
}

- (void) adBannerDidReceiveClick:(FlurryAdBanner*)bannerAd{
    NSLog(@" Ad Space [%@] Did Receive Click  ===== ", [bannerAd space]);
}

- (void) adBannerDidDismissFullscreen:(FlurryAdBanner*)bannerAd {

    NSLog(@" Ad Space [%@] Will Dismiss for  ===== ", [bannerAd space]);
}


- (void) adBannerWillLeaveApplication:(FlurryAdBanner*)bannerAd {
    NSLog(@" Ad Space [%@] Will Leave Application ===== ", [bannerAd space]);
}




-(IBAction) showAdClickedButton:(id)sender {
    
    // Get ad space selection
   
    NSUInteger adTypeIx  = [self.adTypePicker selectedRowInComponent:0];
    NSString *adSpaceName = [self.flurryAdSpaces objectAtIndex:adTypeIx];
    [self fetchAndDisplay:adSpaceName];
}


-(void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
     NSLog(@" viewDidDisappear" );
    adBanner.adDelegate = nil;
    adBanner = nil;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if ([self.infoLbl isHidden]) {
        [self.infoLbl setHidden:NO];
    }else
    {
        [self.infoLbl setHidden:YES];
        
    }
    
}

- (void) updateBackgroundImage {
    // Must choose correct image for device type and orientation
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ([BannerViewController isIPad]) {
        // iPad
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationUnknown) {
            // iPad Portrait
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-portrait768.png"]] ;
        } else {
            // iPad Landscape
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-landscape1024.png"]] ;
        }
    } else {
        // iPhone
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationUnknown) {
            // iPhone Portrait
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-portrait.png"]] ;
        } else {
            // iPhone Landscape
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-landscape.png"]];
        }
    }
    //    self.backgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
}


- (void) updateToOrientationOnRotation {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self updateBackgroundImage];
    
    if (orientation == UIDeviceOrientationFaceUp ||
        orientation == UIDeviceOrientationFaceDown) {
        return;
    }
    
    if (![BannerViewController isIPad]) {
        
        if (orientation == UIDeviceOrientationLandscapeLeft ||
            orientation == UIDeviceOrientationLandscapeRight) {
            
            self.adTypePicker.frame = CGRectMake(10, 30, 230, 216);
            
            if ([BannerViewController iS4InchScreen]) {
                self.showAd.frame = CGRectMake(385, 80, 107, 35);
               
                self.statusLbl.frame = CGRectMake(385, 130, 134, 121);
            } else {
                self.showAd.frame = CGRectMake(335, 100, 107, 35);
                
                self.statusLbl.frame = CGRectMake(330, 160, 134, 121);
            }
            
        } else {
            self.showAd.frame = CGRectMake(60, 300, 200, 30);
            
            self.adTypePicker.frame = CGRectMake(10, 90, 310, 162);
            self.statusLbl.frame = CGRectMake(5, 350, 310, 20);
        }
    }
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

+ (BOOL)isIPad
{
	if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] &&
        [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)iS4InchScreen
{
    return ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE;
}


@end
