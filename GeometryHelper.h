//
//  GeometryHelper.h
//  Social game
//
//  Created by Adnan Zahid on 7/15/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface GeometryHelper : NSObject

+ (SCNVector3)getDisplacement:(int)velocity node:(SCNNode *)node;

@end