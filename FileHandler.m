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

@implementation FileHandler

- (id)init
{	
	if (self = [super init]) {
		converter = [[SubtitlesConverter alloc] init];
		downloader = [[SubtitlesDownloader alloc] init];
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
	//based on the file type convert or download
	//[converter convert:pathToFile]; or ...
	
	[downloader download:pathToFile];
}

@end
