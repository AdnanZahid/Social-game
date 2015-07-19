//
//  HUD.m
//  Iron cage
//
//  Created by Adnan Zahid on 6/26/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "HUD.h"

@implementation HUD {

    CGFloat width;
    CGFloat height;
    
    HealthBar *healthBar;
    
    SKSpriteNode *radar;
    
    NSMutableArray *gameCharacters;
}

-(void)didMoveToView:(SKView *)view {
    
    gameCharacters = [NSMutableArray array];
    
    width = CGRectGetMaxX(self.frame);
    height = CGRectGetMaxY(self.frame);
    
#if TARGET_OS_IPHONE
    [self addChild:[[[Button alloc] initWithName:@"Up" offset:0 X:width/2.8f Y:height/4] button]];
    [self addChild:[[[Button alloc] initWithName:@"Down" offset:0 X:width/2.8f Y:height/16] button]];
    [self addChild:[[[Button alloc] initWithName:@"Left" offset:-2 X:width/2.8f Y:height/16] button]];
    [self addChild:[[[Button alloc] initWithName:@"Right" offset:2 X:width/2.8f Y:height/16] button]];
    [self addChild:[[[Button alloc] initWithName:@"Fire" offset:-1 X:width Y:height/16] button]];
#endif
    
    [self addHealthBar];
    
    [self addRadar];
}

- (void)UpAction {
    
    [_controlDelegate UpAction];
}

- (void)DownAction {
    
    [_controlDelegate DownAction];
}

- (void)LeftAction {
    
    [_controlDelegate LeftAction];
}

- (void)RightAction {
    
    [_controlDelegate RightAction];
}

- (void)FireAction {
    
    [_controlDelegate FireAction];
}

- (void)damage:(int)health {
        
    [healthBar setProgress:health];
}

- (void)spawn:(int)characterID position:(CGPoint)position isHero:(BOOL)isHero {
    
    SKShapeNode *player = [SKShapeNode shapeNodeWithCircleOfRadius:10];
    
    if (isHero) {
        
        player.fillColor = [SKColor whiteColor];
        for (int i = 0; i < characterID; i ++) {
            
            [gameCharacters insertObject:[NSNull null] atIndex:i];
        }
        
        [gameCharacters insertObject:player atIndex:characterID];
    }
    else {
        
        player.fillColor = [SKColor redColor];
        if ([gameCharacters count] <= characterID) {
            
            [gameCharacters insertObject:player atIndex:characterID];
        }
        else {
            [gameCharacters replaceObjectAtIndex:characterID withObject:player];
        }
    }
    
    player.position = position;
    [radar addChild:player];
}

- (void)position:(int)characterID position:(CGPoint)position {
    
    SKShapeNode *characterToMove = (SKShapeNode *)[gameCharacters objectAtIndex:characterID];
    
    characterToMove.position = position;
}

- (void)removeBlip:(int)characterID {
    
    SKShapeNode *characterToMove = (SKShapeNode *)[gameCharacters objectAtIndex:characterID];
    
    [characterToMove removeFromParent];
}

- (void)addHealthBar {
    
    healthBar = [[HealthBar alloc] init];
    
    [healthBar setProgress:100];
    
    SKSpriteNode *healthBarFrame = [SKSpriteNode spriteNodeWithImageNamed:@"healthBarFrame"];
    healthBarFrame.position = CGPointMake(width - healthBarFrame.size.width * 0.6f, height - healthBarFrame.size.height * 0.9f);
    
    healthBar.position = CGPointMake(width - healthBarFrame.size.width * 0.6f, height - healthBarFrame.size.height * 0.9f);
        
    [self addChild:healthBarFrame];
    [self addChild:healthBar];
}

- (void)addRadar {
    
    radar = [SKSpriteNode spriteNodeWithImageNamed:@"radar"];
    
    radar.alpha = 0.5f;
    
    radar.position = CGPointMake(radar.size.width/2, height - radar.size.height/2);
    
    [self addChild:radar];
}

@end