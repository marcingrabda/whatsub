//
//  FileHandler.h
//  WhatSub
//
//  Created by Marcin Grabda on 9/22/10.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SubtitlesConverter;
@class SubtitlesDownloader;
@class NapiProjektEngine;

@interface FileHandler : NSObject {
@private
    NSArray* subtitlesExtensions;
    NSArray* movieExtensions;
    IBOutlet NSWindow* loadingWindow;
    IBOutlet NSProgressIndicator* progressIndicator;
}

- (void)startProcessingFiles:(NSArray*)files;
- (void)processFile:(NSString*)pathToFile;

@end
