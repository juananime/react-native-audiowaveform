//
//  OGWaveManager.m
//  OGReactNativeWaveform
//
//  Created by juan Jimenez on 10/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "OGWaveManager.h"
#import "OGWaverformView.h"
#import <React/UIView+React.h>

@implementation OGWaveManager

RCT_EXPORT_VIEW_PROPERTY(waveFormStyle, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(src, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(autoPlay, BOOL);
RCT_EXPORT_VIEW_PROPERTY(play, BOOL);
RCT_EXPORT_VIEW_PROPERTY(stop, BOOL);
RCT_EXPORT_VIEW_PROPERTY(volume, float);
RCT_EXPORT_VIEW_PROPERTY(componentID, NSString);
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onFinishPlay, RCTBubblingEventBlock);

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
-(void)OGWaveOnTouch:(OGWaverformView *)waveformView componentID:(NSString *)componentID{
    if(!waveformView.onPress)
        return;

    waveformView.onPress(@{@"onPress":@"true",@"currentStatus":@"playing",@"componentID":componentID});
}
-(void)OGWaveFinishPlay:(OGWaverformView *)waveformView componentID:(NSString *)componentID{
    if(!waveformView.onFinishPlay)
        return;

    waveformView.onFinishPlay(@{@"onFinishPlay":@"true",@"currentStatus":@"stopped",@"componentID":componentID});
}
@end
