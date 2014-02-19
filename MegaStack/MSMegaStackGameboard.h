//
//  MSMegaStackGameboard.h
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGameboardLineWidth 2.0
/* minimum requirements of number of rows and columns */
#define kMinimunNumberOfColumns 5
#define kMinimunNumberOfRows 5

@interface MSMegaStackGameboard : UIView

@property (nonatomic, readonly) NSInteger numberOfRows;
@property (nonatomic, readonly) NSInteger numberOfColumns;

- (instancetype) init __attribute__((unavailable("init not available")));
- (instancetype)initWithFrame:(CGRect)frame
                         rows:(NSInteger)numberOfRows
                      columns:(NSInteger)numberOfColumns
               gameboardColor:(UIColor *)color;


- (void)updateByVerticalOffset:(NSInteger)offset;

- (void)drawBlockUnitAtRow:(NSInteger)rowIndex
                column:(NSInteger)columnIndex
             withColor:(UIColor *)color;

- (void)removeBlockUnitAtRow:(NSInteger)rowIndex
                  column:(NSInteger)columnIndex;

- (BOOL)blockUnitExistsAtRow:(NSInteger)rowIndex
                           column:(NSInteger)columnIndex;

- (void)reset;

@end
