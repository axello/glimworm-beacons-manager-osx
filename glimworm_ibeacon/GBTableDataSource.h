//
//  GBTableDataSource.h
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Jonathan Carter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDeviceModel.h"

@interface GBTableDataSource : NSObject

@property  (nonatomic, strong) IBOutlet NSMutableArray *itemArray;
@property  (nonatomic, strong) IBOutlet NSMutableArray *accountBeacons;
@property  (nonatomic, strong) IBOutlet NSMutableArray *accountArray;

-(void)clearBeaconArray;
-(void) clearAccountArray;
-(void) clearAccountBeacons;

-(void) setupAccountArray;

- (BTDeviceModel *) findItemInAccountBeaconArray:(NSString *)beaconId;
- (void) findItemInAccountArray:(BTDeviceModel *)beacon;

@end
