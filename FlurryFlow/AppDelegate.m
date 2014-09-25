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
    //note: iOS only allows one crash reporting tool per app; if using another, set this to: NO
    [Flurry setCrashReportingEnabled:YES];
    
    // Replace this API key with YOUR_API_KEY acquired from Flurry's dev portal
    [Flurry startSession:@"2WZ22NRSX8W52VKZBX9G"];
    
    // Pointer to your rootViewController
    [FlurryAds initialize:_window.rootViewController];
    
    //to enable Flurry logging uncomment the following two lines
    //[Flurry setDebugLogEnabled:YES];
    //[Flurry setLogLevel:FlurryLogLevelAll];
    

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
