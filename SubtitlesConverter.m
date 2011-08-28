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
#import "AppController.h"

@implementation SubtitlesConverter

NSString* const TMP_REGEX = @"^(\\d+):(\\d+):(\\d+):(.*)";
NSString* const MDVD_REGEX = @"^\\{(\\d+)\\}\\{(\\d+)\\}(.*)";
NSString* const MPL2_REGEX = @"^\\[(\\d+)\\]\\[(\\d+)\\](.*)";

- (id)initWithSupportedMovieExtensions:(NSArray*)extensions andDefaultFrameRate:(NSNumber*)frameRate
{	
	self = [super init];
    if (self)
    {
        movieExtensions = extensions;
        defaultFrameRate = frameRate;
    }
    return self;
}

- (void)convert:(NSString*)inputPath toFile:(NSString*)outputPath forMovie:(NSString*)moviePath withEncoding:(NSStringEncoding)encoding
{	
	NSLog(@"Processing file %@", inputPath);
	NSArray* fileContents = [self readFile:inputPath];
    
	NSString* firstLine = [fileContents objectAtIndex:0];
    NSArray* subRipArray = nil;
    
    if ([[firstLine captureComponentsMatchedByRegex:TMP_REGEX] count] > 0)
    {
        subRipArray = [self processTMPlayer:fileContents];
    }
    else if ([[firstLine captureComponentsMatchedByRegex:MDVD_REGEX] count] > 0)
    {
        if (moviePath == nil)
        {
            NSString* partialPath = [inputPath stringByDeletingPathExtension];
            for (NSString* ext in movieExtensions)
            {
                NSString* path = [partialPath stringByAppendingPathExtension:ext];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                {
                    NSLog(@"Movie file found at %@", path);
                    moviePath = path;
                    break;
                }
            }
        }
        subRipArray = [self processMicroDVD:fileContents forMovie:moviePath];
    }
    else if ([[firstLine captureComponentsMatchedByRegex:MPL2_REGEX] count] > 0)
    {
        subRipArray = [self processMPL2:fileContents];
    }
    else
    {
        NSString* reason = @"Unknown subtitles format";
        NSException* e = [NSException exceptionWithName:@"SubtitlesException" reason:reason userInfo:nil];
        @throw e;
    }
    
    if (subRipArray != nil)
    {        
        [self printSubRip:subRipArray toFile:outputPath withEncoding:encoding];
    }
}

- (void)convertWithoutProcessing:(NSString*)inputPath toFile:(NSString*)outputPath withEncoding:(NSStringEncoding)encoding
{	
	NSLog(@"Converting file %@", inputPath);
	NSArray* fileContents = [self readFile:inputPath];
    
    NSMutableString* entireText = [NSMutableString string];
    for (NSArray* line in fileContents)
    {
        NSString* linePrint = [NSString stringWithFormat:@"%@\n", line, nil];
        [entireText appendString:linePrint];
    }
    
    NSData *data = [entireText dataUsingEncoding:encoding allowLossyConversion:YES];
    [data writeToFile:outputPath atomically:YES];
}

- (NSArray*)readFile:(NSString*)pathToFile
{
    NSError* error = nil;
    NSStringEncoding encoding = -1;
	NSString* fileContents = [NSString stringWithContentsOfFile:pathToFile usedEncoding:&encoding error:&error];
    
    if (fileContents == nil)
    {
        NSArray* encodings = [NSArray arrayWithObjects:
                              [NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding],
                              [NSNumber numberWithUnsignedInteger:NSWindowsCP1250StringEncoding],
                              [NSNumber numberWithUnsignedInteger:NSWindowsCP1252StringEncoding],
                              [NSNumber numberWithUnsignedInteger:NSISOLatin2StringEncoding],
                              [NSNumber numberWithUnsignedInteger:NSISOLatin1StringEncoding], nil];
        
        for (int i = 0; i < [encodings count] && fileContents == nil; i++)
        {
            encoding = [[encodings objectAtIndex:i] unsignedIntegerValue];
            fileContents = [NSString stringWithContentsOfFile:pathToFile encoding:encoding error:&error];
        }
        
        if (fileContents == nil)
        {
            NSString* reason = @"Unknown file encoding";
            NSException* e = [NSException exceptionWithName:@"SubtitlesException" reason:reason userInfo:nil];
            @throw e;
        }
    }
    
    NSLog(@"Encoding guessed: %@", [NSString localizedNameOfStringEncoding:encoding]);
	
	// try LF first
	NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    
	// if everything is in one line, try with CR again
	if ([lines count] < 2) {
		lines = [fileContents componentsSeparatedByString:@"\r"];
	}
    
    return lines;
}

- (NSArray*)processMicroDVD:(NSArray *)lines forMovie:(NSString *)moviePath
{
    double framerate = [defaultFrameRate doubleValue];
    if (moviePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:moviePath])
    {
        framerate = [FrameRateCalculator calculateFrameRateForMovieInPath:moviePath];
    }
    
    NSArray* capturesArray = nil;
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    
    for (NSString* line in lines) {
		capturesArray = [line captureComponentsMatchedByRegex:MDVD_REGEX];
        
        if ([capturesArray count] > 3)
        {
            int frameStart = [[capturesArray objectAtIndex:1] integerValue];
            double startTime = (double)frameStart / framerate;
            
            int frameEnd = [[capturesArray objectAtIndex:2] integerValue];
            double endTime = (double)frameEnd / framerate;
            
            NSString* text = [capturesArray objectAtIndex:3];            
            NSArray* singleLineArray = [NSArray arrayWithObjects:
                                        [NSNumber numberWithDouble:startTime],
                                        [NSNumber numberWithDouble:endTime], 
                                        text, nil];
            [outputArray addObject:singleLineArray];
        }   
	}
    
    return outputArray;
}

- (NSArray*)processMPL2:(NSArray *)lines
{
    NSArray* capturesArray = nil;
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    
    for (NSString* line in lines) {
		capturesArray = [line captureComponentsMatchedByRegex:MPL2_REGEX];
        
        if ([capturesArray count] > 3)
        {
            int frameStart = [[capturesArray objectAtIndex:1] integerValue];
            double startTime = (double)frameStart / 10;
            
            int frameEnd = [[capturesArray objectAtIndex:2] integerValue];
            double endTime = (double)frameEnd / 10;
            
            NSString* text = [capturesArray objectAtIndex:3];
            NSArray* singleLineArray = [NSArray arrayWithObjects:
                                        [NSNumber numberWithDouble:startTime],
                                        [NSNumber numberWithDouble:endTime],
                                        text, nil];
            [outputArray addObject:singleLineArray];
        }   
	}
    
    return outputArray;
}

- (NSArray*)processTMPlayer:(NSArray *)lines
{
    NSArray* capturesArray = nil;
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    
    for (NSString* line in lines) {
		capturesArray = [line captureComponentsMatchedByRegex:TMP_REGEX];
        
        if ([capturesArray count] > 4)
        {
            int hour = [[capturesArray objectAtIndex:1] integerValue];
            int minute = [[capturesArray objectAtIndex:2] integerValue];
            int second = [[capturesArray objectAtIndex:3] integerValue];
            
            int startTime = hour * 3600 + minute * 60 + second;
            int endTime = startTime + 5;
            
            NSString* text = [capturesArray objectAtIndex:4];
            NSMutableArray* singleLineArray = [NSMutableArray arrayWithObjects:
                                        [NSNumber numberWithInteger:startTime],
                                        [NSNumber numberWithInteger:endTime], 
                                        text, nil];
            [outputArray addObject:singleLineArray];
        }
	}
    
    NSMutableArray* previousLineArray = nil;
    int previousEndTime = 0;
    for (NSMutableArray* singleLineArray in outputArray)
    {
        int startTime = [[singleLineArray objectAtIndex:0] integerValue];
        int endTime = [[singleLineArray objectAtIndex:1] integerValue];
        
        if (previousEndTime > startTime)
        {
            [previousLineArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:startTime]];
        }
        
        previousLineArray = singleLineArray;
        previousEndTime = endTime;
    }
    
    return outputArray;
}

- (void)printSubRip:(NSArray *)input toFile:(NSString *)srtFilePath withEncoding:(NSStringEncoding)encoding
{
    NSMutableString* entireText = [NSMutableString string];
    int lineNumber = 1;
    for (NSArray* line in input)
    {
        NSNumber* start = [line objectAtIndex:0];
        NSString* formattedStart = [self formatSubRipTime:start];
        NSNumber* end = [line objectAtIndex:1];
        NSString* formattedEnd = [self formatSubRipTime:end];
        NSString* text = [line objectAtIndex:2];
        NSString* formattedText = [self formatSubRipText:text];
        
        NSString* linePrint = [NSString stringWithFormat:@"%d\n%@ --> %@\n%@\n\n", 
                           lineNumber++, formattedStart, formattedEnd, formattedText, nil];
        [entireText appendString:linePrint];
    }
    
    NSData *data = [entireText dataUsingEncoding:encoding allowLossyConversion:YES];
    [data writeToFile:srtFilePath atomically:YES];
}

/* time conversion from miliseconds */
- (NSString*)formatSubRipTime:(NSNumber*)value
{
    int intValue = [value intValue];
    float floatValue = [value floatValue];

    floatValue -= intValue;
    int miliseconds = floatValue * 1000;
    
    int hours = intValue / 3600;
    intValue -= hours * 3600;
    int minutes = intValue / 60;
    intValue -= minutes * 60;
    int seconds = intValue;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d,%03d", hours, minutes, seconds, miliseconds, nil];
}

/* TODO additional formatting for text */
- (NSString*)formatSubRipText:(NSString*)value
{
    /*
    NSMutableString* mutableValue = [[NSMutableString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, [mutableValue length]);
    [mutableValue replaceOccurrencesOfString:@"/" withString:@"" options:NSLiteralSearch range:range];
    [mutableValue replaceOccurrencesOfString:@"|" withString:@"\n" options:NSLiteralSearch range:range];
    return mutableValue;
     */
    value = [value stringByReplacingOccurrencesOfString:@"/" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
    return value;
}

@end
