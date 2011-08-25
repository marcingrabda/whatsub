//
//  FileHandler.m
//  WhatSub
//
//  Created by Marcin Grabda on 9/22/10.
//  Copyright 2010 burningtomato.com. All rights reserved.
//

#import "FileHandler.h"
#import "FileArchiver.h"
#import "SubtitlesConverter.h"
#import "SubtitlesDownloader.h"
#import "NapiProjektEngine.h"
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
    else
    {
        BOOL closeApp = [AppPreferences isClosingAppAfterProcessingEnabled];
        if (closeApp)
        {
            [NSApp terminate:self];
        }
    }
}

- (void)processFile:(NSString*)pathToFile
{   
    NSString* outputFilePath = nil;
    NSString* extension = [pathToFile pathExtension];
    NSStringEncoding outputEncoding = [AppPreferences getOutputEncoding];
    BOOL archive = [AppPreferences isArchivingIfFileExistsEnabled];
    SubtitlesConverter* converter = [[SubtitlesConverter alloc] initWithSupportedMovieExtensions:movieExtensions];
    FileArchiver* archiver = [[FileArchiver alloc] init];
    
    if ([subtitlesExtensions containsObject:extension])
    {
        outputFilePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"srt"];
        if (archive) [archiver archiveFileIfExists:outputFilePath];
        [converter convert:pathToFile toFile:outputFilePath forMovie:nil withEncoding:outputEncoding];
    }
    else if ([movieExtensions containsObject:extension])
    {
        NSString* outputFormat = [AppPreferences getOutputFormat];
        NSString* user = [AppPreferences getNPUsername];
        NSString* pass = [AppPreferences getNPPassword];
        NSString* lang = [AppPreferences getNPLanguageCode];
        
        NapiProjektEngine* engine = [[NapiProjektEngine alloc] initWithUser:user password:pass language:lang];
        SubtitlesDownloader* downloader = [[SubtitlesDownloader alloc] initWithEngine:engine];
        NSString* downloadedTmpFilePath = [downloader download:pathToFile];
        
        if ([outputFormat isEqualToString:@"SRT"])
        {
            outputFilePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"srt"];
            if (archive) [archiver archiveFileIfExists:outputFilePath];
            [converter convert:downloadedTmpFilePath toFile:outputFilePath forMovie:pathToFile withEncoding:outputEncoding];
        }
        else if ([outputFormat isEqualToString:@"TXT"])
        {
            outputFilePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"];
            if (archive) [archiver archiveFileIfExists:outputFilePath];
            [converter convertWithoutProcessing:downloadedTmpFilePath toFile:outputFilePath withEncoding:outputEncoding];
        }
    }
    
    NSLog(@"Subtitles written to %@", outputFilePath);
}


@end
