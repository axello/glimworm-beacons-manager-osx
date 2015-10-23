//
//  GBTableDataSource.h
//  glimworm_ibeacon
//
//  Created by Axel Roest on 23/10/15.
//  Copyright © 2015 Jonathan Carter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBTableDataSource : NSObject

@property  (nonatomic, strong) IBOutlet NSMutableArray *itemArray;
@property  (nonatomic, strong) IBOutlet NSMutableArray *accountBeacons;

-(void)clearBeaconArray;

@end
