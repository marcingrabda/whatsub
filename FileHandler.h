//
//  FileHandler.h
//  WhatSub
//
//  Created by Marcin Grabda on 9/22/10.
//  Copyright 2010 burningtomato.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SubtitlesConverter;
@class NapiProjektEngine;

@interface FileHandler : NSObject {
	SubtitlesConverter* converter;
	NapiProjektEngine* engine;
}

- (void)startProcessingFiles:(NSArray*)files;
- (void)processFile:(NSString*)pathToFile;

@end
