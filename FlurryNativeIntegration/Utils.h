//
//  Utils.h
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/5/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@class FlurryAdNative;

@interface Utils : NSObject

+ (CGSize)sizeForText:(NSString *)text fontSize:(CGFloat)fontsize  fontName:(NSString*)fontName maxWidth:(int)maxWidth maxHeight:(int)maxHeight;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorForPosition:(NSInteger)position;
+ (BOOL)isIPad;
+ (BOOL)isPortrait;
+ (BOOL) isOrigImagePresentInAd:(FlurryAdNative*) ad;
+ (NSString*) getOrigImageURLStringForAd:(FlurryAdNative*) nativeAd;
+ (NSString*) gethqImageURLStringForAd:(FlurryAdNative*) nativeAd;
+ (BOOL) isSmallFormFactor;

@end
