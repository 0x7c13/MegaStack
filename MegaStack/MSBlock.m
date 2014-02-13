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
}

@property (nonatomic, readwrite) NSInteger row;
@property (nonatomic, readwrite) NSInteger column;
@property (nonatomic, readwrite) NSInteger length;
@property (nonatomic, strong) MSMegaStackGameboard *gameboard;
@property (nonatomic, readwrite) BOOL isInActiveState;

@end

@implementation MSBlock

- (instancetype)initWithRow:(NSInteger)row
                     column:(NSInteger)column
                     length:(NSInteger)length
                  gameboard:(MSMegaStackGameboard *)gameboard
{
    if (row < 0 || row >= gameboard.numberOfRows|| column < 0 || column + length - 1 >= gameboard.numberOfColumns || length <= 0 ) {
        NSLog(@"Block cannot be created: invalid number of rows, columns or length");
        return nil;
    }
    
    if (self = [super init]) {
        _row = row;
        _column = column;
        _length = length;
        _gameboard = gameboard;
        _isInActiveState = YES;
        isMovingLeft = YES;
        
        for (int i = (int)self.column; i < (int)self.column + self.length; i++) {
            [self.gameboard drawBlockUnitAtRow:self.row column:i withColor:[UIColor blueColor]];
        }
    }
    return self;
}

- (void)update
{
    if (isMovingLeft) {
        if (self.column > 0) self.column--;
        else {
            isMovingLeft = !isMovingLeft;
        }
    } else {
        if (self.column + self.length < self.gameboard.numberOfColumns - 1) self.column++;
        else {
            isMovingLeft = !isMovingLeft;
        }
    }
}

- (void)draw
{
    if (isMovingLeft) {

        [self.gameboard removeBlockUnitAtRow:self.row column:self.column + self.length];
        [self.gameboard drawBlockUnitAtRow:self.row column:self.column withColor:[UIColor blueColor]];
        
    } else {
        
        [self.gameboard removeBlockUnitAtRow:self.row column:self.column];
        [self.gameboard drawBlockUnitAtRow:self.row column:self.column + self.length withColor:[UIColor blueColor]];
    }
}

- (void)stop
{
    self.isInActiveState = NO;
}

@end
