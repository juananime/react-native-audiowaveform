//
//  OGWaveUtils.m
//  OGReactNativeWaveform
//
//  Created by juan Jimenez on 17/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "OGWaveUtils.h"

@implementation OGWaveUtils

static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+(NSString *) randomStringWithLength: (int) len {

    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];

    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }

    return randomString;
}

@end
