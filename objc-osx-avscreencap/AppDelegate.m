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

@interface AppDelegate ()

@property (nonatomic) ScreenCapture *cappy;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.cappy = [[ScreenCapture alloc] init];
}

@end
