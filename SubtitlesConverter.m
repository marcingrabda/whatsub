//
//  MGSubtitlesConverter.m
//  WhatSub
//
//  Created by Marcin Grabda on 1/26/10.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import "SubtitlesConverter.h"
#import "FrameRateCalculator.h"
#import "RegexKitLite.h"

@implementation SubtitlesConverter

- (void)convert:(NSString*)pathToFile
{	
	NSLog(@"Processing file '%@'...", pathToFile);
	NSError* error = nil;
	
	NSString* fileContents = [NSString stringWithContentsOfFile:pathToFile
													   encoding:NSWindowsCP1250StringEncoding
														  error:&error];
	if (error != nil) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	
	// try LF first
	NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
	
	// if everything is in one line, try with CR again
	if ([lines count] < 2) {
		lines = [fileContents componentsSeparatedByString:@"\r"];
	}
	
	NSString* tmpRegexString = @"^(\\d+):(\\d+):(\\d+):(.*)";
	NSString* mdvdRegexString = @"^\\{(\\d+)\\}\\{(\\d+)\\}(.*)";
	NSString* mpl2RegexString = @"^\\[(\\d+)\\]\\[(\\d+)\\](.*)";
	
	NSString* regexString = mpl2RegexString;
	NSArray* capturesArray = nil;
	
	for (NSString* line in lines) {
		capturesArray = [line captureComponentsMatchedByRegex:regexString];
		NSLog(@"%@", capturesArray);
	}

	NSString* moviePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"avi"];
	float framerate = [FrameRateCalculator calculateFrameRateForMovieInPath:moviePath];
		
	/*
	int frameStart = [[capturesArray objectAtIndex:1] integerValue];
	float secondStart = (float)frameStart/framerate;
		
	int frameEnd = [[capturesArray objectAtIndex:2] integerValue];
	float secondEnd = (float)frameEnd/framerate;
	*/
}

@end
