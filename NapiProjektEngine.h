//
//  MGNapiProjektEngine.h
//  WhatSub
//
//  Created by Marcin Grabda on 1/28/10.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NapiProjektEngine : NSObject {
@private
    NSString* user;
    NSString* pass;
    NSString* lang;
}

- (id)initWithUser:(NSString*)username password:(NSString*)password language:(NSString*)langCode;
- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr;
- (NSString*)getURLForHash:(NSString*)hash token:(NSString*)token;
- (NSString*)npFDigest:(NSString*)input;
- (NSString*)md5ForFileInPath:(NSString*)path limitedTo10MB:(BOOL)limited;

@end
