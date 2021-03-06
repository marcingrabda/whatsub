//
//  SubtitlesDownloader.h
//  WhatSub
//
//  Created by Marcin Grabda on 5/3/11.
//  Copyright 2011 Marcin Grabda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NapiProjektEngine;

@interface SubtitlesDownloader : NSObject {
@private
	NapiProjektEngine* engine;
}

- (id)initWithEngine:(NapiProjektEngine*)napiProjektEngine;
- (NSString*)download:(NSString*)pathToFile;

@end
