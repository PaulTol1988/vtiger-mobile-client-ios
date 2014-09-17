//
//  CredentialsManager.m
//  CalendarAppThatSyncs
//
//  Created by Giovanni on 11/18/13.
//
//

#import "CredentialsHelper.h"
#import "Service.h"

//Used for storing app UUID in keychain and retrieve afterwards
#ifndef kServiceNameForKeychain
#define kServiceNameForKeychain @"com.gixWorks.FunctionalitiesApp"
#define kAccountNameForKeychainDevice @"deviceID"
#endif

#define kNSUserDefaultsServiceUrl @"ServiceURL"
#define kNSUserDefaultsUsername @"username"

@implementation CredentialsHelper

#pragma mark - Getting data

+ (NSString*)getDeviceID
{
    // Get device UDID
    // getting the unique key (if present ) from keychain , assuming "your app identifier" as a key
    NSString *deviceID = [SSKeychain passwordForService:kServiceNameForKeychain account:kAccountNameForKeychainDevice];
    if (deviceID == nil) { // if this is the first time app lunching , create key for device
        NSString *uuid  = [self createNewUUID];
        // save newly created key to Keychain
        [SSKeychain setPassword:uuid forService:kServiceNameForKeychain account:kAccountNameForKeychainDevice];
        // this is the one time process
        deviceID = uuid;
    }
    return deviceID;
}

+ (NSString*)getServiceUrl
{
    NSString* u = [Service getActiveServiceUrl];
    if (u == nil) {
        @throw [NSException exceptionWithName:@"No server url" reason:@"No server url specified in app" userInfo:nil];
    }
    return u;
}

+ (NSString*)getUsername
{
    return [Service getActiveServiceUsername];
}

+ (NSString*)getPassword
{
    return [SSKeychain passwordForService:[self getServiceUrl] account:[self getUsername]];
}

+ (NSString *)getSession
{
    return [SSKeychain passwordForService:[self getServiceUrl] account:@"session"];
}

#pragma mark - Saving data

+ (void)savePassword:(NSString*)password
{
    [SSKeychain setPassword:password forService:[self getServiceUrl] account:[self getUsername]];
}

+ (void)saveSession:(NSString *)session
{
    [SSKeychain setPassword:session forService:[self getServiceUrl] account:@"session"];
}

#pragma mark - Clearing data

+ (void)clearSession
{
    [SSKeychain deletePasswordForService:[self getServiceUrl] account:@"session"];
}

+ (void)cleaUsername
{
    [SSKeychain deletePasswordForService:[self getServiceUrl] account:[self getUsername]];
}

+ (void)clearCredentials
{
    [self clearSession];
    [self cleaUsername];
}

#pragma mark - UUID

+ (NSString *)createNewUUID {
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
