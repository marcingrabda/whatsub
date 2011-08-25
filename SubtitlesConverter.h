//
//  MGSubtitlesConverter.h
//  WhatSub
//
//  Created by Marcin Grabda on 1/26/10.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SubtitlesConverter : NSObject {
@private
    NSArray* movieExtensions;
}

- (id)initWithSupportedMovieExtensions:(NSArray*)extensions;
- (void)convert:(NSString*)input toFile:(NSString*)output forMovie:(NSString*)movie withEncoding:(NSStringEncoding)encoding;
- (void)convertWithoutProcessing:(NSString*)input toFile:(NSString*)output withEncoding:(NSStringEncoding)encoding;
- (NSArray*)readFile:(NSString*)pathToFile;
- (NSArray*)processTMPlayer:(NSArray*)lines;
- (NSArray*)processMicroDVD:(NSArray*)lines forMovie:(NSString*)pathToFile;
- (NSArray*)processMPL2:(NSArray*)lines;
- (void)printSubRip:(NSArray*)input toFile:(NSString*)srtFilePath withEncoding:(NSStringEncoding)encoding;
- (NSString*)formatSubRipTime:(NSNumber*)value;
- (NSString*)formatSubRipText:(NSString*)value;

@end
