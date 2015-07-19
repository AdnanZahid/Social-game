//
//  SceneFactory.h
//  Social game
//
//  Created by Adnan Zahid on 7/10/15.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "SCNColor.h"

@interface SceneFactory : NSObject

- (SCNScene *)sceneWithTarget:(SCNView *)target;

@end