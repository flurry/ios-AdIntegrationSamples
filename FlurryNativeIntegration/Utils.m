//
//  Utils.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/5/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "Utils.h"
#import "FlurryAdNative.h"

@implementation Utils

+ (CGSize)sizeForText:(NSString *)text fontSize:(CGFloat)fontsize  fontName:(NSString*)fontName maxWidth:(int)maxWidth maxHeight:(int)maxHeight {
    UIFont *font = [UIFont fontWithName:fontName size:fontsize];
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){maxWidth, maxHeight} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return rect.size;
    } else {
        return [text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, maxHeight)];
    }
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorForPosition:(NSInteger)position {
    NSInteger mod = position % 4;
    switch (mod) {
        case 0: return [Utils colorFromHexString:@"#F9A41D"];
        case 1: return [Utils colorFromHexString:@"#5E08DB"];
        case 2: return [Utils colorFromHexString:@"#8AC53F"];
        case 3: return [Utils colorFromHexString:@"#EE4036"];
        default: return [Utils colorFromHexString:@"#F9A41D"];
    }
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

+ (BOOL)isPortrait {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown;
}

+ (BOOL) isOrigImagePresentInAd:(FlurryAdNative*) ad
{
    for (FlurryAdNativeAsset* asset in ad.assetList)
    {
        if ([asset.name isEqualToString:@"origImg"])
        {
            return YES;
        }
    }
    return NO;
}

+ (NSString*) getOrigImageURLStringForAd:(FlurryAdNative*) nativeAd
{
    for (int ix = 0; ix < nativeAd.assetList.count; ++ix)
    {
        FlurryAdNativeAsset* asset = [nativeAd.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"origImg"])
        {
            return asset.value;
        }
    }
    return nil;
}

+ (NSString*) gethqImageURLStringForAd:(FlurryAdNative*) nativeAd
{
    for (int ix = 0; ix < nativeAd.assetList.count; ++ix)
    {
        FlurryAdNativeAsset* asset = [nativeAd.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"hqImage"])
        {
            return asset.value;
        }
    }
    return nil;
}


+ (BOOL) isSmallFormFactor
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.height == 480 || screenSize.width == 480)
    {
        return YES;
    }
    return NO;
}

@end
