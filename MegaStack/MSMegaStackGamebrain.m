//
//  MSMegaStackGamebrain.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSMegaStackGamebrain.h"

struct POINTER {
    NSInteger rowIndex;
    NSInteger columnIndex;
}pointer;

@interface MSMegaStackGamebrain () {
    BOOL gameIsOver;
    BOOL gameStarted;
    float updateInterval;
    NSInteger currentLevel;
    NSTimer *gameTimer;
}

@property (nonatomic, strong) MSMegaStackGameboard *gameboard;

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
    updateInterval = 0.1f;
    pointer.columnIndex = 0;
    pointer.rowIndex = 0;
    currentLevel = 0;
}

- (void)startGame
{
    if (gameStarted) return;
    gameStarted = YES;
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
    [self initSetup];
}

- (void)draw
{
    [self.gameboard drawBlockAtRow:pointer.rowIndex column:pointer.columnIndex withColor:[UIColor blueColor]];
}

- (void)update:(NSTimer *)timer
{
    if (gameIsOver) {
        [timer invalidate];
        [self resetGame];
        return;
    }
    
    [self draw];
    
    if (pointer.columnIndex == self.gameboard.numberOfColumns - 1) {
        pointer.columnIndex = 0;
        pointer.rowIndex++;
        if (pointer.rowIndex == self.gameboard.numberOfRows) gameIsOver = YES;
    }
    else {
        pointer.columnIndex++;
    }

}

-(void)handleUserAction
{
    if (!gameStarted) return;

    NSLog(@"user did tap on gameboard");
}

@end
