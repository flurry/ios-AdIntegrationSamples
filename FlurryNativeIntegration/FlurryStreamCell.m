//
//  DemoCell.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 7/18/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "FlurryStreamCell.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"
#import "FlurryStreamCell.h"

static NSString* kMobStorStarburstURL   = @"https://s.yimg.com/av/geminiSDK/starburst2x.png";
static int widthForNonText = 122;

@interface FlurryStreamCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *streamTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *streamDescriptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *streamImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *streamSponseredLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *streamSponseredImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *streamSourceLabel;


@property (nonatomic, retain) FlurryAdNative* ad;
@property (nonatomic, assign) dispatch_once_t onceToken;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *topColorView1;
@property (weak, nonatomic) IBOutlet UIView *topColorView2;

@end

@implementation FlurryStreamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupWithFlurryNativeAd:(FlurryAdNative*) adNative atPosition:(NSInteger)position;
{
    [self.ad removeTrackingView];    
    self.ad = adNative;

    if (adNative.assetList.count == 0)
    {
        self.frame = CGRectMake(0, 0, 0, 0);
        return;
    }

    self.streamTitleLabel.textColor = [UIColor blackColor];
    self.streamTitleLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    self.streamDescriptionLabel.textColor = [UIColor blackColor];
    self.streamDescriptionLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    
    for (int ix = 0; ix < adNative.assetList.count; ++ix)
    {
        FlurryAdNativeAsset* asset = [adNative.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"headline"])
        {
            self.streamTitleLabel.text = asset.value;
        }
        if ([asset.name isEqualToString:@"summary"])
        {
            self.streamDescriptionLabel.text = asset.value;
        }
        if ([asset.name isEqualToString:@"secImage"])
        {
            self.streamImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.streamImageView setImageWithURL:[NSURL URLWithString:asset.value] placeholderImage:[UIImage imageNamed:@"streamImage"]];
        }
        if ([asset.name isEqualToString:@"source"] && asset.value != nil && [asset.value isKindOfClass:[NSString class]])
        {
            self.streamSourceLabel.text = asset.value;
        }
        
    }
    
    self.streamSponseredImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.streamSponseredImageView setImage:[UIImage imageNamed:@"icn_sponsored_dense"]];
    self.streamSponseredLabel.text =  @"SPONSORED";
    
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

+ (CGFloat) getHeightForAd:(FlurryAdNative*)ad withBounds:(CGSize)bounds;
{
    if (ad == nil || ad.assetList.count == 0)
    {
        return 0.0f;
    }
    
    NSString* headLine = nil;
    NSString* description = nil;
    for (int ix = 0; ix < ad.assetList.count; ++ix)
    {
        FlurryAdNativeAsset* asset = [ad.assetList objectAtIndex:ix];
        if ([asset.name isEqualToString:@"headline"])
        {
            headLine = asset.value;
        }
        if ([asset.name isEqualToString:@"summary"])
        {
            description = asset.value;
        }
    }

    int outerPadding = 4;
    int innerPadding = 8;
    
    int categoryColorView = 30;
    int imageSize = 90;
    
    CGSize titleSize = [Utils sizeForText:headLine
                                 fontSize:17.0
                                 fontName:@"Avenir-Heavy"
                                 maxWidth:(bounds.width - widthForNonText)
                                maxHeight:46];
    CGSize summarySize = [Utils sizeForText:description
                                   fontSize:14.0
                                   fontName:@"Avenir-Roman"
                                   maxWidth:(bounds.width - widthForNonText)
                                  maxHeight:85];
    
    int size1 = innerPadding + imageSize + innerPadding;
    int size2 = innerPadding + titleSize.height + innerPadding + summarySize.height;
    
    return outerPadding + categoryColorView + innerPadding + MAX(size1, size2) + innerPadding + outerPadding;
}

@end
