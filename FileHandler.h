//
//  FileHandler.h
//  WhatSub
//
//  Created by Marcin Grabda on 9/22/10.
//  Copyright 2010 burningtomato.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SubtitlesConverter;
@class SubtitlesDownloader;

@interface FileHandler : NSObject {
@private
    NSArray* subtitlesFiles;
    NSArray* movieFiles;
	SubtitlesConverter* converter;
	SubtitlesDownloader* downloader;
    IBOutlet NSWindow* loadingWindow;
    IBOutlet NSProgressIndicator* progressIndicator;
}

- (void)startProcessingFiles:(NSArray*)files;
- (void)processFile:(NSString*)pathToFile;

@end
