//
//  SportsCell.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/15/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "FlurryCardCell.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

static NSString* kMobStorStarburstURL   = @"https://s.yimg.com/av/geminiSDK/starburst2x.png";
static int widthForNonText = 32;

@interface FlurryCardCell ()

@property (weak, nonatomic) IBOutlet UIButton *CallToActionButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cardSummaryLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cardSourceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *sponseredImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardSponsoredLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *cardSquareImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *cardRectangleImageView;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *appCategoryLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ratingImageView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *CTASquareImageButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *CTARectangleImageButton;


@property (nonatomic, retain) FlurryAdNative* ad;
@property (weak, nonatomic) IBOutlet UIView *cardSquareVideoViewContainer;
@property (weak, nonatomic) IBOutlet UIView *cardRectangleVideoViewContainer;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *topColorView1;
@property (weak, nonatomic) IBOutlet UIView *topColorView2;

@end

@implementation FlurryCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)resetFlurryNativeAd
{
    // To avoid leak in native ad object.
    self.ad.adDelegate = nil;
    self.ad = nil;
}

- (void)setupWithFlurryNativeAd:(FlurryAdNative*)adNative atPosition:(NSInteger)position
{
    [self.ad removeTrackingView];
    
    self.ad = adNative;
    
    if (adNative.assetList == nil)
    {
        self.frame = CGRectMake(0, 0, 0, 0);
        return;
    }
    
    if ([Utils isPortrait]) {
        [self adjustForPortrait];
    } else {
        [self adjustForLandscape:adNative];
    }
    
    self.cardTitleLabel.textColor = [UIColor blackColor];
    
    NSString *hqImage = nil;
    NSString *origImage = nil;
    NSString *ratingHqImage = nil;
    NSString *ratingImage = nil;
    NSString *appCategory = nil;
    NSString *callToActionTxt = nil;
    
    for (int ix = 0; ix < adNative.assetList.count; ++ix) {
        FlurryAdNativeAsset* asset = [adNative.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"headline"]) {
            self.cardTitleLabel.text = asset.value;
            NSLog(@"Headline = %@",asset.value );
        }
        
        if ([asset.name isEqualToString:@"secOrigImg"]) {
            origImage = asset.value;
        }
        
        if ([asset.name isEqualToString:@"secHqImage"]) {
            hqImage = asset.value;
        }
        
        if ([asset.name isEqualToString:@"summary"]) {
            self.cardSummaryLabel.text = asset.value;
        }
        
        if ([asset.name isEqualToString:@"source"] && asset.value != nil && [asset.value isKindOfClass:[NSString class]]) {
            self.cardSourceLabel.text = asset.value;
        }
        
        if ([asset.name isEqualToString:@"secHqRatingImg"]) {
            ratingHqImage = asset.value;
        }
        
        if ([asset.name isEqualToString:@"secRatingImg"]) {
            ratingImage = asset.value;
        }
        
        if ([asset.name isEqualToString:@"appCategory"]) {
            appCategory = asset.value;
        }
        
        if ([asset.name isEqualToString:@"appRating"]) {
            //Use if required
        }
        
        if ([asset.name isEqualToString:@"callToAction"]) {
            callToActionTxt = asset.value;
        }
    }
    
    self.cardSponsoredLabel.text = @"SPONSORED";
    
    if ([adNative isVideoAd]) {
        if (hqImage) {
            if (self.ad.isVideoAd)
            {
                adNative.videoViewContainer =  self.cardRectangleVideoViewContainer;
            }
            self.cardSquareVideoViewContainer.hidden = YES;
            self.cardRectangleVideoViewContainer.hidden = NO;
        }
        else
        {
            if (self.ad.isVideoAd)
            {
                adNative.videoViewContainer =  self.cardSquareVideoViewContainer;
            }
            self.cardSquareVideoViewContainer.hidden = NO;
            self.cardRectangleVideoViewContainer.hidden = YES;
        }
        
        self.cardSquareImageView.hidden = YES;
        self.cardRectangleImageView.hidden = YES;
    }
    else if (hqImage) {
        self.cardSquareImageView.hidden = YES;
        self.cardRectangleImageView.hidden = NO;
        self.cardRectangleVideoViewContainer.hidden = YES;
        self.cardSquareVideoViewContainer.hidden = YES;
        [self.cardRectangleImageView setImageWithURL:[NSURL URLWithString:hqImage] placeholderImage:[UIImage imageNamed:@"streamImage"]];
    }
    else {
        self.cardRectangleImageView.hidden = YES;
        self.cardSquareImageView.hidden = NO;
        self.cardRectangleVideoViewContainer.hidden = YES;
        self.cardSquareVideoViewContainer.hidden = YES;
        [self.cardSquareImageView setImageWithURL:[NSURL URLWithString:origImage] placeholderImage:[UIImage imageNamed:@"streamImage"]];
    }
    
    if (ratingHqImage) {
        self.ratingImageView.hidden = NO;
        self.appCategoryLabel.hidden = YES;
        [self.ratingImageView setImageWithURL:[NSURL URLWithString:ratingHqImage] placeholderImage:nil];
    }
    else if(ratingImage) {
        self.ratingImageView.hidden = NO;
        self.appCategoryLabel.hidden = YES;
        [self.ratingImageView setImageWithURL:[NSURL URLWithString:ratingImage] placeholderImage:nil];
    }
    else
    {
        self.ratingImageView.hidden = YES;
        if (appCategory) {
            self.appCategoryLabel.hidden = NO;
            [self.appCategoryLabel setText:appCategory];
        }
        else
        {
            self.appCategoryLabel.hidden = YES;
        }
    }
    
    if ([adNative isVideoAd])
    {
        self.CTARectangleImageButton.hidden = YES;
        self.CTASquareImageButton.hidden = YES;
        self.CallToActionButton.hidden = NO;
        self.CallToActionButton.layer.cornerRadius = 5;
        self.CallToActionButton.backgroundColor = [Utils colorForPosition:position];
        [self.CallToActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.CallToActionButton setTitle:callToActionTxt forState:UIControlStateNormal];
    }
    else if (callToActionTxt && hqImage) {
        self.CTARectangleImageButton.hidden = NO;
        self.CTASquareImageButton.hidden = YES;
        self.CTARectangleImageButton.layer.cornerRadius = 5;
        self.CTARectangleImageButton.backgroundColor = [Utils colorForPosition:position];
        [self.CTARectangleImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.CTARectangleImageButton setTitle:callToActionTxt forState:UIControlStateNormal];
    }
    else if (callToActionTxt && origImage)
    {
        self.CTASquareImageButton.hidden = NO;
        self.CTARectangleImageButton.hidden = YES;
        self.CTASquareImageButton.layer.cornerRadius = 5;
        self.CTASquareImageButton.backgroundColor = [Utils colorForPosition:position];
        [self.CTASquareImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.CTASquareImageButton setTitle:callToActionTxt forState:UIControlStateNormal];
    }
    else
    {
        self.CTARectangleImageButton.hidden = YES;
        self.CTASquareImageButton.hidden = YES;
    }
    
    [self.sponseredImageView setImage:[UIImage imageNamed:@"icn_sponsored_dense"]];
    self.ad.trackingView = self;
    
    self.topColorView1.backgroundColor = [Utils colorForPosition:position];
    self.topColorView2.backgroundColor = [Utils colorForPosition:position];
    
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.containerView.layer.shadowOpacity = 0.5f;
    
    self.containerView.layer.borderColor = [Utils colorFromHexString:@"#F4F4F4"].CGColor;
    self.containerView.layer.borderWidth = 1;
}

- (void)adjustForPortrait {
    self.cardTitleLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    self.cardSummaryLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    self.cardSummaryLabel.numberOfLines = 3;
}

- (void)adjustForLandscape:(FlurryAdNative*)adNative {
    NSString *headline;
    NSString *summary;
    for (int ix = 0; ix < adNative.assetList.count; ++ix) {
        FlurryAdNativeAsset* asset = [adNative.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"headline"]) {
            headline = asset.value;
        }
        if ([asset.name isEqualToString:@"summary"]) {
            summary = asset.value;
        }
    }
    
    int padding = 8;
    int halfPadding = padding / 2;
    
    int totalWidth = self.containerView.frame.size.width;
    int totalHeight = self.containerView.frame.size.height;
    int halfWidth = totalWidth / 2;
    int textWidth = halfWidth - (padding + halfPadding);
    int usableHeight = totalHeight - self.topColorView1.frame.size.height - padding - padding;
    
    CGSize titleSize = [Utils sizeForText:headline fontSize:17.0 fontName:@"Avenir-Heavy" maxWidth:textWidth maxHeight:70];
    int usableSummaryHeight = usableHeight - ((3 * padding) + titleSize.height);
    CGSize summaryLineSize = [Utils sizeForText:@"." fontSize:14.0 fontName:@"Avenir-Roman" maxWidth:textWidth maxHeight:usableSummaryHeight];
    CGSize summarySize = [Utils sizeForText:summary fontSize:14.0 fontName:@"Avenir-Roman" maxWidth:textWidth maxHeight:usableSummaryHeight];
    
    self.cardSummaryLabel.numberOfLines = summarySize.height / summaryLineSize.height;
    self.cardTitleLabel.preferredMaxLayoutWidth = textWidth;
    self.cardSummaryLabel.preferredMaxLayoutWidth = textWidth;
}

+ (CGFloat) getHeightForAd:(FlurryAdNative*)ad withBounds:(CGSize)bounds
{
    if (ad == nil || ad.assetList == nil)
    {
        return 0.0f;
    }
    if ([Utils isPortrait]) {
        return [FlurryCardCell heightForPortrait:ad withBounds:bounds];
    } else {
        return [FlurryCardCell heightForLandscape:ad withBounds:bounds];
    }
}

+ (CGFloat)heightForPortrait:(FlurryAdNative*)ad withBounds:(CGSize)bounds {
    NSString* headLine = nil;
    NSString* description = nil;
    NSString *hqImage = nil;
    NSString *origImage = nil;
    NSString *callToActionTxt = nil;
    
    for (int ix = 0; ix < ad.assetList.count; ++ix) {
        FlurryAdNativeAsset* asset = [ad.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"headline"]) {
            headLine = asset.value;
        }
        if ([asset.name isEqualToString:@"summary"]) {
            description = asset.value;
        }
        if ([asset.name isEqualToString:@"secOrigImg"]) {
            origImage = asset.value;
        }
        if ([asset.name isEqualToString:@"secHqImage"]) {
            hqImage = asset.value;
        }
        if ([asset.name isEqualToString:@"callToAction"]) {
            callToActionTxt = asset.value;
        }
    }
    
    int outerPadding = 4;
    int innerPadding = 8;
    
    int categoryColorView = 30;
    
    CGFloat contentWidth = bounds.width - 24;
    
    int imageHeight;
    if (hqImage) {
        imageHeight = contentWidth * (627.0 / 1200.0);
    } else {
        imageHeight = contentWidth;
    }
    
    CGSize titleSize = [Utils sizeForText:headLine
                                 fontSize:17.0
                                 fontName:@"Avenir-Heavy"
                                 maxWidth:(bounds.width - widthForNonText)
                                maxHeight:70];
    CGSize summarySize = [Utils sizeForText:description
                                   fontSize:14.0
                                   fontName:@"Avenir-Roman"
                                   maxWidth:(bounds.width - widthForNonText)
                                  maxHeight:58];
    
    int buttonHeight = 0;
    if (callToActionTxt && (hqImage || origImage)) {
        buttonHeight = 30;
    }
    
    return outerPadding + categoryColorView + innerPadding + titleSize.height + innerPadding + summarySize.height + innerPadding + imageHeight + innerPadding + outerPadding +buttonHeight;
}

+ (CGFloat)heightForLandscape:(FlurryAdNative*)ad withBounds:(CGSize)bounds {
    NSString* headLine = nil;
    NSString* description = nil;
    NSString *hqImage = nil;
    NSString *origImage = nil;
    NSString *callToActionTxt = nil;
    
    for (int ix = 0; ix < ad.assetList.count; ++ix) {
        FlurryAdNativeAsset* asset = [ad.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"headline"]) {
            headLine = asset.value;
        }
        if ([asset.name isEqualToString:@"summary"]) {
            description = asset.value;
        }
        if ([asset.name isEqualToString:@"secOrigImg"]) {
            origImage = asset.value;
        }
        if ([asset.name isEqualToString:@"secHqImage"]) {
            hqImage = asset.value;
        }
        
        if ([asset.name isEqualToString:@"callToAction"]) {
            callToActionTxt = asset.value;
        }
    }
    
    int padding = 8;
    int halfPadding = padding / 2;
    int topColorViewHeight = 30;
    
    int totalWidth = bounds.width - 16;
    int totalHeight = bounds.height - 8;
    int halfWidth = totalWidth / 2;
    int usableHeight = totalHeight - topColorViewHeight - padding - padding;
    
    int buttonHeight = 0;
    //    if (callToActionTxt && hqImage) {
    //        buttonHeight = 30;
    //    }
    
    // Title
    CGSize titleSize = [Utils sizeForText:headLine
                                 fontSize:17.0
                                 fontName:@"Avenir-Heavy"
                                 maxWidth:halfWidth - (padding + halfPadding)
                                maxHeight:70];
    
    // Summary
    int usableSummaryHeight = usableHeight - ((3 * padding) + titleSize.height);
    CGSize summarySize = [Utils sizeForText:description
                                   fontSize:14.0
                                   fontName:@"Avenir-Roman"
                                   maxWidth:titleSize.width
                                  maxHeight:usableSummaryHeight];
    
    // Image
    int imageHeight;
    if (hqImage) {
        imageHeight = halfWidth * (627.0 / 1200.0);
    } else {
        imageHeight = halfWidth;
    }
    
    int heightForText = titleSize.height + padding + summarySize.height;
    
    return 4 + topColorViewHeight + padding + MAX(heightForText, imageHeight) + padding + 4 + buttonHeight;
}

@end
