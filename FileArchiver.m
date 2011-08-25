//
//  Archiver.m
//  WhatSub
//
//  Created by Marcin Grabda on 8/25/11.
//  Copyright 2011 burningtomato.com. All rights reserved.
//

#import "FileArchiver.h"


@implementation FileArchiver

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)archiveFileIfExists:(NSString*)pathToFile
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:pathToFile];
    if (fileExists)
    {
        NSString* newFilePath = [pathToFile stringByAppendingPathExtension:@"bqp"];
        [fileManager moveItemAtPath:pathToFile toPath:newFilePath error:NULL];
    }
}

@end
