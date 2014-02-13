//
//  MSMegaStackGamebrain.h
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMegaStackGameboard.h"

#define INIT_BLOCK_LENGTH 3
#define INIT_MOVING_SPEED 0.2f

@interface MSMegaStackGamebrain : NSObject

- (instancetype)initWithGameboard:(MSMegaStackGameboard *)gameboard;

- (void)startGame;
- (void)resetGame;

- (void)handleUserAction;

@end
