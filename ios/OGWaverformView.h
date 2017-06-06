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
#import "OGWaveDelegateProtocol.h"
@class RCTBridge;

@interface OGWaverformView : UIView<NSURLConnectionDelegate>{
    NSInteger _sampleCount;
    Float32 _normalizeMax;
    float _imageHeight;
    float _imageWidth;
    
    Float32 *_samples;
    CGSize _graphSize;
}

typedef enum {
    DSWaveformStyleStripes = 0,
    DSWaveformStyleFull = 1
} DSWaveformStyle;


@property(nonatomic) UIColor *graphColor;
@property(nonatomic) DSWaveformStyle style;

@property(nonatomic) NSMutableData * mdata;
@property(nonatomic) NSDictionary * src;
@property(nonatomic) BOOL autoPlay;
@property(nonatomic) BOOL play;
@property(nonatomic) BOOL stop;

@property(nonatomic) BOOL isFrameReady;
@property(nonatomic) NSDictionary * waveFormStyle;
@property(nonatomic) UIColor * waveColor;
@property(nonatomic) UIColor * scrubColor;
@property(nonatomic) AVURLAsset *asset;
@property(nonatomic) UIView *scrubView;
@property(nonatomic) UIImageView *waveformImage;
@property(nonatomic) NSString *soundPath;
//@property(nonatomic) AVAudioPlayer *player ;
@property(nonatomic) AVPlayer *player ;
@property(nonatomic) NSTimer * playbackTimer;
@property(nonatomic) id<OGWaveDelegateProtocol> delegate;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;
@property(nonatomic) NSDictionary * propSrc;

//@property (nonatomic, strong) AVAudioPlayer *_audioPlayer;
@property (nonatomic, strong) AVPlayer *_audioPlayer;

- (instancetype)initWithBridge:(RCTBridge *)bridge NS_DESIGNATED_INITIALIZER;
- (NSData *) renderPNGAudioPictogramLogForAssett:(AVURLAsset *)songAsset;
- (void)updateProgress:(NSTimer*)timer;

@end
