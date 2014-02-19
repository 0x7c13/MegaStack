//
//  MSLevelManager.h
//  MegaStack
//
//  Created by FlyinGeek on 2/18/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MSGameModeCrazy = 0
}MSGameMode;

@interface MSLevelManager : NSObject

- (instancetype) init __attribute__((unavailable("init not available")));

- (instancetype)initWithGameMode:(MSGameMode)mode;

- (NSInteger)lengthOfBlockAtLevel:(NSInteger)level;
- (NSTimeInterval)timeIntervalAtLevel:(NSInteger)level;


@end
