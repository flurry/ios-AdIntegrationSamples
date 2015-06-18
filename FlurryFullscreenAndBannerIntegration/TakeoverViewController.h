//
//  TakeoverViewController.h
//  FlurryInegrationSamples
//
//  Created by Flurry on 3/24/14.
//  Copyright (c) 2014 Flurry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAdInterstitialDelegate.h"

@interface TakeoverViewController : UIViewController <FlurryAdInterstitialDelegate, UIPickerViewDelegate, UIPickerViewDataSource >

@property (strong, nonatomic) id detailItem;


@end
