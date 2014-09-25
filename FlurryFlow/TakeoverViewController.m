//
//  TakeoverViewController.m
//  FlurryInegrationSamples
//
//  Created by Flurry  on 3/24/14.
//  Copyright (c) 2014 Flurry. All rights reserved.
//

#import "TakeoverViewController.h"
#import "FlurryAds.h"
#import "Flurry.h"
#import "FlurryAdDelegate.h"

@interface TakeoverViewController ()

@property (nonatomic, retain) NSArray *flurryAdSpaces;

@property (nonatomic, retain) IBOutlet UIPickerView *adTypePicker;
@property (nonatomic, retain) IBOutlet UIButton     *showAd;
@property (nonatomic, retain) IBOutlet UIButton     *removeAd;
@property (nonatomic, retain) IBOutlet UILabel      *statusLbl;
@property (retain, nonatomic) IBOutlet UILabel *infoLbl;

@property (retain, nonatomic)  UIImageView *backgroundView;


@end

@implementation TakeoverViewController
@synthesize adTypePicker;
@synthesize showAd;
@synthesize removeAd;
@synthesize statusLbl;
@synthesize infoLbl;

@synthesize flurryAdSpaces;

FlurryAdSize defaultAdSize ;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    infoLbl.text = @"FlurrySDK v5.0";
    
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
    
    removeAd.layer.borderWidth=0.5f;
    removeAd.layer.borderColor=[[UIColor grayColor] CGColor];
    removeAd.layer.cornerRadius = 10;
    
    
    // for device rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToOrientationOnRotation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [self.infoLbl setHidden:YES];
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateToOrientationOnRotation];
    
    // Register this UIViewController as a delegate for ad callbacks
    [FlurryAds setAdDelegate:self];
    // if no ads are returned, set enableTestAds to YES
    // Please note that the test ads are available for FLurry Network only
    // the test mode does not apply for RTB ads
    [FlurryAds enableTestAds:NO];
    
    self.statusLbl.textColor = [UIColor orangeColor];
    self.statusLbl.text = @"Fetch an ad ";
    
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

-(IBAction) removeAdClickedButton:(id)sender {
    NSUInteger adTypeIx  = [self.adTypePicker selectedRowInComponent:0];
    NSString *adSpace = [self.flurryAdSpaces objectAtIndex:adTypeIx];
    
    [FlurryAds removeAdFromSpace:adSpace];
    
    self.statusLbl.text = @"Ad Removed";
    
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
    
    // Get ad space selection
    NSUInteger adTypeIx  = [self.adTypePicker selectedRowInComponent:0];
    NSString *adSpace = [self.flurryAdSpaces objectAtIndex:adTypeIx];
   
    defaultAdSize =   FULLSCREEN;
    
    if ([FlurryAds adReadyForSpace:adSpace]) {
        
        [FlurryAds displayAdForSpace:adSpace onView:self.view viewControllerForPresentation:self];
        self.statusLbl.text = @"Ad Displayed";
        
    } else {
        
        // Fetch the ad
        [FlurryAds fetchAdForSpace:adSpace frame:self.view.frame size:defaultAdSize];
        self.statusLbl.text = @"Fetching Ads";

    }
    
}

#pragma mark AppSpotDelegate methods

- (void)spaceDidReceiveAd:(NSString *)adSpace {
    NSLog(@" Ad Space [%@] Did Receive Ad ===== ", adSpace);
        self.statusLbl.text = @"Ad Availble";
    
}

- (void)spaceDidFailToReceiveAd:(NSString *)adSpace error:(NSError *)error {
    NSLog(@" Ad Space [%@] Did Fail to Receive Ad with error [%@] ===== ", adSpace, error);
    
    self.statusLbl.text = @"No Ads are Currently Available";
}


// videoDidFinish delegate call is available for rewarded ad spaces only.
// Standard ad space will not trigger this delegate callback
- (void) videoDidFinish:(NSString *)adSpace{
    NSLog(@" Ad Space [%@] Video Did Finish  ===== ", adSpace);
    self.statusLbl.text = @"Video Finished Playing";
}

- (BOOL) spaceShouldDisplay:(NSString*)adSpace interstitial:(BOOL)interstitial {
    NSLog(@" Ad Space [%@] Should Display Ad for interstitial [%d] ===== ", adSpace, interstitial);
    self.statusLbl.text = @"Ad Ready for Display";
// if spaceShouldDisplay returns NO, the ad will not be displayed
    return YES;
}

- (void)spaceWillDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial {
    NSLog(@" Ad Space [%@] Will Dismiss for interstitial [%d] ===== ", adSpace, interstitial);
}

- (void)spaceDidDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial {
    NSLog(@" Ad Space [%@] Did Dismiss for interstitial [%d] ===== ", adSpace, interstitial);
    self.statusLbl.text = @"Fetch Again";
}

- (void)spaceWillLeaveApplication:(NSString *)adSpace {
    NSLog(@" Ad Space [%@] Will Leave Application ===== ", adSpace);
}

- (void) spaceDidFailToRender:(NSString *) adSpace error:(NSError *)error {
    NSLog(@" Ad Space [%@] Did Fail to Render with error [%@] ===== ", adSpace, error);
    self.statusLbl.text = @"Error While Rendering Ad";
    
}

- (void) spaceDidReceiveClick:(NSString *)adSpace {
    NSLog(@" Ad Space [%@] Did Receive Click ===== ", adSpace);
}

- (void)spaceWillExpand:(NSString *)adSpace {
    NSLog(@" Ad Space [%@] Will Expand ===== ", adSpace);
}

- (void)spaceDidCollapse:(NSString *)adSpace {
    NSLog(@" Ad Space [%@] Did Collapse ===== ", adSpace);
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
                self.showAd.frame = CGRectMake(385, 120, 107, 35);
                self.removeAd.frame = CGRectMake(385,160, 107, 35);
                self.statusLbl.frame = CGRectMake(385, 190, 134, 121);
            } else {
                self.showAd.frame = CGRectMake(335, 120, 107, 35);
                self.removeAd.frame = CGRectMake(335,160, 107, 35);
                self.statusLbl.frame = CGRectMake(330, 190, 134, 121);
            }
            
        } else {
            self.showAd.frame = CGRectMake(35, 255, 107, 35);
            self.removeAd.frame = CGRectMake(180, 255, 107, 35);
            self.adTypePicker.frame = CGRectMake(13, 58, 294, 216);
            self.statusLbl.frame = CGRectMake(33, 250, 280, 121);
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void) updateBackgroundImage {
    // Must choose correct image for device type and orientation
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ([TakeoverViewController isIPad]) {
        // iPad
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationUnknown) {
            // iPad Portrait
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-portrait768.png"]] autorelease];
        } else {
            // iPad Landscape
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-landscape1024.png"]] autorelease];
        }
    } else {
        // iPhone
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationUnknown) {
            // iPhone Portrait
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-portrait.png"]] autorelease];
        } else {
            // iPhone Landscape
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flurry-splash-landscape.png"]] autorelease];
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

- (void)dealloc {
    [_backgroundView release];
    
    [super dealloc];
}
@end
