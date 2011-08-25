//
//  Archiver.h
//  WhatSub
//
//  Created by Marcin Grabda on 8/25/11.
//  Copyright 2011 burningtomato.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileArchiver : NSObject {
@private
    
}

- (void)archiveFileIfExists:(NSString*)pathToFile;

@end
