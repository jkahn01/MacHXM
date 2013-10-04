//
//  HXMAppDelegate.m
//  HXM
//
//  Created by Jason Kahn on 8/20/13.
//  Copyright (c) 2013 BCH. All rights reserved.
//

#import "HXMAppDelegate.h"

@implementation HXMAppDelegate
@synthesize HR2Color;
@synthesize HR2;
@synthesize HR1, colorValueSelections, HR1Color;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_model = [[HXMModel alloc] initWithDelegate:self];
	//colorValueSelections = [[NSArrayController alloc] init];
	//[colorValueSelections addObjects:@[@"Blue", @"Red"]];
	[HR1Color removeAllItems];
	[HR1Color addItemsWithTitles:@[@"Black", @"Blue", @"Green"]];
	
	[HR2Color removeAllItems];
	[HR2Color addItemsWithTitles:@[@"Black", @"Blue", @"Green"]];
}

- (void) updateHR:(int)HR forPlayer:(int)Player {
	NSLog(@"%03d", HR);
	NSNumber *h = [NSNumber numberWithInt:HR];
	NSString *h0 = [NSString stringWithFormat:@"%3@", h];
	switch (Player) {
		case 0:
			[HR1 setStringValue:h0];
			break;
		
		case 1:
			[HR2 setStringValue:h0];
			break;
			
		default:
			break;
	}

}

- (IBAction)P1ColorChanged:(id)sender {
	[_model setPlayer:0 color:[HR1Color titleOfSelectedItem]];
	//NSLog([HR1Color titleOfSelectedItem]);
}

- (IBAction)P2ColorChanged:(id)sender {
	[_model setPlayer:1 color:[HR2Color titleOfSelectedItem]];
}

- (IBAction)search:(id)sender {
	NSLog(@"yey");
	[_model searchForDevices];
}

@end
