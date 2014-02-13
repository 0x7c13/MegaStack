//
//  MSBlock.h
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMegaStackGameboard.h"

@interface MSBlock : NSObject

@property (nonatomic, readonly) NSInteger row;
@property (nonatomic, readonly) NSInteger column;
@property (nonatomic, readonly) NSInteger length;

@property (nonatomic, readonly) BOOL isInActiveState;

- (instancetype)initWithRow:(NSInteger)row
                     column:(NSInteger)column
                     length:(NSInteger)length
                  gameboard:(MSMegaStackGameboard *)gameboard;

- (void)update;
- (void)draw;
- (void)stop;


@end
