//
//  AppDelegate.m
//  objc-osx-avscreencap
//
//  Created by Gordon Childs on 23/11/2015.
//  Copyright © 2015 Gordon Childs. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "ScreenCapture.h"

@interface AppDelegate () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureScreenInput *captureScreenInput;

@property (nonatomic) ScreenCapture *cappy;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if (false) {
		NSError *error;
		[self createCaptureSession:&error];
	} else {
		self.cappy = [[ScreenCapture alloc] init];
	}
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void)captureSessionRuntimeErrorDidOccur:(NSNotification *)not {
	NSLog(@"Error %@", not);
}

- (BOOL)createCaptureSession:(NSError **)outError{
	/* Create a capture session. */
	self.captureSession = [[AVCaptureSession alloc] init];
	if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh])
	{
		/* Specifies capture settings suitable for high quality video and audio output. */
		[self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
	}
	
	/* Add the main display as a capture input. */
	CGDirectDisplayID display = CGMainDisplayID();
	self.captureScreenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:display];
	if ([self.captureSession canAddInput:self.captureScreenInput])
	{
		[self.captureSession addInput:self.captureScreenInput];
	}
	else
	{   NSLog(@"nevyslo");
		return NO;
	}
	
	/* Register for notifications of errors during the capture session so we can display an alert. */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureSessionRuntimeErrorDidOccur:) name:AVCaptureSessionRuntimeErrorNotification object:self.captureSession];
	
	
	AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
	[self.captureSession addOutput:output];
	
	dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
	[output setSampleBufferDelegate:self queue:queue];
	
	[self.captureSession startRunning];
	return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	
}
@end
