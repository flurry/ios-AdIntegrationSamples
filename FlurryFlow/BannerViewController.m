//
//  BannerViewController.m
//  FlurryIntegrationSamples
//
//  Created by Flurry on 3/28/14.
//  Copyright (c) 2014 Flurry. All rights reserved.
//

#import "BannerViewController.h"
#import "FlurryAdDelegate.h"
#import "FlurryAds.h"

@interface BannerViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, retain) NSArray *flurryAdSpaces;

@property (nonatomic, retain) IBOutlet UIPickerView *adTypePicker;
@property (nonatomic, retain) IBOutlet UIButton     *showAd;
@property (nonatomic, retain) IBOutlet UIButton     *removeAd;
@property (nonatomic, retain) IBOutlet UILabel      *statusLbl;
@property (retain, nonatomic) IBOutlet UILabel *infoLbl;
- (IBAction)infoButton:(UIButton *)sender forEvent:(UIEvent *)event;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundView;



@end

@implementation BannerViewController
@synthesize adTypePicker;
@synthesize showAd;
@synthesize removeAd;
@synthesize statusLbl;
@synthesize infoLbl;
@synthesize flurryAdSpaces;

FlurryAdSize defaultAdSize ;

float currentViewWidth, currentViewHeight, containerViewWidth, containerViewHeight;
int width, height ;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    infoLbl.text = @"FlurrySDK v5.0";
   
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
    
    removeAd.layer.borderWidth=0.5f;
    removeAd.layer.borderColor=[[UIColor grayColor] CGColor];
    removeAd.layer.cornerRadius = 10;
    
    
    
    // for device rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToOrientationOnRotation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
   
    [self.infoLbl setHidden:YES];
    
    // Register this UIViewController as a delegate for ad callbacks
    [FlurryAds setAdDelegate:self];
    
    // if no ads are returned, set enableTestAds to YES
    // Please note that the test ads are available for FLurry Network only
    // the test mode does not apply for RTB ads
    [FlurryAds enableTestAds:NO];
    
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
    
    [FlurryAds fetchAndDisplayAdForSpace:adspaceName view:self.view viewController:self  size:BANNER_BOTTOM];
    self.statusLbl.textColor = [UIColor orangeColor];
    self.statusLbl.text = @"Ad being fetched for ";
    self.statusLbl.text= [self.statusLbl.text stringByAppendingString:adspaceName] ;
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

- (BOOL) spaceShouldDisplay:(NSString*)adSpace interstitial:(BOOL) interstitial {
    
    // Continue ad display
    return YES;
}


- (void)spaceDidDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial {
    //Resume app state when the interstitial is dismissed.
    
    if (interstitial) {
        NSLog(@"Resume app state here");
    }
}

- (void)spaceDidReceiveAd:(NSString *)adSpace {
    NSLog(@" Ad Space [%@] Did Receive Ad ===== ", adSpace);
    self.statusLbl.text = @"Ad displayed for ";
    self.statusLbl.text= [self.statusLbl.text stringByAppendingString:adSpace] ;

    
}

- (void)spaceDidFailToReceiveAd:(NSString *)adSpace error:(NSError *)error {
    NSLog(@" Ad Space [%@] Did Fail to Receive Ad with error [%@] ===== ", adSpace, error);
    
}


// videoDidFinish delegate call is available for rewarded ad spaces only.
// Standard ad space will not trigger this delegate callback
- (void) videoDidFinish:(NSString *)adSpace{
    NSLog(@" Ad Space [%@] Video Did Finish  ===== ", adSpace);
}


- (void)spaceWillDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial {
    NSLog(@" Ad Space [%@] Will Dismiss for interstitial [%d] ===== ", adSpace, interstitial);
}


- (void)spaceWillLeaveApplication:(NSString *)adSpace {
    NSLog(@" Ad Space [%@] Will Leave Application ===== ", adSpace);
}

- (void) spaceDidFailToRender:(NSString *) adSpace error:(NSError *)error {
    NSLog(@" Ad Space [%@] Did Fail to Render with error [%@] ===== ", adSpace, error);
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

-(IBAction) showAdClickedButton:(id)sender {
    
    // Get ad space selection
   
    NSUInteger adTypeIx  = [self.adTypePicker selectedRowInComponent:0];
    NSString *adSpaceName = [self.flurryAdSpaces objectAtIndex:adTypeIx];
    [self fetchAndDisplay:adSpaceName];
}

-(IBAction) removeAdClickedButton:(id)sender {
    NSUInteger adTypeIx  = [self.adTypePicker selectedRowInComponent:0];
    NSString *adSpaceName = [self.flurryAdSpaces objectAtIndex:adTypeIx];
    
    [FlurryAds removeAdFromSpace:adSpaceName];
    
    self.statusLbl.text = @"Ad Removed for ";
    self.statusLbl.text= [self.statusLbl.text stringByAppendingString:adSpaceName] ;

    
}

-(void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
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
                self.removeAd.frame = CGRectMake(385,120, 107, 35);
                self.statusLbl.frame = CGRectMake(385, 130, 134, 121);
            } else {
                self.showAd.frame = CGRectMake(335, 100, 107, 35);
                self.removeAd.frame = CGRectMake(335,140, 107, 35);
                self.statusLbl.frame = CGRectMake(330, 160, 134, 121);
            }
            
        } else {
            self.showAd.frame = CGRectMake(46, 285, 107, 35);
            self.removeAd.frame = CGRectMake(187, 285, 107, 35);
            self.adTypePicker.frame = CGRectMake(10, 90, 310, 162);
            self.statusLbl.frame = CGRectMake(54, 310, 280, 121);
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

- (void)dealloc {
    [_backgroundView release];
    [super dealloc];
}
@end
