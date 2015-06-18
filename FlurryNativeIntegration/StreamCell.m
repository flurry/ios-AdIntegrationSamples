//
//  DemoCell.m
//  ios_ads_standalone
//
//  Created by Dan Dosch on 7/18/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import "StreamCell.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

static int widthForNonText = 162;

@interface StreamCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsDescriptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsSourceLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *topColorView1;
@property (weak, nonatomic) IBOutlet UIView *topColorView2;

@end

@implementation StreamCell

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
    self.newsTitleLabel.text = @"Lorem ipsum dolor";//newsItem.title;
    self.newsTitleLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    self.newsDescriptionLabel.text = @"Lorem ipsum dolor sit amet, putent nusquam placerat ne pri, cu eum paulo sapientem. In eos facer tantas. Per ex lorem viris postulant, at dicat essent nec, usu elitr maiestatis interesset te. Mel facer nobis dignissim an, omittam accusata at usu. In sed epicuri apeirian. Et cum eros accusata, nostrum propriae assentior in his, cu solet molestie adipisci sit.";//newsItem.summary;
    self.newsDescriptionLabel.preferredMaxLayoutWidth = self.bounds.size.width - widthForNonText;
    self.newsCategoryLabel.text = newsItem.category ? [newsItem.category uppercaseString] : @"NEWS";
    self.newsSourceLabel.text = @"News Publisher";//newsItem.publisher;

    self.newsImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *url = newsItem.image140x140URL ? newsItem.image140x140URL : newsItem.imageOriginalURL;
    if (url) {
        [self.newsImageView setImageWithURL:url];
    } else {
        self.newsImageView.image = [UIImage imageNamed:@"icon-76.png"];
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

+ (CGFloat)heightForNewsItem:(NewsItem *)newsItem withBounds:(CGSize)bounds {
    int outerPadding = 4;
    int innerPadding = 8;
    
    int categoryColorView = 30;
    int imageSize = 90;
    
    CGSize titleSize = [Utils sizeForText:newsItem.title
                                 fontSize:17.0
                                 fontName:@"Avenir-Heavy"
                                 maxWidth:(bounds.width - widthForNonText)
                                maxHeight:41];
    CGSize summarySize = [Utils sizeForText:newsItem.summary
                                   fontSize:14.0
                                   fontName:@"Avenir-Roman"
                                   maxWidth:(bounds.width - widthForNonText)
                                  maxHeight:50];
    
    int size1 = innerPadding + imageSize + innerPadding;
    int size2 = innerPadding + titleSize.height + innerPadding + summarySize.height;
    NSLog(@"heightForNewsItem, %d", (outerPadding + categoryColorView + innerPadding + MAX(size1, size2) + innerPadding + outerPadding + 5));
    return outerPadding + categoryColorView + innerPadding + MAX(size1, size2) + innerPadding + outerPadding + 5;
}

@end
