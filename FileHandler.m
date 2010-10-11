//
//  FileHandler.m
//  WhatSub
//
//  Created by Marcin Grabda on 9/22/10.
//  Copyright 2010 burningtomato.com. All rights reserved.
//

#import "FileHandler.h"
#import "SubtitlesConverter.h"
#import "NapiProjektEngine.h"

@implementation FileHandler

- (id)init
{	
	if (self = [super init]) {
		converter = [[SubtitlesConverter alloc] init];
		
		// do parameters initialization (perhaps we should move it to initialize method)
		//[converter initialize];
		
		engine = [[NapiProjektEngine alloc] init];
		
		engine.lang = @"PL";
		engine.nick = @"grabka";
		engine.pass = @"alice";
	}
	
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
	//[converter convert:pathToFile];
	
	NSString* hash = nil;
	NSData* fileData = [engine retrieveSubtitlesForMovieInPath:pathToFile hash:&hash];
	
	NSString* temporaryDirectory = NSTemporaryDirectory();
	NSString* p7zipFileName = [hash stringByAppendingPathExtension:@"7z"];
	NSString* p7zipOutputFilePath = [temporaryDirectory stringByAppendingPathComponent:p7zipFileName];
	
	[fileData writeToFile:p7zipOutputFilePath atomically:YES];	
	
	NSString* p7zip = [[NSBundle mainBundle] pathForResource:@"7za" ofType:nil];
	NSArray* args = [NSArray arrayWithObjects:@"e", @"-y", @"-piBlm8NTigvru0Jr0", p7zipFileName, nil];
	
	NSTask* task = [[NSTask alloc] init];
	[task setCurrentDirectoryPath:temporaryDirectory];
	[task setLaunchPath:p7zip];
	[task setArguments:args];
	[task launch];
	[task waitUntilExit];
	
	NSString* subtitlesFileName = [hash stringByAppendingPathExtension:@"txt"];
}

@end
