//
//  PersonModel.h
//  glimworm_ibeacon
//
//  Created by Jonathan Carter on 22/12/2013.
//  Copyright (c) 2013 Jonathan Carter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

@interface BTDeviceModel : NSObject {
    NSString * name;
    NSString * UUID;
    CFUUIDRef * uuidref;
    NSNumber * RSSI;
    CBPeripheral * peripheral;
    NSString * ib_uuid;
    NSString * ib_major;
    NSString * ib_minor;
    NSString * found;
    NSString * ID;

}
@property(retain, readwrite) NSString * name;
@property(retain, readwrite) NSString * UUID;
@property(retain, readwrite) NSNumber * RSSI;
@property(readwrite) CFUUIDRef * uuidref;
@property(retain, readwrite) CBPeripheral * peripheral;
@property(retain, readwrite) NSString * ib_uuid;
@property(retain, readwrite) NSString * ib_major;
@property(retain, readwrite) NSString * ib_minor;
@property(retain, readwrite) NSString * found;
@property(retain, readwrite) NSString * ID;

@end
