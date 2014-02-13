//
//  MSMegaStackGameboard.h
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GAME_BOARD_LINE_WIDTH 2.0

// minimum requirements of number of rows and columns
#define MIN_COLUMNS 5
#define MIN_ROWS 5

@interface MSMegaStackGameboard : UIView

@property (nonatomic, readonly) NSInteger numberOfRows;
@property (nonatomic, readonly) NSInteger numberOfColumns;

- (instancetype)initWithFrame:(CGRect)frame
                         rows:(NSInteger)numberOfRows
                      columns:(NSInteger)numberOfColumns
               gameboardColor:(UIColor *)color;


- (void)drawBlockUnitAtRow:(NSInteger)rowIndex
                column:(NSInteger)columnIndex
             withColor:(UIColor *)color;

- (void)removeBlockUnitAtRow:(NSInteger)rowIndex
                  column:(NSInteger)columnIndex;

- (BOOL)blockUnitExistsAtRow:(NSInteger)rowIndex
                           column:(NSInteger)columnIndex;

- (void)reset;

@end
