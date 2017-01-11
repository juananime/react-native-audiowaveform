//
//  OGWaverformView.h
//  OGAudioWaveformGraph
//
//  Created by juan Jimenez on 09/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTResizeMode.h>
#import <AVFoundation/AVFoundation.h>
@class RCTBridge;

@interface OGWaverformView : UIImageView


@property(nonatomic) NSDictionary * src;
@property(nonatomic) NSDictionary * waveFormStyle;
@property(nonatomic) UIColor * leftWaveColor;
@property(nonatomic) UIColor * rightWaveColor;
@property(nonatomic) AVURLAsset *asset;

@property (nonatomic, strong) AVAudioPlayer *_audioPlayer;

- (instancetype)initWithBridge:(RCTBridge *)bridge NS_DESIGNATED_INITIALIZER;

- (NSData *) renderPNGAudioPictogramLogForAssett:(AVURLAsset *)songAsset;

@end
