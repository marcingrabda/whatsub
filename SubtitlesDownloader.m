//
//  SubtitlesDownloader.m
//  WhatSub
//
//  Created by Marcin Grabda on 5/3/11.
//  Copyright 2011 burningtomato.com. All rights reserved.
//

#import "SubtitlesDownloader.h"
#import "NapiProjektEngine.h"

@implementation SubtitlesDownloader

- (id)init
{	
	self = [super init];
	if (self)
    {
        engine = [[NapiProjektEngine alloc] init];
    }
    return self;
}

- (NSString*)download:(NSString*)pathToFile
{
	NSString* hash = nil;
	NSData* fileData = [engine retrieveSubtitlesForMovieInPath:pathToFile hash:&hash];
	
	if (fileData != nil)
	{
		NSString* temporaryDirectory = NSTemporaryDirectory();
		NSString* p7zipFileName = [hash stringByAppendingPathExtension:@"7z"];
		NSString* p7zipOutputFilePath = [temporaryDirectory stringByAppendingPathComponent:p7zipFileName];
		
		NSLog(@"Writing 7z file to %@", p7zipOutputFilePath);
		[fileData writeToFile:p7zipOutputFilePath atomically:YES];	
		
		NSString* p7zip = [[NSBundle mainBundle] pathForResource:@"7za" ofType:nil];
		NSArray* args = [NSArray arrayWithObjects:@"e", @"-y", @"-piBlm8NTigvru0Jr0", p7zipFileName, nil];
		
		NSTask* task = [[NSTask alloc] init];
		[task setCurrentDirectoryPath:temporaryDirectory];
		[task setLaunchPath:p7zip];
		[task setArguments:args];
		[task launch];
		[task waitUntilExit];
		
		NSString* subtitlesFileName = [p7zipOutputFilePath stringByDeletingPathExtension];
		NSString* filePath = [subtitlesFileName stringByAppendingPathExtension:@"txt"];
        return filePath;
	}
    else
    {
        NSString* reason = @"Corrupted subtitles file";
        NSException* e = [NSException exceptionWithName:@"SubtitlesException" reason:reason userInfo:nil];
        @throw e;
    }
}

@end
