//
//  DemoCell.h
//  ios_ads_standalone
//
//  Created by Dan Dosch on 7/18/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAdNative.h"

@interface FlurryStreamCell : UITableViewCell

- (void)setupWithFlurryNativeAd:(FlurryAdNative*) adNative atPosition:(NSInteger)position;

+ (CGFloat) getHeightForAd:(FlurryAdNative*)ad withBounds:(CGSize)bounds;

@end
