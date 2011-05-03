//
//  AppController.m
//  WhatSub
//
//  Created by Marcin Grabda on 5/10/09.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import "AppController.h"
#import "DropFileView.h"
#import "AppPreferencesController.h"
#import "FileHandler.h"

@implementation AppController

- (id)init
{	
	if (self = [super init]) {
		fileHandler = [[FileHandler alloc] init];
	}
	return self;
}

+ (void)initialize
{
	// Register application defaults
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSString* defaultsFile = [mainBundle pathForResource:@"PreferencesDefaults" ofType:@"plist"];
	NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsFile];
	NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
	[standardUserDefaults registerDefaults:defaults];
}

- (IBAction)openPreferencesWindow:(id)sender
{
	[[AppPreferencesController sharedPrefsWindowController] showWindow:nil];
}

/* handle files dropped on the dock */
- (void)application:(NSApplication *)sender openFiles:(NSArray*)files
{	
	[fileHandler startProcessingFiles:files];
}

/* handle files dropped on the view area */
- (void)filesDragged:(DropFileView*)sender
{	
	NSArray* files = [sender filenames];
	[fileHandler startProcessingFiles:files];
}

/* handle files opened via the menu item */
- (IBAction)openFile:(id)sender
{	
	NSArray* allowedFileTypes = [NSArray arrayWithObjects:@"txt", @"avi", nil];
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
	
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setCanCreateDirectories:NO];
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setTitle:@"Select a file to open..."];
	
	if ([openPanel runModalForDirectory:nil file:nil types:allowedFileTypes] == NSOKButton)
	{
		NSArray* files = [openPanel filenames];
		[fileHandler startProcessingFiles:files];
	}
}

@end
