//
//  GBTableDataSource.m
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Jonathan Carter. All rights reserved.
//

#import "GBTableDataSource.h"

@implementation GBTableDataSource
@synthesize itemArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemArray = [NSMutableArray array];
        self.accountBeacons = [NSMutableArray array];
    }
    return self;
}


-(void)clearBeaconArray
{
    [self.itemArray removeAllObjects];
}

@end
