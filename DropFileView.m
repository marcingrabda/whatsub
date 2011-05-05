//
//  MGDropFileView.m
//  WhatSub
//
//  Created by Marcin Grabda on 5/8/09.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import "DropFileView.h"
#import "AppController.h"

@implementation DropFileView

@synthesize filenames;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		NSString* pboardType = NSFilenamesPboardType;		
		NSArray* dragTypes = [NSArray arrayWithObjects:pboardType,nil];
		[self registerForDraggedTypes:dragTypes];
    }
	
    return self;
}

- (void)drawRect:(NSRect)rect
{	
	[self drawCenteredAndRoundedRect];
	[self drawCenteredText];
	[self drawCenteredArrow];
}

- (void)drawCenteredText
{	
	NSRect rect = NSMakeRect(110, 0, 150, 50);
	NSDictionary* attrs = [NSMutableDictionary dictionary];
	NSFont* font = [NSFont fontWithName:@"Lucida Grande Bold" size:18];
	NSColor* color = [NSColor grayColor];
	
	[attrs setValue:font forKey:NSFontAttributeName];
	[attrs setValue:color forKey:NSForegroundColorAttributeName];
	
	[@"Drop File Here" drawInRect:rect withAttributes:attrs];
}

- (void)drawCenteredAndRoundedRect
{	
	NSRect rect = NSMakeRect(147, 70, 60, 60);
	
	NSColor* grayColor = [NSColor lightGrayColor];
	[grayColor set];
	
	NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:rect
														 xRadius:10
														 yRadius:10];
	[path setLineWidth:2];
	CGFloat a[2]; a[0]=13.0; a[1]=4.0;
	[path setLineDash: a
				count: 2
				phase: 0.0];
	
	[path stroke];
}

- (void)drawCenteredArrow
{	
	NSPoint point1 = NSMakePoint(165, 100);
	NSPoint point2 = NSMakePoint(177.5, 87);
	NSPoint point3 = NSMakePoint(190, 100);
	NSPoint point4 = NSMakePoint(181, 100);
	NSPoint point5 = NSMakePoint(181, 113);
	NSPoint point6 = NSMakePoint(174, 113);
	NSPoint point7 = NSMakePoint(174, 100);
	
	NSBezierPath* triangle = [NSBezierPath bezierPath];
	[triangle moveToPoint:point1];
	[triangle lineToPoint:point2];
	[triangle lineToPoint:point3];
	[triangle lineToPoint:point4];
	[triangle lineToPoint:point5];
	[triangle lineToPoint:point6];
	[triangle lineToPoint:point7];
	[triangle lineToPoint:point1];
	
	NSColor* grayColor = [NSColor lightGrayColor];
	[grayColor set];
	
	[triangle stroke];
	[triangle fill];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) 
	{
		[self setNeedsDisplay:YES];		
		return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
	[self setNeedsDisplay:YES];
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
	if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		self.filenames = files;
		
		AppController* appController = [NSApp delegate];
		[appController filesDragged:self];
    }	
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    [self setNeedsDisplay:YES];
}

@end
