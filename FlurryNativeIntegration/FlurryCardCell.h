//
//  SportsCell.h
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/15/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAdNative.h"

@interface FlurryCardCell : UITableViewCell

- (void)setupWithFlurryNativeAd:(FlurryAdNative*)adNative atPosition:(NSInteger)position;

+ (CGFloat) getHeightForAd:(FlurryAdNative*)ad withBounds:(CGSize)bounds;

@end
