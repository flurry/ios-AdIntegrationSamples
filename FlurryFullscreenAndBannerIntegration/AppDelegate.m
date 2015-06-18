//
//  AppDelegate.m
//  FlurryInegrationSamples
//
//  Created by Flurry on 3/24/14.
//  Copyright (c) 2014 Flurry. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "FlurryAds.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Replace this API key with YOUR_API_KEY acquired from Flurry's dev portal
    

    NSString* plistFile =[ [NSBundle mainBundle] pathForResource: @"StreamAdSpaceList"  ofType: @"plist" ];
    NSMutableDictionary* info;
    info = [NSMutableDictionary dictionaryWithContentsOfFile:plistFile];
    
    NSString* apiKEY = [ info objectForKey:@"apiKey"] ;
    
    
    [Flurry startSession: apiKEY];//@"6Z27CWHJXRC29QVJZX4R"];//
    
    
    //to enable Flurry logging uncomment the following two lines
    [Flurry setDebugLogEnabled:YES];
    [Flurry setLogLevel:FlurryLogLevelAll];
    

    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
