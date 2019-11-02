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

@end

@implementation ScreenCapture

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.captureSession = [[AVCaptureSession alloc] init];
		
        if (0) {
            AVCaptureScreenInput *screenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];
            
            screenInput.minFrameDuration = CMTimeMake(1, 60);
            
            [self.captureSession addInput:screenInput];
        }

        if (1) {
            AVCaptureDevice *videoDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
            NSError *error;
            AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:&error];
            [self.captureSession addInput:videoInput];

        }
        
        NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
        AVCaptureDevice *airpod = nil;
        
        for (AVCaptureDevice *device in devices) {
            if([device.localizedName containsString:@"AirPod"]) {
                airpod = device;
                break;
            }
        }
        
        NSError *error;
        AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:airpod error:&error];
        [self.captureSession addInput:audioInput];
        AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [self.captureSession addOutput:audioOutput];

        
		
		AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
		[self.captureSession addOutput:output];
		
		// TODO: create a dedicated queue.
		[output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
		
		[self.captureSession startRunning];
	}
	return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	// sampleBuffer contains screen cap, for me it's yuv
	NSLog(@"buffer %@", sampleBuffer);
}

/*
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureError:) name:AVCaptureSessionRuntimeErrorNotification object:self.captureSession];
 
	- (void)captureError:(NSNotification *)notification {
 NSLog(@"Error %@", notification);
	}
 */

@end
