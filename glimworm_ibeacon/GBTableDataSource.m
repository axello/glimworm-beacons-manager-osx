//
//  GBTableDataSource.m
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Jonathan Carter. All rights reserved.
//

#import "GBTableDataSource.h"
#import "AccountModel.h"

@implementation GBTableDataSource
@synthesize itemArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemArray = [NSMutableArray array];
        self.accountBeacons = [NSMutableArray array];
        self.accountArray = [NSMutableArray array];
    }
    return self;
}


-(void)clearBeaconArray
{
    [self.itemArray removeAllObjects];
}

-(void) clearAccountArray
{
    [self.accountArray removeAllObjects];
}

-(void) clearAccountBeacons
{
    [self.accountBeacons removeAllObjects];
}

-(void) setupAccountArray
{
    AccountModel * ac1 = [[AccountModel alloc] init];
    ac1.name = @"default";
    ac1.type = @"cloud";
    ac1.url = @"";
    ac1.username = @"";
    ac1.password = @"";
    
    AccountModel * ac2 = [[AccountModel alloc] init];
    ac2.name = @"custom";
    ac2.type = @"cloud";
    ac2.url = @"";
    ac2.username = @"";
    ac2.password = @"";
    
    self.accountArray = [NSMutableArray arrayWithObjects:ac1,ac2,nil];
    

}
@end
