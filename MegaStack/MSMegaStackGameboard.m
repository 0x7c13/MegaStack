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
@property (nonatomic, readwrite) NSInteger numberOfRows;
@property (nonatomic, readwrite) NSInteger numberOfColumns;
@property (nonatomic, strong) NSMutableArray *display;

@end

@implementation MSMegaStackGameboard

- (instancetype)initWithFrame:(CGRect)frame rows:(NSInteger)numberOfRows columns:(NSInteger)numberOfColumns gameboardColor:(UIColor *)color
{
    if (numberOfRows < kMinimunNumberOfRows || numberOfColumns < kMinimunNumberOfColumns) {
        NSLog(@"Number of rows and columns should greater or equal than minimun requirements");
        return nil;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _numberOfRows = numberOfRows;
        _numberOfColumns = numberOfColumns;
        _gameboardLineColor = color.CGColor;
        _display = [[NSMutableArray alloc] init];
        
        // set actual frame
        _gameboardFrame = CGRectMake(kGameboardLineWidth / 2.0, kGameboardLineWidth / 2.0, frame.size.width - kGameboardLineWidth, frame.size.height - kGameboardLineWidth);
        
        // init display
        for (int rowIndex = 0; rowIndex < numberOfRows; rowIndex++) {
            NSMutableArray *columns = [[NSMutableArray alloc]init];
            for (int columnIndex = 0; columnIndex < numberOfColumns; columnIndex++) {
                UIView *blockUnit = [[UIView alloc]initWithFrame:CGRectMake((self.gameboardFrame.size.width / self.numberOfColumns) * columnIndex + kGameboardLineWidth, (self.gameboardFrame.size.height / self.numberOfRows) * (self.numberOfRows - rowIndex - 1) + kGameboardLineWidth, self.gameboardFrame.size.width / self.numberOfColumns - kGameboardLineWidth, self.gameboardFrame.size.height / self.numberOfRows - kGameboardLineWidth)];
                blockUnit.backgroundColor = [UIColor clearColor];
                [self addSubview:blockUnit];
                [columns addObject:blockUnit];
            }
            [self.display addObject:columns];
        }
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
    // draw columns
    for (int i = 0; i <= self.numberOfColumns; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.gameboardLineColor);
    
        CGContextSetLineWidth(context, kGameboardLineWidth);
        CGContextMoveToPoint(context, (self.gameboardFrame.size.width/(float)self.numberOfColumns) * i + kGameboardLineWidth / 2.0, 0.0);
        CGContextAddLineToPoint(context, (self.gameboardFrame.size.width/(float)self.numberOfColumns) * i + kGameboardLineWidth / 2.0, self.gameboardFrame.size.height);
        CGContextStrokePath(context);
    }
    
    // draw rows
    for (int i = 0; i <= self.numberOfRows; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.gameboardLineColor);
        
        CGContextSetLineWidth(context, kGameboardLineWidth);
        CGContextMoveToPoint(context, 0.0, (self.gameboardFrame.size.height/(float)self.numberOfRows) * i + kGameboardLineWidth / 2.0);
        CGContextAddLineToPoint(context, self.gameboardFrame.size.width + kGameboardLineWidth, (self.gameboardFrame.size.height/(float)self.numberOfRows) * i + kGameboardLineWidth / 2.0);
        CGContextStrokePath(context);
    }
    
    NSLog(@"Gameboard initialized!");
}


- (void)drawBlockUnitAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex withColor:(UIColor*)color
{
    // check for bounds
    if (rowIndex >= self.numberOfRows || columnIndex >= self.numberOfColumns || rowIndex < 0 || columnIndex < 0) {
        NSLog(@"Cannot draw block at (%d, %d): row index or column index out of bounds", (int)rowIndex, (int)columnIndex);
        return;
    }
    
    // check for existence
    if([self blockUnitExistsAtRow:rowIndex column:columnIndex]) {
        NSLog(@"Cannot draw block at (%d, %d): block already exists", (int)rowIndex, (int)columnIndex);
        return;
    }
    
    ((UIView *)self.display[rowIndex][columnIndex]).backgroundColor = color;
}

- (void)removeBlockUnitAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    // check for bounds
    if (rowIndex >= self.numberOfRows || columnIndex >= self.numberOfColumns || rowIndex < 0 || columnIndex < 0) {
        NSLog(@"Cannot remove block at (%d, %d): row index or column index out of bounds", (int)rowIndex, (int)columnIndex);
        return;
    }
    
    // check for existence
    if(![self blockUnitExistsAtRow:rowIndex column:columnIndex]) {
        NSLog(@"Cannot remove block at (%d, %d): block doesn't exists", (int)rowIndex, (int)columnIndex);
        return;
    }
    
    ((UIView *)self.display[rowIndex][columnIndex]).backgroundColor = [UIColor clearColor];
}

- (void)updateByVerticalOffset:(NSInteger)offset
{
    if (offset == 0) return;

    if (offset > 0) {
        for (NSInteger rowIndex = self.numberOfRows - 1; rowIndex >= self.numberOfRows - offset; rowIndex--) {
            for (NSInteger columnIndex = 0; columnIndex < self.numberOfColumns; columnIndex++) {
                if ([self blockUnitExistsAtRow:rowIndex column:columnIndex]) {
                    [self removeBlockUnitAtRow:rowIndex column:columnIndex];
                }
            }
        }
        for (NSInteger rowIndex = self.numberOfRows - offset - 1; rowIndex >= 0; rowIndex--) {
            for (NSInteger columnIndex = 0; columnIndex < self.numberOfColumns; columnIndex++) {
                if ([self blockUnitExistsAtRow:rowIndex column:columnIndex]) {
                    UIColor *blockColor = ((UIView *)self.display[rowIndex][columnIndex]).backgroundColor;
                    [self removeBlockUnitAtRow:rowIndex column:columnIndex];
                    if (![self blockUnitExistsAtRow:rowIndex + offset column:columnIndex]) {
                        [self drawBlockUnitAtRow:rowIndex + offset column:columnIndex withColor:blockColor];
                    }
                }
            }
        }
    } else {
        for (NSInteger rowIndex = 0; rowIndex < offset; rowIndex++) {
            for (NSInteger columnIndex = 0; columnIndex < self.numberOfColumns; columnIndex++) {
                if ([self blockUnitExistsAtRow:rowIndex column:columnIndex]) {
                    [self removeBlockUnitAtRow:rowIndex column:columnIndex];
                }
            }
        }
        for (NSInteger rowIndex = -offset; rowIndex < self.numberOfRows; rowIndex++) {
            for (NSInteger columnIndex = 0; columnIndex < self.numberOfColumns; columnIndex++) {
                if ([self blockUnitExistsAtRow:rowIndex column:columnIndex]) {
                    UIColor *blockColor = ((UIView *)self.display[rowIndex][columnIndex]).backgroundColor;
                    [self removeBlockUnitAtRow:rowIndex column:columnIndex];
                    if (![self blockUnitExistsAtRow:rowIndex + offset column:columnIndex]) {
                        [self drawBlockUnitAtRow:rowIndex + offset column:columnIndex withColor:blockColor];
                    }
                }
            }
        }
    }
}

- (BOOL)blockUnitExistsAtRow:(NSInteger)rowIndex
                      column:(NSInteger)columnIndex
{
    // check for bounds
    if (rowIndex >= self.numberOfRows || columnIndex >= self.numberOfColumns || rowIndex < 0 || columnIndex < 0) {
        NSLog(@"Blockunit doesn't exist at (%d, %d): row index or column index out of bounds", (int)rowIndex, (int)columnIndex);
        return NO;
    }
    
    return !(((UIView *)self.display[rowIndex][columnIndex]).backgroundColor == [UIColor clearColor]);
}

- (void)reset
{
    for (int rowIndex = 0; rowIndex < self.numberOfRows; rowIndex++)
        for (int columnIndex = 0; columnIndex < self.numberOfColumns; columnIndex++) {
            ((UIView *)self.display[rowIndex][columnIndex]).backgroundColor = [UIColor clearColor];
        }
}

@end
