//
//  MGNapiProjektEngine.h
//  WhatSub
//
//  Created by Marcin Grabda on 1/28/10.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NapiProjektEngine : NSObject {
}

- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr;
- (NSString*)npFDigest:(NSString*)input;
- (NSString*)md5ForFileInPath:(NSString*)path limitedTo10MB:(BOOL)limited;

@end
