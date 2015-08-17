

#import "GeminiDemoConfiguration.h"

static GeminiDemoConfiguration* gInstance;

@interface GeminiDemoConfiguration ()

@property (nonatomic, retain) NSMutableDictionary* info;
@property (nonatomic, retain) NSMutableDictionary* envInfo;
@end


@implementation GeminiDemoConfiguration

+ (id) sharedInstance
{
    @synchronized(self)
    {
        if (gInstance == nil)
        {
            gInstance = [[self.class alloc] init];
            NSString *theFile = [[NSBundle mainBundle] pathForResource:@"GeminiDemoConfiguration" ofType:@"plist"];
            gInstance.info = [NSMutableDictionary dictionaryWithContentsOfFile:theFile];
            theFile = [[NSBundle mainBundle] pathForResource:@"GeminiEnvInfo" ofType:@"plist"];
            gInstance.envInfo = [NSMutableDictionary dictionaryWithContentsOfFile:theFile];
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


- (NSString*) adServerHostName
{
    return [[[[self.class sharedInstance] envInfo] objectForKey:self.environment] objectForKey:@"adAgentServerAddress"];
}

- (NSString*) adLogServerHostName
{
    return [[[[self.class sharedInstance] envInfo] objectForKey:self.environment] objectForKey:@"adLogAgentServerAddress"];
}

- (NSString*) analyticsServerHostName
{
    return [[[[self.class sharedInstance] envInfo] objectForKey:self.environment] objectForKey:@"analyticsServerAddress"];
}


@end