//
//  AppPreferencesWindowController.h
//  WhatSub
//
//  Created by Marcin Grabda on 2/8/10.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"

@interface AppPreferencesController : DBPrefsWindowController {
@private
	IBOutlet NSView* generalPrefsView;
	IBOutlet NSView* accountPrefsView;
    IBOutlet NSView* updatePrefsView;
}

@end
