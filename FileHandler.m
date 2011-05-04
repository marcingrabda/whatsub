//
//  FileHandler.m
//  WhatSub
//
//  Created by Marcin Grabda on 9/22/10.
//  Copyright 2010 burningtomato.com. All rights reserved.
//

#import "FileHandler.h"
#import "SubtitlesConverter.h"
#import "SubtitlesDownloader.h"
#import "AppController.h"

@implementation FileHandler

- (id)init
{	
	[super init];
    
    converter = [[SubtitlesConverter alloc] init];
	downloader = [[SubtitlesDownloader alloc] init];	
	
    return self;
}

- (void)startProcessingFiles:(NSArray*)files
{
	for (NSString* file in files) {
		[self processFile:file];
	}
}

- (void)processFile:(NSString*)pathToFile
{
    [progressIndicator startAnimation:self];
    NSWindow* mainWindow = [[AppController instance] mainWindow];
    [NSApp beginSheet:loadingWindow modalForWindow:mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
    
    //based on the file type convert or download
	//[converter convert:pathToFile]; or ...
    
	[downloader download:pathToFile];
    
    [progressIndicator stopAnimation:self];
    [NSApp endSheet:loadingWindow];
    [loadingWindow orderOut:self];
}

@end
