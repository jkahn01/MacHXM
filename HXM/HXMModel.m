//
//  HXMModel.m
//  HXM
//
//  Created by Jason Kahn on 8/20/13.
//  Copyright (c) 2013 BCH. All rights reserved.
//

#import "HXMModel.h"


@implementation HXMModel

- (HXMModel *) init {
	self = [super init];
	if (self) {
		//_inquiry  = [IOBluetoothDeviceInquiry inquiryWithDelegate:self];
		//_selector = [IOBluetoothDeviceSelectorController deviceSelector];
		osc = [[OSCManager alloc] init];
		oscOut = [osc createNewOutputToAddress:@"127.0.0.1" atPort:9000];
		devices = [[NSMutableArray alloc] initWithCapacity:4];
		players = -1;
		_logging = false;
	}
	return self;
}

- (HXMModel *) initWithDelegate:(id)delegate {
	self = [self init];
	_delegate = delegate;
	return self;
}

- (void) searchForDevices {
	NSLog(@"Here");
	_selector = [IOBluetoothDeviceSelectorController deviceSelector];
	[_selector runModal];
	_selectedDevice = [[_selector getResults] objectAtIndex:0];
	if (_selectedDevice) {
		IOBluetoothSDPServiceRecord *serviceRecord = [_selectedDevice getServiceRecordForUUID:[IOBluetoothSDPUUID uuid16:kBluetoothSDPUUID16ServiceClassSerialPort]];
		BluetoothRFCOMMChannelID channel;
		[serviceRecord getRFCOMMChannelID:&channel];
		HXMDevice *hxm = [[HXMDevice alloc] initWithDelegate:self];
		IOBluetoothRFCOMMChannel *_channel;
		[_selectedDevice openRFCOMMChannelAsync:&_channel withChannelID:channel delegate:hxm];
		players++;
		hxm.playerNumber = players;
		hxm.color = @"Black";
		[devices addObject:hxm];
		
	}
}

- (void) updateHR:(int)HR forPlayer:(int)Player {
	// pass the data up to the app delegate
	if ([_delegate respondsToSelector:@selector(updateHR:forPlayer:)])
		[_delegate updateHR:HR forPlayer:Player];
	
	// and try to broadcast over OSC
	OSCMessage *msg = [OSCMessage createWithAddress:@"/HXM"];
	HXMDevice *h = [devices objectAtIndex:Player];
	[msg addInt:Player];
	[msg addFloat:HR];
	[msg addFloat:0]; //HRV...
	[msg addFloat:0]; //"stress"
	[msg addString:h.color];
	
	[oscOut sendThisMessage:msg];
	
	//write log
	if (_logging && (file != nil)) {
		NSDate *d = [NSDate date];
		NSDateFormatter *f = [[NSDateFormatter alloc] init];
		[f setDateFormat:@"YYYY/MM/dd hh:mm:ss.SSS"];
		NSString *time = [f stringFromDate:d];
		NSString *output = [NSString stringWithFormat:@"%@,%i,%i\n", time, Player, HR];
		NSLog(output);
		[file writeData:[output dataUsingEncoding:NSUTF8StringEncoding]];
	}
}

- (void) setPlayer:(int)player color:(NSString *)color {
	if (player > players) return;
	HXMDevice *h = [devices objectAtIndex:player];
	h.color = color;
}

- (void) toggleLogging {
	_logging = !_logging;
	NSFileManager *fm = [[NSFileManager alloc] init];
	if (_logging) {
		//check if output directory exists
		NSString *outDir = @"~/RAGE-Logs/";
		outDir = [outDir stringByExpandingTildeInPath];
		BOOL isDir;
		[fm fileExistsAtPath:outDir isDirectory:&isDir];
		if (!isDir) {
			[fm createDirectoryAtPath:outDir
		  withIntermediateDirectories:NO
						   attributes:nil
								error:nil];
		}
		NSDate *d = [NSDate date];
		NSDateFormatter *f = [[NSDateFormatter alloc] init];
		[f setDateFormat:@"YYYY-MM-dd hh.mm.ss"];
		NSString *outFile = [f stringFromDate:d];
		outFile = [NSString stringWithFormat:@"%@/Log %@.csv", outDir, outFile];
		[fm createFileAtPath:outFile
					contents:nil
				  attributes:nil];
		file = [NSFileHandle fileHandleForWritingAtPath:outFile];
		[file writeData:[@"Time,Player,HR\n" dataUsingEncoding:NSUTF8StringEncoding]];
	} else {
		[file closeFile];
		file = nil;
	}
}

- (bool) logging {
	return _logging;
}

@end
