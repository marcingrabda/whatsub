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
#import "BTUtils.h"

@implementation FileHandler

- (id)init
{	
	self = [super init];
    if (self)
    {
        subtitlesFiles = [BTUtils typeExtensionsForName:@"Subtitles"];
        movieFiles = [BTUtils typeExtensionsForName:@"Movie"];        
        converter = [[SubtitlesConverter alloc] init];
        downloader = [[SubtitlesDownloader alloc] init];
    }
    return self;
}

- (void)startProcessingFiles:(NSArray*)files
{
    [progressIndicator setUsesThreadedAnimation:YES];
    [progressIndicator startAnimation:self];
    NSWindow* mainWindow = [[AppController instance] mainWindow];
    [NSApp beginSheet:loadingWindow modalForWindow:mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
    
    NSMutableString* errorMessage = [NSMutableString string];
	for (NSString* file in files) {
        @try
        {
            [self processFile:file];
        }
        @catch (NSException* e)
        {
            [errorMessage appendString:[[e reason] stringByAppendingString:@"\n"]];
        }
	}
    
    [progressIndicator stopAnimation:self];
    [NSApp endSheet:loadingWindow];
    [loadingWindow orderOut:self];
    
    if ([errorMessage length] > 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Oops..."];
        [alert setInformativeText:errorMessage];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

- (void)processFile:(NSString*)pathToFile
{   
    NSString* extension = [pathToFile pathExtension];
    if ([subtitlesFiles containsObject:extension])
    {
        [converter convert:pathToFile];
    }
    else if ([movieFiles containsObject:extension])
    {
        [downloader download:pathToFile];
    }
}

@end
