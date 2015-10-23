//
//  GBPeripheralDelegate.m
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Glimworm Beacons. All rights reserved.
//

#import "GBPeripheralDelegate.h"

@interface GBPeripheralDelegate ()

@end

@implementation GBPeripheralDelegate


#pragma mark - Service Discovery

- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    
    NSLog(@" servicesDISCOVERED ( %@ )", [aPeripheral name]);
    for (CBService *service in aPeripheral.services) {
        NSLog(@"Discovered service s: %@", service);
        NSLog(@"Discovered service u: %@", service.UUID);
        
        /* connect to serial bluetooth */
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
            {
            [aPeripheral discoverCharacteristics:nil forService:service];
            }
    }
}


#pragma mark - Characteristics Discovery

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
        {
        for (CBCharacteristic *aChar in service.characteristics)
            {
            /* Set notification on heart rate measurement */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]])
                {
                NSLog(@"Found a serial connectionCharacteristic, properties %@", aChar.UUID);
                
                [p_name_ml setStringValue:@"Found a serial connectionCharacteristic, enquiring about name"];
                
                [aPeripheral setNotifyValue:YES forCharacteristic:aChar];
                
                //                NSString *val = @"AT+NAME? ";
                //                NSData* payload = [val dataUsingEncoding:NSUTF8StringEncoding];
                //                [aPeripheral writeValue:payload forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
                
                _currentChar = aChar;
                self.peripheral = aPeripheral;
                
                [self working];
                [self performSelector:@selector(q_readall) withObject:self afterDelay:3.0];
                //                [self q_readall];
                
                
                }
            }
        }
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"-- didWriteValueForCharacteristic");
    /* Updated value for heart rate measurement received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]])
        {
        if( (characteristic.value)  || !error )
            {
            /* Update UI with heart rate data */
            NSLog(@"wrote characteristic val: %@ , %@", characteristic.value, characteristic.UUID);
            [p_log setStringValue: [[NSString alloc] initWithFormat:@"written : %@", characteristic.value] ];
            }
        }
    
}

/*
 this is the one that gets called
 */

- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"-- didUpdateValueForCharacteristic");
    
    /* Updated value for heart rate measurement received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]])
        {
        if( (characteristic.value)  || !error )
            {
            /* Update UI with heart rate data */
            NSLog(@"updated characteristic val: %@ , %@", characteristic.value, characteristic.UUID);
            
            NSString *str=[[NSString alloc] initWithBytes:characteristic.value.bytes length:characteristic.value.length encoding:NSUTF8StringEncoding];
            NSLog(@"retval %@", str);
            
            NSString *logmessage = [[NSString alloc] initWithFormat:@"'%@' : '%@'", currentcommand, str];
            
            [p_log setStringValue: logmessage ];
            
            NSLog(@"currentcommand %@", currentcommand);
            NSLog(@"currentcommand:retval %@", str);
            
            if ([currentcommand isEqualToString:@"AT+VERS?"]) {
                
                NSArray *array = [str componentsSeparatedByString:@" "];
                [p_firmware setStringValue:array[1]];
                currentfirmware = [[NSString alloc] initWithFormat:@"%@", array[1]];
                
                if ([currentfirmware isEqualToString:@"V517"]) {
                    // dvert 0 = 100 , 1 = 1280
                    
                } else if ([currentfirmware isEqualToString:@"V518"]) {
                    
                } else if ([currentfirmware isEqualToString:@"V519"]) {
                    
                } else if ([currentfirmware isEqualToString:@"V520"]) {
                    
                } else if ([currentfirmware isEqualToString:@"V521"]) {
                    
                } else if ([currentfirmware isEqualToString:@"V522"]) {
                    
                }
                
            }
            
            if ([currentcommand isEqualToString:@"AT+POWE?"]) {
                NSArray *array = [str componentsSeparatedByString:@":"];
                NSLog(@"array %@",array[1]);
                int val = [array[1] intValue];
                if (val == 0) {
                    p5m.state = 0;
                    p50m.state = 0;
                    p100m.state = 0;
                }
                if (val == 1) {
                    p5m.state = 1;
                    p50m.state = 0;
                    p100m.state = 0;
                }
                if (val == 2) {
                    p5m.state = 0;
                    p50m.state = 1;
                    p100m.state = 0;
                }
                if (val == 3) {
                    p5m.state = 0;
                    p50m.state = 0;
                    p100m.state = 1;
                }
            }
            
            if ([currentcommand isEqualToString:@"AT+ADVI?"]) {
                NSArray *array = [str componentsSeparatedByString:@":"];
                
                NSLog(@"array %@",array[1]);
                //int val = [array[1] intValue];
                NSString *Val = array[1];
                
                [self clearadvertisingbuttonstates];
                
                if ([self has16advertisments] == FALSE) {
                    
                    if ([Val isEqualToString:@"0"]) p_adv_100.state = 1;
                    if ([Val isEqualToString:@"1"]) p_adv_1280a.state = 1;
                } else {
                    if ([Val isEqualToString:@"0"]) p_adv_100.state = 1;
                    if ([Val isEqualToString:@"1"]) p_adv_152.state = 1;
                    if ([Val isEqualToString:@"2"]) p_adv_211.state = 1;
                    if ([Val isEqualToString:@"3"]) p_adv_318.state = 1;
                    if ([Val isEqualToString:@"4"]) p_adv_417.state = 1;
                    if ([Val isEqualToString:@"5"]) p_adv_546.state = 1;
                    if ([Val isEqualToString:@"6"]) p_adv_760.state = 1;
                    if ([Val isEqualToString:@"7"]) p_adv_852.state = 1;
                    if ([Val isEqualToString:@"8"]) p_adv_1022.state = 1;
                    if ([Val isEqualToString:@"9"]) p_adv_1280a.state = 1;
                    if ([Val isEqualToString:@"A"]) p_adv_2000.state = 1;
                    if ([Val isEqualToString:@"B"]) p_adv_3000.state = 1;
                    if ([Val isEqualToString:@"C"]) p_adv_4000.state = 1;
                    if ([Val isEqualToString:@"D"]) p_adv_5000.state = 1;
                    if ([Val isEqualToString:@"E"]) p_adv_6000.state = 1;
                    if ([Val isEqualToString:@"F"]) p_adv_7000.state = 1;
                    
                }
                
            }
            
            
            
            if ([currentcommand isEqualToString:@"AT+BATT?"]) {
                
                NSLog(@"currentcommand MATCHED");
                
                NSArray *array = [str componentsSeparatedByString:@":"];
                
                double dv = [array[1] doubleValue];
                NSLog(@"array %@",array[1]);
                NSLog(@"array intvalue %ld",(long)[array[1] integerValue]);
                NSLog(@"array intvalue %d",[array[1] intValue]);
                NSLog(@"array intvalue %f",dv);
                
                [p_batterylevel setDoubleValue:dv];
                [p_batterlevel_txt setDoubleValue:dv];
                
                [p_log setStringValue: @"Battery level" ];
            }
            
            
            
            [self q_next];
            
            }
        }
}


@end
