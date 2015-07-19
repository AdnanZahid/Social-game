//
//  SceneFactory.m
//  Social game
//
//  Created by Adnan Zahid on 7/10/15.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "SceneFactory.h"

@implementation SceneFactory

- (SCNScene *)sceneWithTarget:(SCNView *)target {
    
    SCNScene *scene = [SCNScene scene];
    
    target.scene = scene;
//    target.allowsCameraControl = YES;
//    target.showsStatistics = YES;
    target.backgroundColor = [SCNColor blackColor];
    
    target.scene.physicsWorld.gravity = SCNVector3Zero;
    
    return scene;
}

@end