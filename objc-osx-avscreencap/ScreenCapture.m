//
//  ScreenCapture.m
//  objc-osx-avscreencap
//
//  Created by Gordon Childs on 24/12/2015.
//  Copyright © 2015 Gordon Childs. All rights reserved.
//

#import "ScreenCapture.h"
#import <AVFoundation/AVFoundation.h>

@interface ScreenCapture() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) AVCaptureSession *captureSession;

@end

@implementation ScreenCapture

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.captureSession = [[AVCaptureSession alloc] init];
		
		AVCaptureScreenInput *input = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];
		[self.captureSession addInput:input];

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
}

/*
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureError:) name:AVCaptureSessionRuntimeErrorNotification object:self.captureSession];

- (void)captureError:(NSNotification *)notification {
	NSLog(@"Error %@", notification);
}
 */

@end
