//
//  GameView.h
//  Social game
//
//  Created by Adnan Zahid on 7/10/15.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "SceneFactory.h"
#import "Constants.h"
#import "Player.h"
#import "GeometryHelper.h"
#import "HUD.h"

#if TARGET_OS_IPHONE
    #import "Social_game-Swift.h"
#else
    #import "Social_game_mac-Swift.h"
#endif

@interface GameView : SCNView <SCNPhysicsContactDelegate>

@end