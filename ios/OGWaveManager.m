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
#import <AVFoundation/AVFoundation.h>

@implementation OGWaveManager

RCT_EXPORT_VIEW_PROPERTY(waveFormStyle, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(src, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(earpiece, BOOL);
RCT_EXPORT_VIEW_PROPERTY(autoPlay, BOOL);
RCT_EXPORT_VIEW_PROPERTY(play, BOOL);
RCT_EXPORT_VIEW_PROPERTY(stop, BOOL);
RCT_EXPORT_VIEW_PROPERTY(rate, float);
RCT_EXPORT_VIEW_PROPERTY(volume, float);
RCT_EXPORT_VIEW_PROPERTY(componentID, NSString);
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onFinishPlay, RCTBubblingEventBlock);

//- (instancetype) init {
//    self = [super init];
//
//    OGWaverformView *ogView = [[OGWaverformView alloc] initWithBridge: self.bridge];
//    [ogView setDelegate:self];
//
//    return self;
//}
//
//- (UIView *) view {
//    return self.ogView;
//}

- (UIView *)view
{
    OGWaverformView *OGWaveformView =  [[OGWaverformView alloc] initWithBridge:self.bridge];
    [OGWaveformView setDelegate:self];

    return OGWaveformView;
}

//RCT_EXPORT_MODULE();
RCT_EXPORT_MODULE(OGWaveManager);

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

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(onStopPlay:(nonnull NSString*)componentID withCallback:(RCTResponseSenderBlock)callback){
    NSLog(@"RCT_EXPORT_METHOD playerId-------------------------------%@", componentID);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        OGWaverformView* ogvVew = (OGWaverformView*)self.view;
//        [ogvVew onStopPlayer];
        [(OGWaverformView*)self.view onStopPlayer:(componentID)];
//        [(OGWaverformView*)self.view onStopPlayer];
//    });
}

@end
