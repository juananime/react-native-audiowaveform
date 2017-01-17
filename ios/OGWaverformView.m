//
//  OGWaverformView.m
//  OGAudioWaveformGraph
//
//  Created by juan Jimenez on 09/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "OGWaverformView.h"
#import "OGWaveUtils.h"

//Using the solution exposed at http://stackoverflow.com/questions/8298610/waveform-on-io

@implementation OGWaverformView {
    __weak RCTBridge *_bridge;
    
}

#define absX(x) (x<0?0-x:x)
#define minMaxX(x,mn,mx) (x<=mn?mn:(x>=mx?mx:x))
#define noiseFloor (-20.0)
#define decibel(amplitude) (20.0 * log10(absX(amplitude)/32767.0))
#define imgExt @"png"
#define imageToData(x) UIImagePNGRepresentation(x)

-(void)setWaveFormStyle:(NSDictionary *)waveFormStyle{
    _leftWaveColor = [RCTConvert UIColor:[waveFormStyle objectForKey:@"leftWaveColor"]];
    _rightWaveColor = [RCTConvert UIColor:[waveFormStyle objectForKey:@"rightWaveColor"]];
    

    
}

-(void)reactSetFrame:(CGRect)frame{
    self.frame=frame;

    //Setup UI Views
    
    _waveformImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_waveformImage setImage:[UIImage imageWithData:[self renderPNGAudioPictogramLogForAssett:_asset]]];
    [self addSubview:_waveformImage];
    self.scrubView = [self getPlayerScrub];
    [self addSubview:self.scrubView];
    if(_autoPlay)
        [self playAudio];
}

-(void)setAutoPlay:(BOOL)autoPlay{
    _autoPlay=autoPlay;
}




-(void)playAudio{
    
    NSLog(@"PLAYING ::: %@",_soundPath);
    
    NSURL *soundURL = [NSURL fileURLWithPath:_soundPath];
    
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    if (error) {
        NSLog(@"ERROR ::: %@",[error localizedDescription]);
    }
    
    [_player play];
    _playbackTimer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                                   target:self
                                                 selector:@selector(updateProgress:)
                                                 userInfo:nil
                                                  repeats:YES];
    

}

-(void)updateProgress:(NSTimer *)timer{
    float total=_player.duration;
    float f=_player.currentTime / total;
    
    NSString *str = [NSString stringWithFormat:@"%f", f];
    
   // playbackProgress.progress=f;
    
    float currentXPosScrub = f*self.frame.size.width;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         CGRect frame = _scrubView.frame;
                         frame.origin.x = currentXPosScrub;
                         _scrubView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // whatever you need to do when animations are complete
                     }];
    
   // [_scrubView setFrame:CGRectMake(currentXPosScrub, 0, _scrubView.frame.size.width, _scrubView.frame.size.height)];
    
    NSLog(@"progress :: %@",str);
}

-(void)setSrc:(NSDictionary *)src{
   
    
    //Retrieve audio file
    
    NSString *uri =  [src objectForKey:@"uri"];
    
    //Since any file sent from JS side in Reeact Native is through HTTP, and
    //AVURLAsset just works wiht local files, then, downloading and processing.
    
    NSURL  *remoteUrl = [NSURL URLWithString:uri];
    NSData *urlData = [NSData dataWithContentsOfURL:remoteUrl];
    if ( urlData )
    {
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3",[OGWaveUtils randomStringWithLength:5]];
        _soundPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [urlData writeToFile:_soundPath atomically:YES];
        NSURL * localUrl = [NSURL fileURLWithPath: _soundPath];
        _asset = [AVURLAsset assetWithURL: localUrl];

    }
    


}

-(UIView *)getPlayerScrub{
    
    UIView *viewAux = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2,self.frame.size.height )];
    [viewAux setBackgroundColor:[UIColor redColor]];
    
    return viewAux;
    
}

-(UIImage *) audioImageLogGraph:(Float32 *) samples
                   normalizeMax:(Float32) normalizeMax
                    sampleCount:(NSInteger) sampleCount
                   channelCount:(NSInteger) channelCount
                    imageHeight:(float) imageHeight {
    
    CGSize imageSize = CGSizeMake(sampleCount, imageHeight);
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetAlpha(context,1.0);
    CGRect rect;
    rect.size = imageSize;
    rect.origin.x = 0;
    rect.origin.y = 0;
    NSLog(@"RColor : %@",_rightWaveColor);
    NSLog(@"LColor : %@",_leftWaveColor);
    CGColorRef leftcolor = [_leftWaveColor CGColor];
    CGColorRef rightcolor = [_rightWaveColor CGColor];
    
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, 1.0);
    
    float halfGraphHeight = (imageHeight / 2) / (float) channelCount ;
    float centerLeft = halfGraphHeight;
    float centerRight = (halfGraphHeight*3) ;
    float sampleAdjustmentFactor = (imageHeight/ (float) channelCount) / (normalizeMax - noiseFloor) / 2;
    
    for (NSInteger intSample = 0 ; intSample < sampleCount ; intSample ++ ) {
        Float32 left = *samples++;
        float pixels = (left - noiseFloor) * sampleAdjustmentFactor;
        CGContextMoveToPoint(context, intSample, centerLeft-pixels);
        CGContextAddLineToPoint(context, intSample, centerLeft+pixels);
        CGContextSetStrokeColorWithColor(context, leftcolor);
        CGContextStrokePath(context);
        
        if (channelCount==2) {
            Float32 right = *samples++;
            float pixels = (right - noiseFloor) * sampleAdjustmentFactor;
            CGContextMoveToPoint(context, intSample, centerRight - pixels);
            CGContextAddLineToPoint(context, intSample, centerRight + pixels);
            CGContextSetStrokeColorWithColor(context, rightcolor);
            CGContextStrokePath(context);
        }
    }
    
    // Create new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Tidy up
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (NSData *) renderPNGAudioPictogramLogForAssett:(AVURLAsset *)songAsset {
    
    NSError * error = nil;
    
    AVAssetReader * reader = [[AVAssetReader alloc] initWithAsset:songAsset error:&error];
    
    AVAssetTrack * songTrack = [songAsset.tracks objectAtIndex:0];
    
    NSDictionary* outputSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                        //     [NSNumber numberWithInt:44100.0],AVSampleRateKey, /*Not Supported*/
                                        //     [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,    /*Not Supported*/
                                        
                                        [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsNonInterleaved,
                                        
                                        nil];
    
    if(error){
        NSLog(@"ERROROR : %@",error.description);
    }
    
    
    AVAssetReaderTrackOutput* output = [[AVAssetReaderTrackOutput alloc] initWithTrack:songTrack outputSettings:outputSettingsDict];
    
    [reader addOutput:output];
    UInt32 sampleRate,channelCount;
    
    NSArray* formatDesc = songTrack.formatDescriptions;
    for(unsigned int i = 0; i < [formatDesc count]; ++i) {
        CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)[formatDesc objectAtIndex:i];
        const AudioStreamBasicDescription* fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription (item);
        if(fmtDesc ) {
            
            sampleRate = fmtDesc->mSampleRate;
            channelCount = fmtDesc->mChannelsPerFrame;
            
            //    NSLog(@"channels:%u, bytes/packet: %u, sampleRate %f",fmtDesc->mChannelsPerFrame, fmtDesc->mBytesPerPacket,fmtDesc->mSampleRate);
        }
    }
    
    UInt32 bytesPerSample = 2 * channelCount;
    Float32 normalizeMax = noiseFloor;
    NSLog(@"normalizeMax = %f",normalizeMax);
    NSMutableData * fullSongData = [[NSMutableData alloc] init];
    [reader startReading];
    
    UInt64 totalBytes = 0;
    
    Float64 totalLeft = 0;
    Float64 totalRight = 0;
    Float32 sampleTally = 0;
    
    NSInteger samplesPerPixel = sampleRate / 50;
    
    while (reader.status == AVAssetReaderStatusReading){
        
        AVAssetReaderTrackOutput * trackOutput = (AVAssetReaderTrackOutput *)[reader.outputs objectAtIndex:0];
        CMSampleBufferRef sampleBufferRef = [trackOutput copyNextSampleBuffer];
        
        if (sampleBufferRef){
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef);
            
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            totalBytes += length;
            
            
       
            
            NSMutableData * data = [NSMutableData dataWithLength:length];
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, data.mutableBytes);
            
            
            SInt16 * samples = (SInt16 *) data.mutableBytes;
            int sampleCount = length / bytesPerSample;
            for (int i = 0; i < sampleCount ; i ++) {
                
                Float32 left = (Float32) *samples++;
                left = decibel(left);
                left = minMaxX(left,noiseFloor,0);
                
                totalLeft  += left;
                
                
                
                Float32 right;
                if (channelCount==2) {
                    right = (Float32) *samples++;
                    right = decibel(right);
                    right = minMaxX(right,noiseFloor,0);
                    
                    totalRight += right;
                }
                
                sampleTally++;
                
                if (sampleTally > samplesPerPixel) {
                    
                    left  = totalLeft / sampleTally;
                    if (left > normalizeMax) {
                        normalizeMax = left;
                    }
                    // NSLog(@"left average = %f, normalizeMax = %f",left,normalizeMax);
                    
                    [fullSongData appendBytes:&left length:sizeof(left)];
                    
                    if (channelCount==2) {
                        right = totalRight / sampleTally;
                        
                        
                        if (right > normalizeMax) {
                            normalizeMax = right;
                        }
                        
                        [fullSongData appendBytes:&right length:sizeof(right)];
                    }
                    
                    totalLeft   = 0;
                    totalRight  = 0;
                    sampleTally = 0;
                    
                }
            }
            
       
            
            CMSampleBufferInvalidate(sampleBufferRef);
            
            CFRelease(sampleBufferRef);
        }
    }
    
    NSData * finalData = nil;
    
    if (reader.status == AVAssetReaderStatusFailed || reader.status == AVAssetReaderStatusUnknown){
        // Something went wrong. Handle it.
        NSLog(@"AVAssetReaderStatusFailed");
    }
    
    if (reader.status == AVAssetReaderStatusCompleted){
        // You're done. It worked.
        
        NSLog(@"rendering output graphics using normalizeMax %f",normalizeMax);
        
        UIImage *test = [self audioImageLogGraph:(Float32 *) fullSongData.bytes 
                                    normalizeMax:normalizeMax 
                                     sampleCount:fullSongData.length / (sizeof(Float32))
                                    channelCount:1
                                     imageHeight:60];
        
        finalData = imageToData(test);
    }        
    
    NSLog(@"DCDCDCDCD %@",self);
    
    return finalData;
}



- (instancetype)initWithBridge:(RCTBridge *)bridge
{
    if ((self = [super init])) {
        _bridge = bridge;
        
  
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
