//
//  AppController.h
//  WhatSub
//
//  Created by Marcin Grabda on 5/10/09.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DropFileView;
@class FileHandler;

@interface AppController : NSObject {
	FileHandler* fileHandler;
}

- (IBAction)openPreferencesWindow:(id)sender;
- (void)filesDragged:(DropFileView*)sender;
- (IBAction)openFile:(id)sender;

@end
