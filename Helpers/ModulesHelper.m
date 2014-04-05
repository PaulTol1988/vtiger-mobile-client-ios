//
//  ModulesHelper.m
//  ContactiCalVtiger
//
//  Created by Giovanni on 04/02/14.
//  Copyright (c) 2014 gixWorks. All rights reserved.
//

#import "ModulesHelper.h"
#import "CRMFieldConstants.h"

@implementation ModulesHelper

+ (NSString*)decodeModuleForRecordId:(NSString*)record
{
    NSString *m = [[record componentsSeparatedByString:@"x"] objectAtIndex:0];
    Module *module = [Module MR_findFirstByAttribute:@"crm_id" withValue:m];
    if (module != nil) {
        return module.crm_name;
    }
    else if([m isEqualToString:@"18"]){ //18 is still Calendar module but Vtiger does not list it when fetching modules
        return  kVTModuleCalendar;
    }
    return nil;
}

+ (NSString*)localizedModuleNameForRecord:(NSString*)record
{
    NSString *m = [[record componentsSeparatedByString:@"x"] objectAtIndex:0];
    Module *module = [Module MR_findFirstByAttribute:@"crm_id" withValue:m];
    if (module != nil) {
        return module.crm_label;
    }
    return nil;
}

+ (NSString*)localizedSingularModuleNameForRecord:(NSString*)record
{
    NSString *m = [[record componentsSeparatedByString:@"x"] objectAtIndex:0];
    Module *module = [Module MR_findFirstByAttribute:@"crm_id" withValue:m];
    if (module != nil) {
        return module.crm_singular;
    }
    else{
        if ([m isEqualToString:@"18"]) {  //Ugly because ID of some modules are not synced through vTiger
            Activity *a = [Activity MR_findFirstByAttribute:@"crm_id" withValue:record];
            return NSLocalizedString(a.crm_activitytype, @"This contains the crm_activitytype field");
        }
    }
    return nil;
}

+ (NSArray*)enabledModules
{
    //In the BETA we support only these modules
    return @[kVTModuleAccounts, kVTModuleContacts, kVTModuleLeads];
}

+ (NSString*)localizedLabelForModuleName:(NSString*)moduleName
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"service = %@ AND crm_name = %@", [Service getActive], moduleName];
    Module *module = [Module MR_findFirstWithPredicate:p];
    return module.crm_label;
}

+ (NSString*)moduleIdForModuleName:(NSString*)moduleName
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"service = %@ AND crm_name = %@", [Service getActive], moduleName];
    Module *module = [Module MR_findFirstWithPredicate:p];
    return module.crm_id;
}

+ (NSString *)moduleIdForCalendarRecordType:(NSString *)calendarRecordType
{
    if ([calendarRecordType isEqualToString:@"Call"] || [calendarRecordType isEqualToString:@"Meeting"]) {
        return @"18";
    }
    else if ([calendarRecordType isEqualToString:@"Task"]){
        return @"1";
    }
    return nil;
}

@end
