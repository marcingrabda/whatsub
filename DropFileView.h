//
//  MGDropFileView.h
//  WhatSub
//
//  Created by Marcin Grabda on 5/8/09.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppController;

@interface DropFileView : NSView {
@private
	NSArray* filenames;
}

@property (copy) NSArray* filenames;

- (void)drawCenteredAndRoundedRect;
- (void)drawCenteredText;
- (void)drawCenteredArrow;

@end
