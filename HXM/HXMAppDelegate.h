//
//  HXMAppDelegate.h
//  HXM
//
//  Created by Jason Kahn on 8/20/13.
//  Copyright (c) 2013 BCH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HXMModel.h"
#import "HXMMonitorView.h"

@interface HXMAppDelegate : NSObject <NSApplicationDelegate> {
	HXMModel *_model;
	NSArray *_subview;
	HXMMonitorView *_m0;
	__weak NSPopUpButton *HR2Color;
	__weak NSButton *loggingButton;
	__weak NSTextField *HR2;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong) NSMutableArray *deviceList;
@property (weak) IBOutlet NSScrollView *deviceItems;
@property (weak) IBOutlet NSTextField *HR1;
@property (weak) IBOutlet NSTextField *HR2;
@property (strong) NSArrayController *colorValueSelections;
@property (weak) IBOutlet NSPopUpButton *HR1Color;
@property (weak) IBOutlet NSPopUpButton *HR2Color;
@property (weak) IBOutlet NSButton *loggingButton;


- (IBAction)search:(id)sender;
- (void)updateHR:(int)HR forPlayer:(int)Player;
- (IBAction)P1ColorChanged:(id)sender;
- (IBAction)P2ColorChanged:(id)sender;
- (IBAction)toggleLogging:(id)sender;


@end
