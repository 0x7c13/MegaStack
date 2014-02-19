//
//  MSGameScoreManager.m
//  MegaStack
//
//  Created by FlyinGeek on 2/18/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSGameScoreManager.h"

@implementation MSGameScoreManager

+ (NSInteger)scoreWithExistingRounds:(NSInteger)rounds
                       fallingPoints:(NSInteger)points
{
    NSInteger reactionPoints;
    if (rounds <= 2) {
        
        reactionPoints = 8;
    } else if (rounds <= 5) {
        
        reactionPoints = 5;
    } else if (rounds <= 10) {
        
        reactionPoints = 4;
    } else {
        
        reactionPoints = 3;
    }
    return reactionPoints +points;
}

@end
