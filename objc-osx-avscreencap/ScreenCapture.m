//
//  ScreenCapture.m
//  objc-osx-avscreencap
//
//  Created by Gordon Childs on 24/12/2015.
//  Copyright © 2015 Gordon Childs. All rights reserved.
//

// checking out sample buffer bug with airpods!

#import "ScreenCapture.h"
#import <AVFoundation/AVFoundation.h>

@interface ScreenCapture() <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureOutput *videoOutput;

@end

@implementation ScreenCapture

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.captureSession = [[AVCaptureSession alloc] init];
        
        AVCaptureDevice *videoDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
        NSError *error;
        AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:&error];
        [self.captureSession addInput:videoInput];
        
        NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
        AVCaptureDevice *airpod = nil;
        
        // Find an input device with "AirPod" in the name.
        // You may need to change the search string
        for (AVCaptureDevice *device in devices) {
            if([device.localizedName containsString:@"AirPod"]) {
                airpod = device;
                break;
            }
        }
        if (airpod == nil) {
            // make sure your airpods are connected and change the above "AirPod" search string
            // if necessary.
            abort();
        }
        
        AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:airpod error:&error];
        [self.captureSession addInput:audioInput];
        
        AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [self.captureSession addOutput:audioOutput];
        
        
        AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.captureSession addOutput:videoOutput];
        [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        self.videoOutput = videoOutput;
        
        [self.captureSession startRunning];
    }
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (captureOutput == self.videoOutput) {
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTimeShow(pts);
    }
}

@end
