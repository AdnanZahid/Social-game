//
//  HealthBar.h
//  Iron cage
//
//  Created by Adnan Zahid on 6/26/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HealthBar : SKCropNode

@property SKSpriteNode *sprite;

- (void) setProgress:(CGFloat) progress;

@end