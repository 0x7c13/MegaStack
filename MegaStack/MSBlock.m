//
//  MSBlock.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSBlock.h"

@interface MSBlock () {
    BOOL isMovingLeft;
    BOOL isInFallingState;
}

@property (nonatomic, readwrite) NSInteger row;
@property (nonatomic, readwrite) NSInteger column;
@property (nonatomic, readwrite) NSInteger length;
@property (nonatomic, readwrite) UIColor *color;
@property (nonatomic, readwrite) BOOL isInActiveState;
@property (nonatomic, readwrite) BOOL isDead;
@property (nonatomic, strong) NSMutableArray *isMoveable;

@property (nonatomic, strong) MSMegaStackGameboard *gameboard;

@end

@implementation MSBlock

- (instancetype)initWithRow:(NSInteger)row
                     column:(NSInteger)column
                     length:(NSInteger)length
                      color:(UIColor *)color
                  gameboard:(MSMegaStackGameboard *)gameboard

{
    if (row < 0 || row >= gameboard.numberOfRows|| column < 0 ||
        column + length - 1 >= gameboard.numberOfColumns ||
        length <= 0 ) {
        
        NSLog(@"Block cannot be created: invalid index of rows, columns or length");
        return nil;
    }
    
    if (self = [super init]) {
        _row = row;
        _column = column;
        _length = length;
        _color = color;
        _gameboard = gameboard;
        _isInActiveState = YES;
        _isDead = NO;
        isMovingLeft = YES;
        isInFallingState = NO;
        
        _isMoveable = [[NSMutableArray alloc]init];

        for (int i = (int)self.column; i < (int)self.column + self.length; i++) {
            [self.gameboard drawBlockUnitAtRow:self.row column:i withColor:[UIColor blueColor]];
            [self.isMoveable addObject:@1];
        }
    }
    return self;
}

- (void)update
{
    if (self.column == 0) isMovingLeft = NO;
    if (self.column + self.length == self.gameboard.numberOfColumns) isMovingLeft = YES;
    
    if (isMovingLeft) {
        self.column --;
    } else {
        self.column ++;
    }
}

- (void)draw
{
    if (isMovingLeft) {

        [self.gameboard removeBlockUnitAtRow:self.row column:self.column + self.length];
        [self.gameboard drawBlockUnitAtRow:self.row column:self.column withColor:self.color];
        
    } else {
        
        [self.gameboard removeBlockUnitAtRow:self.row column:self.column - 1];
        [self.gameboard drawBlockUnitAtRow:self.row column:self.column + self.length - 1 withColor:self.color];
    }
}

- (BOOL)setToFallingState
{
    self.isInActiveState = NO;
    isInFallingState = YES;
    
    if (self.row == 0) return YES;
        
    int movableCounter = 0;
    
    for (int i = 0; i < self.length; i++)
    {
        if ([self.gameboard blockUnitExistsAtRow:self.row - 1 column:self.column + i]) {
            self.isMoveable[i] = @0;
            movableCounter ++;
        }
    }
    return movableCounter > 0;
}

- (void)fall
{
    if (!isInFallingState) return;
    
    if (self.row > 0) {
        self.row--;
        for (int i = 0; i < self.length; i++)
        {
            if (self.isMoveable[i]) {
                if ([self.gameboard blockUnitExistsAtRow:self.row column:self.column + i]) {
                    self.isMoveable[i] = @0;
                } else {
                    [self.gameboard removeBlockUnitAtRow:self.row + 1 column:self.column + i];
                    [self.gameboard drawBlockUnitAtRow:self.row column:self.column + i withColor:self.color];
                }
            }
        }
    } else {
        self.isDead = YES;
    }
    
}

@end
