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
#import "UIView+React.h"
@class RCTBridge;

@interface OGWaverformView : UIView


@property(nonatomic) NSDictionary * src;
@property(nonatomic) BOOL autoPlay;
@property(nonatomic) NSDictionary * waveFormStyle;
@property(nonatomic) UIColor * leftWaveColor;
@property(nonatomic) UIColor * rightWaveColor;
@property(nonatomic) AVURLAsset *asset;
@property(nonatomic) UIView *scrubView;
@property(nonatomic) UIImageView *waveformImage;
@property(nonatomic) NSString *soundPath;
@property(nonatomic) AVAudioPlayer *player ;
@property(nonatomic) NSTimer * playbackTimer;


@property (nonatomic, strong) AVAudioPlayer *_audioPlayer;

- (instancetype)initWithBridge:(RCTBridge *)bridge NS_DESIGNATED_INITIALIZER;
- (NSData *) renderPNGAudioPictogramLogForAssett:(AVURLAsset *)songAsset;
- (void)updateProgress:(NSTimer*)timer;

@end
