//
//  OGWaveDelegateProtocol.h
//  OGReactNativeWaveform
//
//  Created by juan Jimenez on 17/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OGWaverformView;

@protocol OGWaveDelegateProtocol <NSObject>

-(void)OGWaveOnTouch:(OGWaverformView *)waveformView;

@end

@interface OGWaveDelegateProtocol : NSObject

@end
