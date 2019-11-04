//
//  AppDelegate.m
//  objc-osx-avscreencap
//
//  Created by Gordon Childs on 23/11/2015.
//  Copyright © 2015 Gordon Childs. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureOutput *videoOutput;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
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

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (captureOutput == self.videoOutput) {
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTimeShow(pts);
    }
}

@end
