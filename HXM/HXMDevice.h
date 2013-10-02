//
//  HXMDeviceModel.h
//  HXM
//
//  Created by Jason Kahn on 8/22/13.
//  Copyright (c) 2013 BCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import "VVOSC.h"

@protocol UIDelegateDataSource <NSObject>
- (void)updateHR:(int)HR forPlayer:(int)Player;
@end

@interface HXMDevice : NSObject<IOBluetoothRFCOMMChannelDelegate> {
	id<UIDelegateDataSource> _delegate;
	bool connected;
	//OSCManager *_manager;
}

@property int heartRate;
@property int threshold;
@property NSString *color;
@property int playerNumber;

- (HXMDevice *) initWithDelegate:(id)delegate;

@end
