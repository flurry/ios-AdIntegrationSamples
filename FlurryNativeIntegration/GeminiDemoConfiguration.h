
#import <UIKit/UIKit.h>

@interface GeminiDemoConfiguration : NSObject

+ (id) sharedInstance;

// ad config
- (NSString*) apiKey;
- (NSString*) environment;
- (NSString*) adSpace;

// environment
- (NSString*) adServerHostName;
- (NSString*) adLogServerHostName;
- (NSString*) analyticsServerHostName;


@end