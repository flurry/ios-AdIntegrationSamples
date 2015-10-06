//
//  TakeoverViewController.m
//  FlurryInegrationSamples
//
//  Created by Flurry  on 1/04/15.
//  Copyright (c) 2014 Flurry. All rights reserved.
//

#import "TakeoverViewController.h"

#import "Flurry.h"
#import "FlurryAdInterstitial.h"
#import "FlurryAdInterstitialDelegate.h"
#import "FlurryAdNative.h"

@interface TakeoverViewController ()

@property (nonatomic, retain) NSArray *flurryAdSpaces;

@property (nonatomic, retain) IBOutlet UIPickerView *adTypePicker;
@property (nonatomic, retain) IBOutlet UIButton     *showAd;
@property (nonatomic, retain) IBOutlet UILabel      *statusLbl;
@property (retain, nonatomic) IBOutlet UILabel *infoLbl;
@property (nonatomic, strong) FlurryAdInterstitial* adInterstitial;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundView;

@property NSUInteger previousAdIndex;
@property NSUInteger currentAdIndex;

@end

@implementation TakeoverViewController
@synthesize adTypePicker;
@synthesize showAd;

@synthesize statusLbl;
@synthesize infoLbl;
@synthesize adInterstitial;
@synthesize flurryAdSpaces;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    infoLbl.text = [NSString stringWithFormat:@"Version: %@", [Flurry getFlurryAgentVersion]];
    
    //TakeoverAdSpaceList.plist contains the list of ad spaces used in this sample
    NSString* plistFile = [[NSBundle mainBundle] pathForResource: @"TakeoverAdSpaceList"
                                                          ofType: @"plist"];
    
    
    //  the sample points to a number of different ad spaces - each is configured with different settings on the dev.flurry.com
    //  integration for each takeover ad is the same regardless of the configuration on the server side.
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
    
    self.previousAdIndex = 0;
    self.currentAdIndex = 0;

   
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // if no ads are returned, set enableTestAds to YES
    // Please note that the test ads are available for FLurry Network only
    // the test mode does not apply for RTB ads
    
    
    // Fetch fullscreen ads early when a later display is likely. For
    // Register this UIViewController as a delegate for ad callbacks
    self.currentAdIndex  = [self.adTypePicker selectedRowInComponent:0];
    if (self.currentAdIndex != self.previousAdIndex) {
        self.previousAdIndex = self.currentAdIndex;
    }
    
    
    adInterstitial.adDelegate = nil;
    adInterstitial = nil;
    NSString *adSpaceName = [self.flurryAdSpaces objectAtIndex:self.currentAdIndex];
    
    adInterstitial = [[FlurryAdInterstitial alloc] initWithSpace:adSpaceName] ;
    
    adInterstitial.adDelegate = self;
    
    //to enable test ads in your app, use only if you are not getting production ads
    //make sure to turn this off before releasing the app
    
    FlurryAdTargeting* adTargeting = [FlurryAdTargeting targeting];
    adTargeting.testAdsEnabled = NO;
    adInterstitial.targeting = adTargeting;
    
    
    [adInterstitial fetchAd];
    
    self.statusLbl.textColor = [UIColor orangeColor];
    self.statusLbl.text = @"Fetch an ad ";
    self.statusLbl.textAlignment = NSTextAlignmentCenter;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateToOrientationOnRotation];
    
}

#if __IPHONE_6_0 >= __IPHONE_OS_VERSION_MAX_ALLOWED
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL) shouldAutorotate {
    return YES;
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

- (void)selectRow:(NSInteger)row
      inComponent:(NSInteger)component
         animated:(BOOL)animated
{
    NSLog(@"Ad Space  changed ===== %@",[self.flurryAdSpaces objectAtIndex:row] );

    
}



-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

/**
 *  Invoke a takeover at a natural pause in your app. For example, when a
 *  level is completed, an article is read or a button is pressed. We will
 *  mock the display of a takeover when a button is pressed.
 */
-(IBAction) showAdClickedButton:(id)sender {
    
    self.currentAdIndex  = [self.adTypePicker selectedRowInComponent:0];
    if (self.currentAdIndex == self.previousAdIndex) {
    
        
        if ([adInterstitial ready]) // Check if ad is ready. If so, display the ad
        {
            NSLog(@"Ad Space  is Ready %d ===== ", [adInterstitial ready]);
            
            [adInterstitial presentWithViewController:self];
        } else {
            [adInterstitial fetchAd];
            NSLog(@"Ad fetched again, ");

        }
    }
    else {
        NSString *adSpaceName = [self.flurryAdSpaces objectAtIndex:self.currentAdIndex];
        
        NSLog(@"Ad Space  is NOT ready, fetching again ===== %lu ", (unsigned long)self.currentAdIndex);
        adInterstitial.adDelegate = nil;
        adInterstitial = nil;
        
        adInterstitial = [[FlurryAdInterstitial alloc] initWithSpace:adSpaceName];
        adInterstitial.adDelegate = self;
        [adInterstitial fetchAd];
        self.statusLbl.text = @"Fetching Ads";

        self.previousAdIndex  = self.currentAdIndex;
    }

    
}

#pragma mark AppSpotDelegate methods


//Invoked when an ad is received for the specified interstitialAd object.
- (void)adInterstitialDidFetchAd:(FlurryAdInterstitial*)interstitialAd
{
    NSLog(@"Ad Space [%@] Did Receive Ad ===== ", interstitialAd.space);
    self.statusLbl.text = @"Ad Availble";
       // you can choose to present the ad as soon as it is received
    
}

// Invoked when the interstitial ad is rendered.
- (void) adInterstitialDidRender:(FlurryAdInterstitial *)interstitialAd
{
    NSLog(@"Ad Space [%@] Did Render Ad ===== ", interstitialAd.space);
    self.statusLbl.text = @"Ad Ready for Display";
    
}

//Informs the app that a video associated with this ad has finished playing.
//Only present for rewarded & client-side rewarded ad spaces
- (void) adInterstitialVideoDidFinish:(FlurryAdInterstitial *)interstitialAd
{
    NSLog(@"Ad Space [%@] Video Did Finish  ===== ", interstitialAd.space);
    self.statusLbl.text = @"Video Finished Playing";
}

- (void) adInterstitialWillDismiss:(FlurryAdInterstitial*)interstitialAd{
    NSLog(@"Ad Space [%@] Will Dismiss for interstitial  ===== ", interstitialAd.space);
    
    
}
- (void) adInterstitialDidDismiss:(FlurryAdInterstitial*)interstitialAd {
    NSLog(@"Ad Space [%@] Did Dismiss for interstitial ===== ", interstitialAd.space);
    self.statusLbl.text = @"Fetch Again";
    
}

- (void) adInterstitialDidReceiveClick:(FlurryAdInterstitial*)interstitialAd {
    
    NSLog(@"Ad Space [%@] Did Receive Click ===== ", interstitialAd.space);
    
}
- (void) adInterstitialWillLeaveApplication:(FlurryAdInterstitial*)interstitialAd {
    
    NSLog(@"Ad Space [%@] Will Leave Application ===== ", interstitialAd);
    
}

//Informational callback invoked when there is an ad error
- (void) adInterstitial:(FlurryAdInterstitial*) interstitialAd adError:(FlurryAdError) adError errorDescription:(NSError*) errorDescription {
    // @param interstitialAd The interstitial ad object associated with the error
    //@param adError an enum that gives the reason for the error.
    // @param errorDescription An error object that gives additional information on the cause of the ad error.
   
    NSLog(@"Ad Space [%@] Did Fail to Receive Ad with error [%u] , [%@] ===== ", interstitialAd.space, adError, errorDescription.description);
    self.statusLbl.text = @"No Ads are Currently Available";
    
}





- (IBAction)infoButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if ([self.infoLbl isHidden]) {
        [self.infoLbl setHidden:NO];
    }else
    {
        [self.infoLbl setHidden:YES];
        
    }
    
}


- (void) updateToOrientationOnRotation {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self updateBackgroundImage];
    
    if (orientation == UIDeviceOrientationFaceUp ||
        orientation == UIDeviceOrientationFaceDown) {
        return;
    }
    
    if (![TakeoverViewController isIPad]) {
        
        if (orientation == UIDeviceOrientationLandscapeLeft ||
            orientation == UIDeviceOrientationLandscapeRight) {
            
            self.adTypePicker.frame = CGRectMake(10, 54, 280, 216);
            
            if ([TakeoverViewController iS4InchScreen]) {
                self.showAd.frame = CGRectMake(385, 120, 205, 30);
                
                self.statusLbl.frame = CGRectMake(385, 190, 232, 21);
            } else {
                self.showAd.frame = CGRectMake(335, 150, 205, 30);
               
                self.statusLbl.frame = CGRectMake(330, 200, 232, 21);
            }
            
        } else { //portrait
            self.showAd.frame = CGRectMake(60, 300, 200, 30);
            
            self.adTypePicker.frame = CGRectMake(10, 90, 310, 162);
            
            self.statusLbl.frame = CGRectMake(45, 316, 232, 21);
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void) updateBackgroundImage {
    // Must choose correct image for device type and orientation
    //[self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ([TakeoverViewController isIPad]) {
        // iPad
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationUnknown) {
            // iPad Portrait
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-portrait768.png"]];
        } else {
            // iPad Landscape
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-landscape1024.png"]] ;
        }
    } else {
        // iPhone
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationUnknown) {
            // iPhone Portrait
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-portrait.png"]];
        } else {
            // iPhone Landscape
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-landscape.png"]];
        }
    }
    
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
