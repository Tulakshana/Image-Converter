//
//  AppDelegate.m
//  ImageConvertor
//
//  Created by Tulakshana on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)dealloc{
    [window release];
    window = nil;
    
    [super dealloc];
}
@end
