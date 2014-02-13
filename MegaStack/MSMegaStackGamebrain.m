//
//  MSMegaStackGamebrain.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSMegaStackGamebrain.h"
#import "MSBlock.h"
#import "MSTouchDownGestureRecognizer.h"

@interface MSMegaStackGamebrain () {
    
    BOOL gameIsOver;
    BOOL gameStarted;
    BOOL userInteractionEnabled;
    BOOL levelUp;
    float updateInterval;
    NSInteger currentLevel;
    NSTimer *gameTimer;
    NSTimer *animationTimer;
}

@property (nonatomic, strong) MSMegaStackGameboard *gameboard;
@property (nonatomic, strong) MSBlock *targetBlock;

@end

@implementation MSMegaStackGamebrain

- (instancetype)initWithGameboard:(MSMegaStackGameboard *)gameboard
{
    if (self = [super init]) {
        _gameboard = gameboard;
        
        // Create and initialize a tap gesture
        MSTouchDownGestureRecognizer *tapRecognizer = [[MSTouchDownGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleUserAction)];
        [self.gameboard addGestureRecognizer:tapRecognizer];
        
        [self initSetup];
    }
    return self;
}

- (void)initSetup
{
    gameIsOver = NO;
    gameStarted = NO;
    userInteractionEnabled = NO;
    levelUp = NO;
    updateInterval = INIT_MOVING_SPEED;
    currentLevel = 0;
    _targetBlock = nil;
}

- (void)startGame
{
    if (gameStarted) return;

    NSInteger length = 2 * (((self.gameboard.numberOfRows - currentLevel)/(float)self.gameboard.numberOfRows) + 0.1) + 1;
    self.targetBlock = [[MSBlock alloc]initWithRow:currentLevel++ column:self.gameboard.numberOfColumns/2 - length/2 + 1 length:length color:[UIColor blueColor] gameboard:self.gameboard];

    
    gameStarted = YES;
    userInteractionEnabled = YES;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval
                                     target:self
                                   selector:@selector(update:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)resetGame
{
    [gameTimer invalidate];
    [animationTimer invalidate];
    [self.gameboard reset];
    [self initSetup];
}



- (void)update:(NSTimer *)timer
{
    if (gameIsOver) {
        [timer invalidate];
        [self resetGame];
        return;
    }
    
    if (levelUp) {
        [timer invalidate];
        levelUp = NO;
        
        if (currentLevel == self.gameboard.numberOfRows) {
            [self resetGame];
            return;
        }
        
        NSInteger length = 2 * (((self.gameboard.numberOfRows - currentLevel)/(float)self.gameboard.numberOfRows) + 0.1) + 1;
        self.targetBlock = [[MSBlock alloc]initWithRow:currentLevel++ column:self.gameboard.numberOfColumns/2 - length/2 + 1 length:length color:[UIColor blueColor] gameboard:self.gameboard];
        
        userInteractionEnabled = YES;
        
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:timer.timeInterval * 0.9
                                                     target:self
                                                   selector:@selector(update:)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    
    if (self.targetBlock.isInActiveState) {
        [self.targetBlock update];
        [self.targetBlock draw];
    }

}

- (void)animation:(NSTimer *)timer
{
    if (self.targetBlock.isDead) {
        [timer invalidate];
        levelUp = YES;
    } else {
        [self.targetBlock fall];
    }
}

-(void)handleUserAction
{
    if (!gameStarted || !userInteractionEnabled) return;
    
    if (self.targetBlock.isInActiveState) {
        
        if ([self.targetBlock setToFallingState]) {
            
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval
                                                              target:self
                                                            selector:@selector(animation:)
                                                            userInfo:nil
                                                             repeats:YES];
        }
        else {
            gameIsOver = YES;
        }
        userInteractionEnabled = NO;
    }

}

@end
