//
//  MSMegaStackGameboard.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSMegaStackGameboard.h"

@interface MSMegaStackGameboard()

@property (nonatomic) CGRect gameboardFrame;
@property (nonatomic) CGColorRef gameboardLineColor;
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSInteger numberOfColumns;

@end

@implementation MSMegaStackGameboard

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)numberOfRows columns:(NSInteger)numberOfColumns gameboardColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfRows = numberOfRows;
        _numberOfColumns = numberOfColumns;
        _gameboardLineColor = color.CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self initGameboard];
}

- (void)initGameboard
{
    // set actual frame
    self.gameboardFrame = CGRectMake(GAME_BOARD_LINE_WIDTH / 2.0, GAME_BOARD_LINE_WIDTH / 2.0, self.frame.size.width - GAME_BOARD_LINE_WIDTH, self.frame.size.height - GAME_BOARD_LINE_WIDTH);
    
    // draw columns
    for (int i = 0; i <= self.numberOfColumns; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.gameboardLineColor);
    
        CGContextSetLineWidth(context, GAME_BOARD_LINE_WIDTH);
        CGContextMoveToPoint(context, (self.gameboardFrame.size.width/(float)self.numberOfColumns) * i + GAME_BOARD_LINE_WIDTH / 2.0, 0.0);
        CGContextAddLineToPoint(context, (self.gameboardFrame.size.width/(float)self.numberOfColumns) * i + GAME_BOARD_LINE_WIDTH / 2.0, self.frame.size.height);
        CGContextStrokePath(context);
    }
    
    // draw rows
    for (int i = 0; i <= self.numberOfRows; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.gameboardLineColor);
        
        CGContextSetLineWidth(context, GAME_BOARD_LINE_WIDTH);
        CGContextMoveToPoint(context, 0.0, (self.gameboardFrame.size.height/(float)self.numberOfRows) * i + GAME_BOARD_LINE_WIDTH / 2.0);
        CGContextAddLineToPoint(context, self.gameboardFrame.size.height, (self.gameboardFrame.size.height/(float)self.numberOfRows) * i + GAME_BOARD_LINE_WIDTH / 2.0);
        CGContextStrokePath(context);
    }
    
    NSLog(@"Gameboard initialized!");
}


- (void)drawBlockAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex withColor:(UIColor*)color
{
    // check for bounds
    if (rowIndex >= self.numberOfRows || columnIndex >= self.numberOfColumns || rowIndex < 0 || columnIndex < 0) {
        NSLog(@"Cannot draw block at (%d, %d): row index or column index out of bounds", rowIndex, columnIndex);
        return;
    }
    
    // check for existence
    NSInteger tag = [NSString stringWithFormat:@"%d%d", rowIndex, columnIndex].integerValue;
    if([self viewWithTag:tag]) {
        NSLog(@"Cannot draw block at (%d, %d): block already exists", rowIndex, columnIndex);
        return;
    }
    
    UIView *newBlock = [[UIView alloc]initWithFrame:CGRectMake((self.gameboardFrame.size.width / self.numberOfColumns) * columnIndex + GAME_BOARD_LINE_WIDTH, (self.gameboardFrame.size.height / self.numberOfRows) * (self.numberOfRows - rowIndex - 1) + GAME_BOARD_LINE_WIDTH, self.gameboardFrame.size.width / self.numberOfColumns - GAME_BOARD_LINE_WIDTH, self.gameboardFrame.size.height / self.numberOfRows - GAME_BOARD_LINE_WIDTH)];
    newBlock.backgroundColor = color;
    newBlock.tag = tag;
    
    [self addSubview:newBlock];
}

- (void)removeBlockAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    NSInteger tag = [NSString stringWithFormat:@"%d%d", rowIndex, columnIndex].integerValue;
    UIView *targetBlock = [self viewWithTag:tag];
    if(targetBlock) {
        [targetBlock removeFromSuperview];
    } else {
        NSLog(@"Cannot remove block at (%d, %d): block doesn't exists", rowIndex, columnIndex);
    }
}

@end
