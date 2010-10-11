//
//  MGFrameRateCalculator.m
//  WhatSub
//
//  Created by Marcin Grabda on 5/11/09.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import "FrameRateCalculator.h"
#import "RegexKitLite.h"

@implementation FrameRateCalculator

+ (float)calculateFrameRateForMovie:(QTMovie*)movie
{	
	NSArray* videoTracks = [movie tracksOfMediaType:QTMediaTypeVideo];
	QTTrack* firstVideoTrack = [videoTracks objectAtIndex:0];
	QTMedia* media = [firstVideoTrack media];
	
	QTTime QTTime = [[media attributeForKey:QTMediaDurationAttribute] QTTimeValue];
	long movieSeconds = [FrameRateCalculator convertQTTimeToSeconds:QTTime];
	NSLog(@"movie length in seconds: %ld", movieSeconds);
	
	long sampleCount = [[media attributeForKey:QTMediaSampleCountAttribute] longValue];
	NSLog(@"sampleCount: %ld", sampleCount);
	
	float calculatedFrameRate = (float)sampleCount / (float)movieSeconds;
	NSLog(@"framerate: %f", calculatedFrameRate);
	
	return calculatedFrameRate;
}

+ (float)calculateFrameRateForMovieInPath:(NSString*)filePath
{	
	NSError* error;
	
	NSLog(@"Loading movie: %@", filePath);
	QTMovie* movie = [QTMovie movieWithFile:filePath error:&error];
	
	return [self calculateFrameRateForMovie:movie];
}

+ (long)convertQTTimeToSeconds:(QTTime)QTTime
{	
	//0:01:45:43.21/25 = sign:days:hours:minutes:seconds:timevalue:timescale
	NSString* QTTimeDurationString = QTStringFromTime(QTTime);
	
	NSArray* separated = [QTTimeDurationString componentsSeparatedByRegex:@":"];
	
	long days = [[separated objectAtIndex:0] integerValue];
	long hours = [[separated objectAtIndex:1] integerValue];
	long minutes = [[separated objectAtIndex:2] integerValue];
	long seconds = [[separated objectAtIndex:3] integerValue];
	
	return 86400*days + hours*3600 + minutes*60 + seconds;
}

@end
