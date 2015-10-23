//
//  GBBTManager.m
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Glimworm Beacons. All rights reserved.
//

#import "GBBTManager.h"
#import "BTDeviceModel.h"

@interface GBBTManager ()

@property (nonatomic, strong) CBPeripheral *peripheral;

@end

@implementation GBBTManager


- (instancetype)initWithDataSource:(GBTableDataSource *)ds
{
    self = [super init];
    if (self) {
        self.dataSource = ds;
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

-(void) startScanning
{
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey: @YES};
    //    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];

    [self.manager scanForPeripheralsWithServices:nil options:options];
}

-(void) stopScanning {
    [self.manager stopScan];
}

#pragma mark - Peripheral Connection and disconnection

/*
 Invoked whenever a connection is succesfully created with the peripheral.
 Discover available services on the peripheral
 */
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@" connectED ( %@ )", [aPeripheral name]);
    
    [self stopScanning];
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
    
    //    self.connected = @"Connected";
    //    [connectButton setTitle:@"Disconnect"];
    //    [indicatorButton setHidden:TRUE];
    //    [progressIndicator setHidden:TRUE];
    //    [progressIndicator stopAnimation:self];
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@" connect FAILED ( %@ )", [aPeripheral name]);
    
}
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@" DISconnectED ( %@ )", [aPeripheral name]);
    [self startScanning];       // should be appdelegate
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self.statusbox setStringValue:@"state update"];
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.statusbox setStringValue:@"state update powered on"];
        
        //        [self startScan];
        
    }
    // fixed crashing bug: This is optional but must be an empty string (@"") not nil.
    else if (central.state == CBCentralManagerStatePoweredOff) {
        [self.statusbox setStringValue:@"state update powered off"];
        NSAlert *alert = [NSAlert alertWithMessageText:@"Bluetooth is currently powered off." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
    }
    else if (central.state == CBCentralManagerStateUnauthorized) {
        [self.statusbox setStringValue:@"state update powered unauthorized"];
        NSAlert *alert = [NSAlert alertWithMessageText:@"The app is not authorized to use Bluetooth Low Energy." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
    }
    else if (central.state == CBCentralManagerStateUnsupported) {
        [self.statusbox setStringValue:@"state update powered unsupported"];
        NSAlert *alert = [NSAlert alertWithMessageText:@"The platform/hardware doesn't support Bluetooth Low Energy." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
    }
    
    
    
}

#pragma mark - Peripheral Discovery

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSString *value = [[NSString alloc] initWithFormat:@"disc %@ %@ %@", peripheral.name, RSSI, peripheral.UUID];
    //    NSString *_uuid = [[NSString alloc] initWithFormat:@"%@", peripheral.UUID];
    NSString *_uuid = [self uuidToString:peripheral.UUID];
    NSString *_name = [[NSString alloc] initWithFormat:@"%@", peripheral.name];
    //    NSString *_name = [[NSString alloc] initWithFormat:@"%@", peripheral.UUID];
    //    NSString *_name = [self uuidToString:peripheral.UUID];
    
    //    NSString *u = [self uuidToString:peripheral.UUID];
    
    //NSLog(@"CFSTRINGREF u %@",u);   // this is just the UUID
    //NSLog(@"CFSTRINGREF U %@",_uuid);
    
    NSMutableArray *myItems = self.dataSource.itemArray;
    
    @try {
        
        [self.statusbox setStringValue:value];
        
        if (_uuid == NULL) _uuid = @"";
        if (_name == NULL) _name = @"";
        
        for (int i=0; i < [myItems count]; i++) {
            BTDeviceModel *m = [myItems objectAtIndex:i];
            
            //NSLog(@"CFSTRINGREF MNAME %@",m.name);
            //NSLog(@"CFSTRINGREF UUID %@",m.UUID);
            
            if ([m.UUID isEqualTo: (_uuid)] || [m.UUID isEqualToString: (_uuid)])
                {
                m.RSSI = RSSI;
                m.name = _name;
                
                for (CBService* service in peripheral.services)
                    {
                    NSString *__uuid = [[NSString alloc] initWithFormat:@"LS : %@", service.UUID];
                    NSLog(@"%@",__uuid);
                    }
                
                
                for (id key in [advertisementData allKeys]){
                    id obj = [advertisementData objectForKey: key];
                    
                    //NSLog(@"key : %@  value : %@",key,obj);
                    
                    NSString *_key = [[NSString alloc] initWithFormat:@"%@", key];
                    
                    if ([_key isEqualToString:@"kCBAdvDataManufacturerData"]) {
                        NSString *ss2 = [NSString stringWithFormat:@"%@",obj];
                        //NSLog(@"ss2 : %@",ss2);
                        NSString *ib_uuid = [NSString stringWithFormat:@"%@-%@-%@-%@-%@%@",
                                             [ss2 substringWithRange:NSMakeRange(10, 8)],
                                             [ss2 substringWithRange:NSMakeRange(19, 4)],
                                             [ss2 substringWithRange:NSMakeRange(23, 4)],
                                             [ss2 substringWithRange:NSMakeRange(28, 4)],
                                             [ss2 substringWithRange:NSMakeRange(32, 4)],
                                             [ss2 substringWithRange:NSMakeRange(37, 8)]
                                             ];
                        NSString *ib_major = [NSString stringWithFormat:@"%@%@",
                                              [ss2 substringWithRange:NSMakeRange(46, 2)],
                                              [ss2 substringWithRange:NSMakeRange(48, 2)]];
                        
                        
                        NSString *ib_minor = [NSString stringWithFormat:@"%@%@",
                                              [ss2 substringWithRange:NSMakeRange(50, 2)],
                                              [ss2 substringWithRange:NSMakeRange(52, 2)]];
                        
                        m.ib_uuid = ib_uuid;
                        m.ib_major = [self hex2dec:ib_major];
                        m.ib_minor = [self hex2dec:ib_minor];
                        [self.dataSource findItemInAccountArray:m];
                        
                    }
                }
                
                return;
                }
        }
        
        [peripheral discoverServices:Nil];
        
        BTDeviceModel * pm = [[BTDeviceModel alloc] init];
        pm.name = _name;
        pm.UUID = _uuid;
        pm.RSSI = RSSI;
        pm.peripheral = peripheral;
        pm.ib_uuid = @"";
        pm.ib_major = @"";
        pm.ib_minor = @"";
        
        
        NSLog(@"%@",value);
        NSLog(@"%@", [advertisementData description]);
        NSLog(@"1000 %@",value);
        NSLog(@"2000 %@", [advertisementData description]);
        
        
        for (id key in [advertisementData allKeys]){
            id obj = [advertisementData objectForKey: key];
            
            NSLog(@"key : %@  value : %@",key,obj);
            
            NSString *_key = [[NSString alloc] initWithFormat:@"%@", key];
            
            
            if ([_key isEqualToString:@"kCBAdvDataManufacturerData"]) {
                NSString *ss2 = [NSString stringWithFormat:@"%@",obj];
                NSString *ib_uuid = [NSString stringWithFormat:@"%@-%@-%@-%@-%@%@",
                                     [ss2 substringWithRange:NSMakeRange(10, 8)],
                                     [ss2 substringWithRange:NSMakeRange(19, 4)],
                                     [ss2 substringWithRange:NSMakeRange(23, 4)],
                                     [ss2 substringWithRange:NSMakeRange(28, 4)],
                                     [ss2 substringWithRange:NSMakeRange(32, 4)],
                                     [ss2 substringWithRange:NSMakeRange(37, 8)]
                                     ];
                NSString *ib_major = [NSString stringWithFormat:@"%@",
                                      [ss2 substringWithRange:NSMakeRange(46, 4)]];
                
                NSString *ib_minor = [NSString stringWithFormat:@"%@",
                                      [ss2 substringWithRange:NSMakeRange(50, 4)]];
                
                NSLog(@"AdvDataArray: IBUUID : %@ ",ib_uuid);
                NSLog(@"AdvDataArray: IBMAJOR : %@ ",ib_major);
                NSLog(@"AdvDataArray: IBMINOR : %@ ",ib_minor);
                pm.ib_uuid = ib_uuid;
                pm.ib_major = [self hex2dec:ib_major];
                pm.ib_minor = [self hex2dec:ib_minor];
                
                
            }
        }
        
        [self.dataSource willChangeValueForKey:@"itemArray"];
        [self.dataSource.itemArray insertObject:pm atIndex:0];
        [self.dataSource didChangeValueForKey:@"itemArray"];
        [self.dataSource findItemInAccountArray:pm];
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        //        NSLog(@"finally");
    }
    
}


#pragma mark - Type Converters

- (NSString *) uuidToString:(CFUUIDRef)UUID {
    NSString *retval = CFBridgingRelease(CFUUIDCreateString(NULL, UUID));
    return retval;
}

- (NSString *) hex2dec:(NSString *)HEX {
    
    unsigned int ibmajor;
    NSScanner* scanner = [NSScanner scannerWithString:HEX];
    [scanner scanHexInt:&ibmajor];
    NSString *dec_string = [[NSString alloc] initWithFormat:@"%u", ibmajor];
    return dec_string;
}


@end
