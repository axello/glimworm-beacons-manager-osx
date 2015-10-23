//
//  GBBTManager.h
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Glimworm Beacons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import "GBTableDataSource.h"


@interface GBBTManager : NSObject <CBCentralManagerDelegate>


@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, weak) GBTableDataSource *dataSource;
@property (nonatomic, weak) NSTextField *statusbox;     // for logging only

- (instancetype)initWithDataSource:(GBTableDataSource *)ds;

-(void) startScanning;
-(void) stopScanning;

@end
