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
#import "AppPreferences.h"

@implementation FileHandler

- (id)init
{	
	self = [super init];
    if (self)
    {
        subtitlesExtensions = [AppPreferences typeExtensionsForName:@"Subtitles"];
        movieExtensions = [AppPreferences typeExtensionsForName:@"Movie"];        
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
    if ([subtitlesExtensions containsObject:extension])
    {
        NSString* outputFilePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"srt"];        
        [converter convert:pathToFile toFile:outputFilePath];
    }
    else if ([movieExtensions containsObject:extension])
    {
        NSString* outputFormat = [AppPreferences getOutputFormat];
        NSString* downloadedFilePath = [downloader download:pathToFile];
        if ([outputFormat isEqualToString:@"SRT"])
        {
            NSString* outputFilePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"srt"];
            [converter convert:downloadedFilePath toFile:outputFilePath];
        }
        else if ([outputFormat isEqualToString:@"TXT"])
        {
            NSString* outputFilePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"];
            NSFileManager* fileManager = [NSFileManager new];
            [fileManager copyItemAtPath:downloadedFilePath toPath:outputFilePath error:NULL];
        }
    }
}

@end
