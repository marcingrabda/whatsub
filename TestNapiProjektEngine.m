//
//  TestNapiProjektEngine.m
//  WhatSub
//
//  Created by Marcin Grabda on 6/1/11.
//  Copyright 2011 burningtomato.com. All rights reserved.
//

#import "TestNapiProjektEngine.h"
#import "NapiProjektEngine.h"

@implementation TestNapiProjektEngine

- (void)setUp
{
    [super setUp];
    
    engine = [NapiProjektEngine new];
}

- (void)tearDown
{
    engine = nil;
    
    [super tearDown];
}

- (void)testNPFDigest
{
    NSString* hash = @"e5270a8d39512ea6ccfc0e6164b9b18e";
    NSString* token = [engine npFDigest:hash];
    STAssertEqualObjects(@"2c489", token, @"");
}

@end
