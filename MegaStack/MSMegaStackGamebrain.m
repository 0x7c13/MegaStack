//
//  MSMegaStackGamebrain.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSMegaStackGamebrain.h"
#import "MSTouchDownGestureRecognizer.h"

#define kDebugModeOn 0
#define kAnimationTimeInterval 0.15f

@interface MSMegaStackGamebrain () {
    
    BOOL gameIsOver;
    BOOL gameStarted;
    BOOL userInteractionEnabled;
    BOOL levelUp;
    NSInteger score;
    NSInteger currentLevel;
    NSTimer *gameTimer;
    NSTimer *animationTimer;
}

@property (nonatomic, strong) MSMegaStackGameboard *gameboard;
@property (nonatomic, strong) MSBlock *activeBlock;
@property (nonatomic, strong) MSLevelManager *levelManager;

@end

@implementation MSMegaStackGamebrain

- (instancetype)initWithGameboard:(MSMegaStackGameboard *)gameboard
                         gameMode:(MSGameMode)mode
{
    if (self = [super init]) {
        _gameboard = gameboard;
        _levelManager = [[MSLevelManager alloc] initWithGameMode:mode];
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
    currentLevel = 0;
    score = 0;
    _activeBlock = nil;
}

- (void)startGame
{
    if (gameStarted) return;

    if ([self.delegate respondsToSelector:@selector(scoreDidUpdate:)]) {
        [self.delegate scoreDidUpdate:0];
    }
    
    NSInteger length = [self.levelManager lengthOfBlockAtLevel:currentLevel];
    self.activeBlock = [[MSBlock alloc]initWithRow:currentLevel column:0 length:length color:[UIColor blueColor] gameboard:self.gameboard];

    
    gameStarted = YES;
    userInteractionEnabled = YES;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:[self.levelManager timeIntervalAtLevel:currentLevel]
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
        
        score += [MSGameScoreManager scoreWithExistingRounds:self.activeBlock.existingRounds fallingPoints:self.activeBlock.fallingPoint];
        if ([self.delegate respondsToSelector:@selector(scoreDidUpdate:)]) {
            [self.delegate scoreDidUpdate:score];
        }

        currentLevel++;
        
        NSInteger rowIndex = currentLevel;

        if (currentLevel > (int)(2/3.0 * self.gameboard.numberOfRows)) {
            [self.gameboard updateByVerticalOffset:-1];
            rowIndex = (int)(2/3.0 * self.gameboard.numberOfRows);
        }
        
        self.activeBlock = [[MSBlock alloc]initWithRow:rowIndex column:(currentLevel % 2 == 0)? 0: self.gameboard.numberOfColumns - [self.levelManager lengthOfBlockAtLevel:currentLevel] length:[self.levelManager lengthOfBlockAtLevel:currentLevel] color:[UIColor blueColor] gameboard:self.gameboard];
        
        userInteractionEnabled = YES;
        
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:[self.levelManager timeIntervalAtLevel:currentLevel]
                                                     target:self
                                                   selector:@selector(update:)
                                                   userInfo:nil
                                                    repeats:YES];
    } else {
        if (self.activeBlock.isInActiveState) {
            [self.activeBlock update];
            [self.activeBlock draw];
        }
    }
#if kDebugModeOn
    NSLog(@"Updated");
#endif
}

- (void)animation:(NSTimer *)timer
{
    if (self.activeBlock.isDead) {
        [timer invalidate];
        levelUp = YES;
    } else {
        [self.activeBlock fall];
    }
#if kDebugModeOn
    NSLog(@"Animated");
#endif
}

-(void)handleUserAction
{
    if (!gameStarted || !userInteractionEnabled) return;
    
    if (self.activeBlock.isInActiveState) {
        
        if ([self.activeBlock setToFallingState]) {
            
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:kAnimationTimeInterval
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
