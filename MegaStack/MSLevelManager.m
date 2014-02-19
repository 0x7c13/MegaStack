//
//  MSLevelManager.m
//  MegaStack
//
//  Created by FlyinGeek on 2/18/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSLevelManager.h"

#define kCrazyModeInitLengthOfBlock 5
#define kCrazyModeInitMovingSpeed 0.2f
#define kCrazyModeMaxMovingSpeed 0.035f
#define kDebugModeOn 0

const int numberOfStates = 4;
const int stateTransactionLevels[] = {10 ,20 ,30, 40};
const float blockMovingSpeeds[] = {0.17, 0.14, 0.11, 0.08};
const float powerNumbers[] = {0.82, 0.84, 0.86, 0.89};

@interface MSLevelManager () {
    MSGameMode gameMode;
}

@end

@implementation MSLevelManager

- (instancetype)initWithGameMode:(MSGameMode)mode
{
    if (self = [super init]) {
        switch (mode) {
            case MSGameModeCrazy:
                {
                    gameMode = MSGameModeCrazy;
                } break;
                
            default:
            break;
        }
    }
    return self;
}

- (NSInteger)lengthOfBlockAtLevel:(NSInteger)level
{
    for (int i = numberOfStates - 1; i >= 0 ; i--) {
        if (level > stateTransactionLevels[i]) {
            return kCrazyModeInitLengthOfBlock - (i + 1);
        }
    }
    return kCrazyModeInitLengthOfBlock;
}

-(NSTimeInterval)timeIntervalAtLevel:(NSInteger)level
{
    NSTimeInterval interval;
    for (int i = numberOfStates - 1; i >= 0 ; i--) {
        if (level > stateTransactionLevels[i]) {
            
            interval = blockMovingSpeeds[i] * pow(powerNumbers[i], (double)(level - (stateTransactionLevels[i])));
#if kDebugModeOn
            NSLog(@"%lf", interval);
#endif
            return interval > kCrazyModeMaxMovingSpeed ? interval: kCrazyModeMaxMovingSpeed ;
        }
    }
    interval =  kCrazyModeInitMovingSpeed * pow(0.8, (double)(level));
#if kDebugModeOn
    NSLog(@"%lf", interval);
#endif
    return interval > kCrazyModeMaxMovingSpeed ? interval: kCrazyModeMaxMovingSpeed;
}

@end
