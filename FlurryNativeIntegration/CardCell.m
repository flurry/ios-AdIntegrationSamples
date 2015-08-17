//
//  CardCell.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 8/15/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "CardCell.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

static int widthForNonText = 24;

@interface CardCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsCategoryLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsSourceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsSummaryLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *topColorView1;
@property (weak, nonatomic) IBOutlet UIView *topColorView2;

@end

@implementation CardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupWithNewsItem:(NewsItem *)newsItem atPosition:(NSInteger)position {
    if ([Utils isPortrait]) {
        [self adjustForPortrait];
    } else {
        [self adjustForLandscape:newsItem];
    }
    
    self.newsTitleLabel.text = @"NEWS Title";//newsItem.title;
    self.newsTitleLabel.numberOfLines = 2;
    self.newsSummaryLabel.text = @"This one is breaking news. This is the summary of the news. Now you have read the entire news. :)";//newsItem.summary;
    self.newsCategoryLabel.text = @"fake category";//newsItem.category ? [newsItem.category uppercaseString] : @"NEWS";
    self.newsSourceLabel.text = @"Random Publisher";//newsItem.publisher;
    self.newsImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSURL *url = newsItem.image640x530URL ? newsItem.image640x530URL : newsItem.imageOriginalURL;
    if (url) {
        [self.newsImageView setImageWithURL:url];
    } else {
        self.newsImageView.image = nil;
        if ([Utils isPortrait]) {
            self.newsSummaryLabel.numberOfLines = 10;
        }
    }
    
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
    self.newsTitleLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    self.newsSummaryLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    self.newsSummaryLabel.numberOfLines = 3;
}

- (void)adjustForLandscape:(NewsItem *)newsItem {
    int padding = 8;
    int halfPadding = padding / 2;
    int totalWidth = self.containerView.frame.size.width;
    int totalHeight = self.containerView.frame.size.height;
    int halfWidth = totalWidth / 2;
    int textWidth = halfWidth - (padding + halfPadding);
    int usableHeight = totalHeight - self.topColorView1.frame.size.height - padding - padding;
    CGSize titleSize = [Utils sizeForText:newsItem.title fontSize:17.0 fontName:@"Avenir-Heavy" maxWidth:textWidth maxHeight:70];
    int usableSummaryHeight = usableHeight - ((3 * padding) + titleSize.height);
    CGSize summaryLineSize = [Utils sizeForText:@"." fontSize:14.0 fontName:@"Avenir-Roman" maxWidth:titleSize.width maxHeight:usableSummaryHeight];
    CGSize summarySize = [Utils sizeForText:newsItem.summary fontSize:14.0 fontName:@"Avenir-Roman" maxWidth:titleSize.width maxHeight:usableSummaryHeight];
    
    self.newsSummaryLabel.numberOfLines = summarySize.height / summaryLineSize.height;
    self.newsTitleLabel.preferredMaxLayoutWidth = textWidth;
    self.newsSummaryLabel.preferredMaxLayoutWidth = textWidth;
}

+ (CGFloat)heightForNewsItem:(NewsItem *)newsItem withBounds:(CGSize)bounds {
    if ([Utils isPortrait]) {
        return [CardCell heightForPortrait:newsItem withBounds:bounds];
    } else {
        return [CardCell heightForLandscape:newsItem withBounds:bounds];
    }
}

+ (CGFloat)heightForPortrait:(NewsItem *)newsItem withBounds:(CGSize)bounds {
    int outerPadding = 4;
    int innerPadding = 8;
    
    int categoryColorView = 30;
    
    CGFloat contentWidth = bounds.width - 24;
    int textWidth = bounds.width - widthForNonText;
    
    NSURL *url = newsItem.image640x530URL ? newsItem.image640x530URL : newsItem.imageOriginalURL;
    CGFloat imageHeight = url == nil ? 0 : contentWidth * (238.0 / 288.0) + 20;
    
    CGSize titleSize = [Utils sizeForText:newsItem.title
                                 fontSize:17.0
                                 fontName:@"Avenir-Heavy"
                                 maxWidth:(bounds.width - widthForNonText)
                                maxHeight:70];
    
    CGSize summaryFontSize = [Utils sizeForText:@"." fontSize:14.0 fontName:@"Avenir-Roman" maxWidth:textWidth maxHeight:100];
    CGSize summarySize = [Utils sizeForText:newsItem.summary
                                   fontSize:14.0
                                   fontName:@"Avenir-Roman"
                                   maxWidth:textWidth
                                  maxHeight:summaryFontSize.height * (url == nil ? 10 : 3)];
    
    return outerPadding + categoryColorView + innerPadding + titleSize.height + innerPadding + summarySize.height + innerPadding + imageHeight + innerPadding + outerPadding + 4;
}

+ (CGFloat)heightForLandscape:(NewsItem *)newsItem withBounds:(CGSize)bounds {
    int padding = 8;
    int halfPadding = padding / 2;
    int topColorViewHeight = 30;
    
    int totalWidth = bounds.width - 16;
    int totalHeight = bounds.height - 8;
    int halfWidth = totalWidth / 2;
    int usableHeight = totalHeight - topColorViewHeight - padding - padding;
    
    
    // Title
    CGSize titleSize = [Utils sizeForText:newsItem.title
                                 fontSize:17.0
                                 fontName:@"Avenir-Heavy"
                                 maxWidth:halfWidth - (padding + halfPadding)
                                maxHeight:70];
    
    // Summary
    int usableSummaryHeight = usableHeight - ((3 * padding) + titleSize.height);
    CGSize summarySize = [Utils sizeForText:newsItem.summary
                                   fontSize:14.0
                                   fontName:@"Avenir-Roman"
                                   maxWidth:titleSize.width
                                  maxHeight:usableSummaryHeight];
    
    
    // Image
    int imageHeight = halfWidth * (238.0 / 288);
    
    int heightForText = titleSize.height + padding + summarySize.height;
    
    return 4 + topColorViewHeight + padding + MAX(heightForText, imageHeight) + padding + 4;
}

@end
