//
//  MSMegaStackGameboard.h
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GAME_BOARD_LINE_WIDTH 2.0

@interface MSMegaStackGameboard : UIView

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)numberOfRows columns:(NSInteger)numberOfColumns gameboardColor:(UIColor *)color;

- (void)drawBlockAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex withColor:(UIColor *)color;
- (void)removeBlockAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;

@end
