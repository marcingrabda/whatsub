//
//  MGFrameRateCalculator.h
//  WhatSub
//
//  Created by Marcin Grabda on 5/11/09.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface FrameRateCalculator : NSObject {
@private
}

+ (float)calculateFrameRateForMovie:(QTMovie*)movie;
+ (float)calculateFrameRateForMovieInPath:(NSString*)filePath;
+ (long)convertQTTimeToSeconds:(QTTime)QTTime;

@end
