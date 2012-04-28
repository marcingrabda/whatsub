//
//  AppPreferencesWindowController.m
//  WhatSub
//
//  Created by Marcin Grabda on 2/8/10.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import "AppPreferencesController.h"

@implementation AppPreferencesController

- (void)setupToolbar
{
	[self addView:generalPrefsView label:@"General"];
	[self addView:accountPrefsView label:@"Napiprojekt"];
    [self addView:updatePrefsView label:@"Auto Update"];
}

@end
