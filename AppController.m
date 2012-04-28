//
//  AppController.m
//  WhatSub
//
//  Created by Marcin Grabda on 5/10/09.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import "AppController.h"
#import "DropFileView.h"
#import "AppPreferencesController.h"
#import "FileHandler.h"
#import "AppPreferences.h"

@implementation AppController

@synthesize mainWindow;

static AppController* instance = nil;

- (id)init
{	
	self = [super init];
    if (self)
    {
        instance = self;
        allowedFileTypes = [[AppPreferences typeExtensionsForName:@"Movie"] arrayByAddingObjectsFromArray:
                            [AppPreferences typeExtensionsForName:@"Subtitles"]];
    }    
	return self;
}

/* register application defaults */
+ (void)initialize
{
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSString* defaultsFile = [mainBundle pathForResource:@"Defaults" ofType:@"plist"];
	NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsFile];
	NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
	[standardUserDefaults registerDefaults:defaults];
}

+ (AppController*)instance
{
	return instance;
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
    NSMutableArray* filteredFiles = [NSMutableArray new];
    NSMutableArray* updatedAllowedFileTypes  = [[NSMutableArray alloc] initWithArray:allowedFileTypes];
    
    if (![AppPreferences isSRTOnlyConversionAllowed])
    {
        [updatedAllowedFileTypes removeObjectsInArray:[AppPreferences typeExtensionsForName:@"Subtitles"]];
    }
    
    for (NSString* file in files)
    {
        NSString* pathExtension = [file pathExtension];
        if ([updatedAllowedFileTypes containsObject:pathExtension])
        {            
            [filteredFiles addObject:file];
        }
    }
    
    if ([filteredFiles count] > 0)
    {
        [fileHandler startProcessingFiles:filteredFiles];
    }
}

/* handle files opened via the menu item */
- (IBAction)openFile:(id)sender
{	
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
