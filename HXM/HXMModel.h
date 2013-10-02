//
//  HXMModel.h
//  HXM
//
//  Created by Jason Kahn on 8/20/13.
//  Copyright (c) 2013 BCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import <IOBluetoothUI/IOBluetoothUI.h>
#import "HXMDevice.h"

@protocol UIDelegateAppSource <NSObject>
- (void)updateHR:(int)HR forPlayer:(int)Player;
@end

@interface HXMModel : NSObject {
	IOBluetoothDeviceInquiry *_inquiry;
	IOBluetoothDeviceSelectorController *_selector;
	IOBluetoothDevice *_selectedDevice;
	id _delegate;
	HXMDevice *_hxm0;
	OSCManager *osc;
	OSCOutPort *oscOut;
	int players;
	NSMutableArray *devices;
}

- (HXMModel *) init;
- (HXMModel *) initWithDelegate:(id)delegate;
- (void) searchForDevices;
- (void) updateHR:(int)HR forPlayer:(int)Player;
- (void) setPlayer:(int)player color:(NSString *)color;

@end
