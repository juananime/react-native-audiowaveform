//
//  OGWaveManager.m
//  OGReactNativeWaveform
//
//  Created by juan Jimenez on 10/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "OGWaveManager.h"
#import "OGWaverformView.h"

@implementation OGWaveManager

RCT_EXPORT_VIEW_PROPERTY(waveFormStyle, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(src, NSDictionary);



- (UIView *)view
{
    return  [[OGWaverformView alloc] initWithBridge:self.bridge];
}
RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


@end
