//
//  HUD.h
//  Iron cage
//
//  Created by Adnan Zahid on 6/26/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "HealthBar.h"
#import "Button.h"
#import "ControlDelegate.h"

@interface HUD : SKScene

@property id controlDelegate;

- (void)damage:(int)health;

- (void)spawn:(int)characterID position:(CGPoint)position isHero:(BOOL)isHero;

- (void)position:(int)characterID position:(CGPoint)position;

- (void)removeBlip:(int)characterID;

@end