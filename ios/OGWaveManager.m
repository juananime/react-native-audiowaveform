//
//  OGWaveManager.m
//  OGReactNativeWaveform
//
//  Created by juan Jimenez on 10/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "OGWaveManager.h"
#import "OGWaverformView.h"
#import "UIView+React.h"


@implementation OGWaveManager

RCT_EXPORT_VIEW_PROPERTY(waveFormStyle, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(src, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(autoPlay, BOOL);
RCT_EXPORT_VIEW_PROPERTY(play, BOOL);
RCT_EXPORT_VIEW_PROPERTY(stop, BOOL);
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)



- (UIView *)view
{
    
    OGWaverformView *OGWaveformView =  [[OGWaverformView alloc] initWithBridge:self.bridge];
    [OGWaveformView setDelegate:self];
    return OGWaveformView;
}
RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

#pragma mark OGWaveDelegateProtocol
-(void)OGWaveOnTouch:(OGWaverformView *)waveformView{
    if(!waveformView.onPress)
        return;
    
    
    
    waveformView.onPress(@{@"onPress":@"true",@"currentStatus":@"playing"});
    
    
}
@end
