//
//  MGSubtitlesConverter.h
//  WhatSub
//
//  Created by Marcin Grabda on 1/26/10.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SubtitlesConverter : NSObject {
}

- (void)convert:(NSString*)pathToFile;
- (NSArray*)processTMPlayer:(NSArray*)lines;
- (NSArray*)processMicroDVD:(NSArray*)lines forMovie:(NSString*)pathToFile;
- (NSArray*)processMPL2:(NSArray*)lines;
- (void)printSubRip:(NSArray*)input toFile:(NSString*)srtFilePath;
- (NSString*)formatSubRipTime:(NSNumber*)value;
- (NSString*)formatSubRipText:(NSString*)value;

@end
