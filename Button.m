//
//  Button.m
//  Iron cage
//
//  Created by Adnan Zahid on 6/27/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "Button.h"

@implementation Button

- (id)initWithName:(NSString *)buttonName offset:(int)offset X:(CGFloat)X Y:(CGFloat)Y {
    
    return [self initWithName:buttonName offset:offset X:X Y:Y scale:1];
}

- (id)initWithName:(NSString *)buttonName offset:(int)offset X:(CGFloat)X Y:(CGFloat)Y scale:(float)scale {
    
    if (self = [super init]) {
        
        _button = [[SKButton alloc] initWithImageNamedNormal:@"buttonDefault" selected:@"buttonPressed"];
        
        _button.alpha = 0.5f;
        
//        _button.xScale = scale;
//        _button.yScale = scale;
        
        _button.position = CGPointMake(offset * _button.size.width/2 + X, Y + _button.size.height/2);
//        _button.title.text = buttonName;
//        _button.title.fontSize = 30;

        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", buttonName, @"Action"]);
        
        [_button setTouchUpInsideTarget:self action:selector];
    }
    
    return self;
}

@end