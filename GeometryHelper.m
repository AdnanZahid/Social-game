//
//  GeometryHelper.m
//  Social game
//
//  Created by Adnan Zahid on 7/15/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "GeometryHelper.h"

@implementation GeometryHelper

+ (SCNVector3)getDisplacement:(int)velocity node:(SCNNode *)node {
    
    CGFloat pitchRadian = node.eulerAngles.x;
    CGFloat yawRadian   = node.eulerAngles.y;
    
    CGFloat displacementX = -velocity * sin(yawRadian) * cos(pitchRadian);
    CGFloat displacementZ = -velocity * cos(yawRadian) * cos(pitchRadian);
    
    return SCNVector3Make(displacementX, 0, displacementZ);
}

@end