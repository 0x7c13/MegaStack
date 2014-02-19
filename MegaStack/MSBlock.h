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
@property (nonatomic, readonly) NSInteger existingRounds;
@property (nonatomic, readonly) NSInteger fallingPoint;
@property (nonatomic, readonly) UIColor *color;

@property (nonatomic, readonly) BOOL isInActiveState;
@property (nonatomic, readonly) BOOL isDead;

- (instancetype)initWithRow:(NSInteger)row
                     column:(NSInteger)column
                     length:(NSInteger)length
                      color:(UIColor *)color
                  gameboard:(MSMegaStackGameboard *)gameboard;

- (BOOL)setToFallingState;
- (void)update;
- (void)draw;
- (void)fall;


@end
