//
//  Player.h
//  Social game
//
//  Created by Adnan Zahid on 7/12/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "Constants.h"
#import "GeometryHelper.h"

@interface Player : NSObject

@property SCNNode *node;

- (id)initWithTarget:(SCNScene *)target characterID:(int)characterID Z:(int)Z angle:(int)angle;

- (void)createBullet;

@end