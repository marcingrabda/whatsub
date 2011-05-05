//
//  BTUtils.m
//  WhatSub
//
//  Created by Marcin Grabda on 5/4/11.
//  Copyright 2011 burningtomato.com. All rights reserved.
//

#import "BTUtils.h"


@implementation BTUtils

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

+ (NSArray *) typeExtensionsForName:(NSString *)typeName
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

@end
