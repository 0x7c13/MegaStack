//
//  MSMegaStackGamebrain.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSMegaStackGamebrain.h"
#import "MSBlock.h"

struct POINTER {
    NSInteger rowIndex;
    NSInteger columnIndex;
}pointer;

@interface MSMegaStackGamebrain () {
    BOOL gameIsOver;
    BOOL gameStarted;
    BOOL userInteractionEnabled;
    BOOL levelUp;
    float updateInterval;
    NSInteger currentLevel;
    NSTimer *gameTimer;
}

@property (nonatomic, strong) MSMegaStackGameboard *gameboard;
@property (nonatomic, strong) NSMutableArray *blocks;

@end

@implementation MSMegaStackGamebrain

- (instancetype)initWithGameboard:(MSMegaStackGameboard *)gameboard
{
    if (self = [super init]) {
        _gameboard = gameboard;
        
        // Create and initialize a tap gesture
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleUserAction)];
        tapRecognizer.numberOfTapsRequired = 1;
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
    updateInterval = 0.2f;
    pointer.columnIndex = 0;
    pointer.rowIndex = 0;
    currentLevel = 0;
    _blocks = [[NSMutableArray alloc]init];
}

- (void)startGame
{
    if (gameStarted) return;

    NSInteger length = 2 * (((self.gameboard.numberOfRows - currentLevel)/(float)self.gameboard.numberOfRows) + 0.1) + 1;
    MSBlock *initBlock = [[MSBlock alloc]initWithRow:currentLevel++ column:self.gameboard.numberOfColumns/2 - length/2 + 1 length:length gameboard:self.gameboard];

    [self.blocks addObject:initBlock];
    
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
    [self.gameboard reset];
    [self.blocks removeAllObjects];
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
        [self.blocks addObject:[[MSBlock alloc]initWithRow:currentLevel++ column:self.gameboard.numberOfColumns/2 - length/2 + 1 length:length gameboard:self.gameboard]];
        userInteractionEnabled = YES;
        
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:timer.timeInterval * 0.9
                                                     target:self
                                                   selector:@selector(update:)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    
    for (MSBlock *block in self.blocks) {
        if ([block isInActiveState]) [block update];
    }
    
    for (MSBlock *block in self.blocks) {
        if ([block isInActiveState]) [block draw];
    }

}

-(void)handleUserAction
{
    if (!gameStarted || !userInteractionEnabled) return;
    
    for (MSBlock *block in self.blocks) {
        if ([block isInActiveState]) {
            [block stop];
            userInteractionEnabled = NO;
            levelUp = YES;
        }
    }
    
}

@end
