

#import "GeminiDemoConfiguration.h"

static GeminiDemoConfiguration* gInstance;

@interface GeminiDemoConfiguration ()

@property (nonatomic, retain) NSMutableDictionary* info;

@end


@implementation GeminiDemoConfiguration

+ (id) sharedInstance
{
    @synchronized(self)
    {
        if (gInstance == nil)
        {
            gInstance = [[self.class alloc] init];
            NSString *theFile = [[NSBundle mainBundle] pathForResource:@"CardAdSpaceList" ofType:@"plist"];
            gInstance.info = [NSMutableDictionary dictionaryWithContentsOfFile:theFile];
        }
    }
    return gInstance;
}

- (NSString*) apiKey
{
    return [[[self.class sharedInstance] info] objectForKey:@"apiKey"];
}

- (NSString*) environment
{
    return [[[self.class sharedInstance] info] objectForKey:@"environment"];
}

- (NSString*) adSpace
{
    return [[[self.class sharedInstance] info] objectForKey:@"adSpace"];
}

@end