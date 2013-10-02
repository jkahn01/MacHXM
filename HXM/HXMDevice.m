//
//  HXMDeviceModel.m
//  HXM
//
//  Created by Jason Kahn on 8/22/13.
//  Copyright (c) 2013 BCH. All rights reserved.
//

#import "HXMDevice.h"

@implementation HXMDevice

@synthesize heartRate, threshold, color, playerNumber;

- (HXMDevice *) initWithDelegate:(id)delegate {
	self = [super init];
	if (self) {
		_delegate = delegate;
		self.playerNumber = 0;
	}
	return self;
}

// IOBluetoothRFCOMMChannelDelegate
- (void)rfcommChannelData:(IOBluetoothRFCOMMChannel*)rfcommChannel data:(void *)dataPointer length:(size_t)dataLength
{
    NSLog(@"%s", __func__);
	NSLog(@"Incomming bytes: %zi", dataLength);
	if (dataLength == 59) {
		Byte hr = *(Byte *)(dataPointer + 11);
		heartRate = (int) hr;
		if ([_delegate respondsToSelector:@selector(updateHR:forPlayer:)])
			[_delegate updateHR:self.heartRate forPlayer:self.playerNumber];
	}
}

- (void)rfcommChannelOpenComplete:(IOBluetoothRFCOMMChannel*)rfcommChannel status:(IOReturn)error
{
    NSLog(@"%s", __func__);
	
    IOReturn r;
	
    if(error != kIOReturnSuccess){
        NSLog(@"%s, error = 0x%x", __func__, error);
        r = [rfcommChannel closeChannel];
        if( r != kIOReturnSuccess){
            NSLog(@"closeChannel ON ERROR, 0x%x", r);
        }
    }
}

- (void)rfcommChannelClosed:(IOBluetoothRFCOMMChannel*)rfcommChannel
{
    NSLog(@"%s", __func__);
	
    IOReturn r;
    if([rfcommChannel isOpen]){
        r = [rfcommChannel closeChannel];
        if(r != kIOReturnSuccess){
            NSLog(@"closeChannel ON ERROR, 0x%x", r);
        }
    }
    
    IOBluetoothDevice *device = [rfcommChannel getDevice];
    if([device isConnected]){
        r = [device closeConnection];
        if(r != kIOReturnSuccess){
            NSLog(@"closeConnection ON ERROR, 0x%x", r);
        }
    }
}

- (void)rfcommChannelControlSignalsChanged:(IOBluetoothRFCOMMChannel*)rfcommChannel
{
    NSLog(@"%s", __func__);
}

- (void)rfcommChannelFlowControlChanged:(IOBluetoothRFCOMMChannel*)rfcommChannel
{
    NSLog(@"%s", __func__);
}

- (void)rfcommChannelWriteComplete:(IOBluetoothRFCOMMChannel*)rfcommChannel refcon:(void*)refcon status:(IOReturn)error
{
    NSLog(@"%s", __func__);
}

- (void)rfcommChannelQueueSpaceAvailable:(IOBluetoothRFCOMMChannel*)rfcommChannel
{
    NSLog(@"%s", __func__);
}

@end
