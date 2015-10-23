//
//  GBPeripheralDelegate.h
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Glimworm Beacons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

@interface GBPeripheralDelegate : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;

@end
