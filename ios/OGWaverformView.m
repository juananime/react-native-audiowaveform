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
#define noiseFloor (-50.0)
#define decibel(amplitude) (20.0 * log10(absX(amplitude)/32767.0))
#define imgExt @"png"
#define imageToData(x) UIImagePNGRepresentation(x)

-(void)setWaveFormStyle:(NSDictionary *)waveFormStyle{
    _waveColor = [RCTConvert UIColor:[waveFormStyle objectForKey:@"waveColor"]];
    _scrubColor = [RCTConvert UIColor:[waveFormStyle objectForKey:@"scrubColor"]];
}

-(void)reactSetFrame:(CGRect)frame{
    self.frame=frame;

    //Setup UI Views
    NSLog(@"reactSetFrame ::: %@",_soundPath);
    
    _isFrameReady = YES;
    

    if(!_waveformImage)
        [self drawWaveform];
    
    
    [self addScrubber];
    

}

-(void)addScrubber{
    //Scrubber view
    if(_scrubView){
        
        
        [_scrubView removeFromSuperview];
        _scrubView = nil;
    }
    _scrubView = [self getPlayerScrub];
    [self addSubview:_scrubView];
    
}
-(void)drawWaveform{
    //Waveform image
    if(!_isFrameReady || !_asset)
        return;

    
    if(_waveformImage){
        [_waveformImage removeFromSuperview];
        _waveformImage = nil;
    }
    NSLog(@"drawWaveform :::: %@",self);
    _waveformImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_waveformImage setImage:[UIImage imageWithData:[self renderPNGAudioPictogramLogForAssett:_asset]]];
    _waveformImage.userInteractionEnabled = NO;
    
    //Scrubb player
    [self addSubview:_waveformImage];
}

-(void)initAudio{
    NSLog(@"initAudio ::: %@",_soundPath);
    NSURL *soundURL = [NSURL fileURLWithPath:_soundPath];
    NSError *error = nil;
    _player =[[AVPlayer alloc]initWithURL:soundURL];
    //_player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL fileTypeHint:AVFileTypeAIFF error:&error];
    if (error) {
        NSLog(@"ERROR ::: %@",[error localizedDescription]);
    }
}


-(void)setAutoPlay:(BOOL)autoPlay{
    _autoPlay=autoPlay;
}

-(void)setPlay:(BOOL)play{
    if(play){
        [self playAudio];
    }else{
        [self pauseAudio];
    }
}

-(void)pauseAudio{
    [_player pause];
    [_playbackTimer invalidate];
    _playbackTimer = nil;
}
-(void)playAudio{
    
    _playbackTimer=[NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(updateProgress:)
                                                 userInfo:nil
                                                  repeats:YES];
    [_player play];
}

-(void)setStop:(BOOL)stop{
    if(stop){
        //[_player stop];
    }
}

//Update progress scrubb
-(void)updateProgress:(NSTimer *)timer{
    AVPlayerItem *currentItem = _player.currentItem;
    float total = CMTimeGetSeconds(currentItem.duration);
    float currentTime = CMTimeGetSeconds(currentItem.currentTime);
    float f = 0.0;
    f = currentTime / total;
    
    float currentXPosScrub = f*self.frame.size.width;
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         CGRect frame = _scrubView.frame;
                         frame.origin.x = currentXPosScrub;
                         _scrubView.frame = frame;
                     }];
}

-(void)setSrc:(NSDictionary *)src{
   NSLog(@"SRC ::: %@",src);
    
    //Retrieve audio file
    
    NSString *uri =  [src objectForKey:@"uri"];
    
    
    
    //Since any file sent from JS side in Reeact Native is through HTTP, and
    //AVURLAsset just works wiht local files, then, downloading and processing.
    NSURL  *remoteUrl = [NSURL URLWithString:uri];
    
    NSLog(@"NSURLRequest :: %@",remoteUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:remoteUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES ];
    

    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _mdata = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mdata appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@.aac",[OGWaveUtils randomStringWithLength:5]];
    
    _soundPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    [_mdata writeToFile:_soundPath atomically:YES];

    NSURL * localUrl = [NSURL fileURLWithPath: _soundPath];
    _asset = [AVURLAsset assetWithURL: localUrl];
    
    [self drawWaveform];
    
    [self addScrubber];
    
    [self initAudio];
    
    if(_autoPlay)
        [self playAudio];

}




-(UIView *)getPlayerScrub{
    
    UIView *viewAux = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2,self.frame.size.height )];
    [viewAux setBackgroundColor:_scrubColor];
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
    
    NSLog(@"LColor : %@",_waveColor);
    CGColorRef wavecolor = [_waveColor CGColor];
    
    
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context , 1  );
    
    float halfGraphHeight = (imageHeight / 2) / (float) channelCount ;
    float centerLeft = halfGraphHeight;
    float centerRight = (halfGraphHeight*3) ;
    float sampleAdjustmentFactor = (imageHeight/ (float) channelCount) / (normalizeMax - noiseFloor) / 2;
    
    for (NSInteger intSample = 0 ; intSample < sampleCount ; intSample ++ ) {
        Float32 left = *samples++;
        float pixels = (left - noiseFloor) * sampleAdjustmentFactor;
        CGContextMoveToPoint(context, intSample, centerLeft-pixels);
        CGContextAddLineToPoint(context, intSample, centerLeft+pixels);
        CGContextSetStrokeColorWithColor(context, wavecolor);
        CGContextStrokePath(context);
        
       /** if (channelCount==2) {
            Float32 right = *samples++;
            float pixels = (right - noiseFloor) * sampleAdjustmentFactor;
            CGContextMoveToPoint(context, intSample, centerRight - pixels);
            CGContextAddLineToPoint(context, intSample, centerRight + pixels);
            CGContextSetStrokeColorWithColor(context, rightcolor);
            CGContextStrokePath(context);
        }**/
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
        _isFrameReady = NO;
        
  
    }
    return self;
}




#pragma mark OGWaveDelegateProtocol
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_delegate OGWaveOnTouch:self];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
