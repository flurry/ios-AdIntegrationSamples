//
//  FlurryUtil.h
//  FlurryAnalytics
//
//  Created by chunhao on 2/12/10.
//  Copyright 2010 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Flurry.h"

#define CRITICAL_LOGX(string) \
if ([FlurryUtil logLevel] >= FlurryLogLevelCriticalOnly) { \
    NSLog(string); \
}

#define CRITICAL_LOG(format, ...) \
if ([FlurryUtil logLevel] >= FlurryLogLevelCriticalOnly) { \
    NSLog(format, __VA_ARGS__); \
}

#define DEBUG_LOGX(string) \
if ([FlurryUtil logLevel] >= FlurryLogLevelDebug) { \
NSLog(string); \
}

#define DEBUG_LOG(format, ...) \
if ([FlurryUtil logLevel] >= FlurryLogLevelDebug) { \
	NSLog(format, __VA_ARGS__); \
}

#define PRIVATE_LOGX(string) \
if (DEBUG) { \
    NSLog(string); \
}

#define PRIVATE_LOG(format, ...) \
if (DEBUG) { \
	NSLog(format, __VA_ARGS__); \
}

#define FLURRY_ASSERT(condition, msg) \
if (!(condition) && DEBUG) { \
    [NSException raise:@"Assertion Failure" format:@"%s [Line %d] " msg, __PRETTY_FUNCTION__, __LINE__]; \
}

#define INC_COUNTER(counter_name) \
 do {  \
    [FlurryUtil incrementCounter:counter_name locationName:(char*)__FUNCTION__]; \
 }while(0);

#define DEC_COUNTER(counter_name) \
 do {  \
    [FlurryUtil decrementCounter:counter_name locationName:(char*)__FUNCTION__]; \
 }while(0);


extern NSString * const kFlurryKeychainIdentifier;

enum CFUUIDBasedUIDStatus {
    NotApplicable = 0,
    NewlyGenerated = 1,
    ChecksumMatch = 2,
    ChecksumMismatch = 3,
    LengthMismatch = 4
};

float total_cpu_usage();
vm_size_t wiredMemoryUsage(void);
vm_size_t activeMemoryUsage(void);
vm_size_t inActiveMemoryUsage(void);
vm_size_t freeMemoryUsage(void);

@interface FlurryUtil : NSObject {

}

+ (void)assertThreadIsNotMain;
+ (void)setLogLevel:(FlurryLogLevel)value;
+ (FlurryLogLevel)logLevel;
+ (void)setShowErrorInLogEnabled:(BOOL)value;
+ (void)handleException:(id)e;
+ (NSString*) getOrientationStrFromInterfaceOrientation: (UIInterfaceOrientation) orientation;
+ (CGRect)screenBounds:(NSString *)orientation;
+ (CGRect)screenBounds;
+ (BOOL)canvasInLandscape:(NSString *)orientation;
+ (BOOL)canvasInLandscapeRight:(NSString *)orientation;
+ (BOOL)canvasInLandscapeLeft:(NSString *)orientation;
+ (BOOL)canvasInLandscape;
+ (BOOL)canvasInLandscapeRight;
+ (BOOL)canvasInLandscapeLeft;
+ (BOOL)canvasInPortraitUpsideDown;
+ (NSString *)getCanvasOrientation;
+ (BOOL)isIPad;
+ (BOOL)isRetina;
+ (NSInteger)getSystemVersionAsAnInteger;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+(NSString*) decodeFromPercentEscapeString:(NSString *)string;
+(NSString*) encodeToPercentEscapeString:(NSString *)string;
+(BOOL)viewIsVisible:(UIView *)view;
+(BOOL)theAppIsActive;
+ (BOOL)isPortaitOrientationSupportedForWindow:(UIWindow *)aWindow;
+ (void)generateChecksumTable;
+ (int)dataChecksum:(NSData *)data;
+ (BOOL) isKeyWindowAlertView;
+ (id)safeUnarchiveObjectWithFile:(NSString *)aPath;

// parse url params of the form header?key1=value1&key2=value2 
// and create a dictionary of key, value pairs. The header is parsed into the
// passed in paramsHeader. The key values part of the string is parsed into
// paramsKVString. paramsHeader and paramsKVString can be nil.
+ (NSMutableDictionary*) createParamKeysDictFromUrlParams: (NSString*) urlParams 
                                             paramsHeader: (NSString**) paramsHeader 
                                           paramsKVString: (NSString**) paramsKVString;


+ (NSRange) flurryRangeOfData: (NSData*) needle inData: (NSData*) haystack;


#pragma mark - 

// Utility Methods
+ (NSString *)devicePlatform;
+ (signed char)deviceIsJailbroken;
+ (signed char)appIsCracked;
+ (NSData *)hashData:(NSData*)data;
+ (NSString *)hashDataToHexString:(unsigned char*)chars length:(NSUInteger)length;

+ (NSData *)getMACUID;

// this routine makes a run-type check for adsupport to get idfa and doesn't require linking in AdSupport
+ (NSString*)getFlurryId;

+ (NSString*)getIdentifierForVendor;
+ (void) cleanupStoredIdentifierForVendor;
+ (NSString *)generateCFUUID;
+ (NSString *)generateCFUUIDBasedUID;
+ (NSString *)filePathDirectory;
+ (NSString *)oldFilePathDirectoryUptilAgentVersion109;
+ (NSString *)preferredLanguage;
+ (NSString *)md5String:(NSString*)inputString;

+ (void)incrementCounter:(NSString*)counterName;
+ (void)incrementCounter:(NSString*)counterName locationName: (char*) locationName;
+ (void)decrementCounter:(NSString*)counterName;
+ (void)decrementCounter:(NSString*)counterName locationName: (char*) locationName;
+ (void)printCounters;
+ (NSMutableDictionary*)allCounters;

+ (uint32_t)uint32FromNSUInteger:(NSUInteger)aValue;
+ (int32_t)int32FromNSInteger:(NSInteger)aValue;
+ (float)getBatteryLevel;
+ (UIDeviceBatteryState)getBatteryState;
+ (uint64_t)getFreeDiskspace;
+ (uint64_t)getDiskSize;
+ (long)lastBootTime;

+ (void) setFlurryOptOut:(BOOL)value;
+ (BOOL) hasUserOptedOut;


@end
