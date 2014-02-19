//
//  MSGameScoreManager.h
//  MegaStack
//
//  Created by FlyinGeek on 2/18/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGameScoreManager : NSObject

+ (NSInteger)scoreWithExistingRounds:(NSInteger)rounds
                       fallingPoints:(NSInteger)points;

@end
