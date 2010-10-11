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

- (IBAction)openPreferencesWindow:(id)sender
{
	[[AppPreferencesController sharedPrefsWindowController] showWindow:nil];
}

/* handle a drop on the dock */
- (void)application:(NSApplication *)sender openFiles:(NSArray*)files
{	
	[fileHandler startProcessingFiles:files];
}

/* handle files dropped on the view area */
- (void)filesDragged:(DropFileView*)sender
{	
	[fileHandler startProcessingFiles:[sender filenames]];
}

/* handle files opened via the menu item */
- (IBAction)openFile:(id)sender
{	
	NSArray* fileTypes = [NSArray arrayWithObjects:@"txt", @"avi", nil];
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
	
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setCanCreateDirectories:NO];
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setTitle:@"Select a file to open..."];
	
	if ([openPanel runModalForDirectory:nil file:nil types:fileTypes] == NSOKButton)
	{
		NSArray* files = [openPanel filenames];
		[fileHandler startProcessingFiles:files];
	}
}

@end
