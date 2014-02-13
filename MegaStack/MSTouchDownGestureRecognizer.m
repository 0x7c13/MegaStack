//
//  MSTouchDownGestureRecognizer.m
//  MegaStack
//
//  Created by FlyinGeek on 2/13/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSTouchDownGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation MSTouchDownGestureRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateFailed;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateFailed;
}


@end