//
//  AppUtil.m
//  WhatSub
//
//  Created by Marcin Grabda on 5/4/11.
//  Copyright 2011 burningtomato.com. All rights reserved.
//

#import "AppPreferences.h"


@implementation AppPreferences

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

+ (NSArray*)typeExtensionsForName:(NSString*)typeName
{
	int i;
	NSArray *typeList = [[[NSBundle mainBundle] infoDictionary]
                         objectForKey:@"CFBundleDocumentTypes"];
	for (i=0; i<[typeList count]; i++) {
		if ([[[typeList objectAtIndex:i] objectForKey:@"CFBundleTypeName"]
             isEqualToString:typeName])
			return [[typeList objectAtIndex:i] objectForKey:@"CFBundleTypeExtensions"];
	}
	return nil;
}

+ (NSString*)getNPUsername
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"NPUsername"];
}

+ (NSString*)getNPPassword
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"NPPassword"];    
}

+ (NSString*)getNPLanguageCode
{
    NSString* language = [[NSUserDefaults standardUserDefaults] valueForKey:@"NPLanguage"];
    NSDictionary* languages = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"PL", @"Polish",
							   @"EN", @"English", nil];
    return [languages objectForKey:language];
}

+ (NSString*)getOutputFormat
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OutputFormat"];    
}

+ (NSStringEncoding)getOutputEncoding
{
    NSString* encoding = [[NSUserDefaults standardUserDefaults] valueForKey:@"OutputEncoding"];    
    NSDictionary* encodings = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding], @"UTF-8",
                               [NSNumber numberWithUnsignedInteger:NSUTF16StringEncoding], @"UTF-16",
                               [NSNumber numberWithUnsignedInteger:NSISOLatin1StringEncoding], @"ISO-8859-1",
                               [NSNumber numberWithUnsignedInteger:NSWindowsCP1252StringEncoding], @"CP1252",
                               [NSNumber numberWithUnsignedInteger:NSISOLatin2StringEncoding], @"ISO-8859-2",
                               [NSNumber numberWithUnsignedInteger:NSWindowsCP1250StringEncoding], @"CP1250",
                               nil];
    NSNumber* encodingNumber = [encodings objectForKey:encoding];
    return [encodingNumber unsignedIntegerValue];
}

+ (NSNumber*)getDefaultFrameRate
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"DefaultFrameRate"];
}

+ (BOOL)getWrappedBooleanForKey:(NSString*)key
{
    NSNumber* wrappedBool = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return [wrappedBool boolValue];
}

+ (BOOL)isSRTOnlyConversionAllowed
{
    return [self getWrappedBooleanForKey:@"AllowSRTOnlyConversion"];
}

+ (BOOL)isClosingAppAfterProcessingEnabled
{
    return [self getWrappedBooleanForKey:@"CloseAppAfterProcessing"];
}

+ (BOOL)isArchivingIfFileExistsEnabled
{
    return [self getWrappedBooleanForKey:@"ArchiveIfFileExists"];
}

@end
