//
//  MSMegaStackGamebrain.h
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMegaStackGameboard.h"
#import "MSBlock.h"
#import "MSLevelManager.h"
#import "MSTouchDownGestureRecognizer.h"
#import "MSGameScoreManager.h"

@protocol MSMegaStackGamebrainDelegate;

@interface MSMegaStackGamebrain : NSObject

@property (nonatomic, weak) id<MSMegaStackGamebrainDelegate> delegate;

- (instancetype) init __attribute__((unavailable("init not available")));

- (instancetype)initWithGameboard:(MSMegaStackGameboard *)gameboard
                         gameMode:(MSGameMode)mode;

- (void)startGame;
- (void)resetGame;

- (void)handleUserAction;

@end

@protocol MSMegaStackGamebrainDelegate <NSObject>

@optional
- (void)scoreDidUpdate:(NSInteger)score;

@end
