//
//  HealthBar.m
//  Iron cage
//
//  Created by Adnan Zahid on 6/26/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "HealthBar.h"

@implementation HealthBar

- (id)init {
    if (self = [super init]) {
        
        _sprite = [SKSpriteNode spriteNodeWithImageNamed:@"healthBar"];
        
        self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:_sprite.size];
        
        [self addChild:_sprite];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    self.maskNode.xScale = progress/100;
}

@end