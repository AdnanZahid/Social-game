//
//  Player.m
//  Social game
//
//  Created by Adnan Zahid on 7/12/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithTarget:(SCNScene *)target characterID:(int)characterID Z:(int)Z angle:(int)angle {
    
    if (self = [super init]) {
    
        NSArray *characterPaths = @[@"art.scnassets/Tank1/Tank1.dae", @"art.scnassets/Tank2/Tank2.dae", @"art.scnassets/Tank3/Tank3.dae"];
        NSString *name = characterPaths[characterID % 3];
        
        SCNScene *character = [SCNScene sceneNamed:name];
        
        _node = character.rootNode;
        
        _node.position = SCNVector3Make(0, 0, Z);
        _node.eulerAngles = SCNVector3Make(0, angle * M_PI, 0);
        
        SCNBox *playerGeometry = [SCNBox boxWithWidth:600 height:600 length:600 chamferRadius:100];
        _node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:[SCNPhysicsShape shapeWithGeometry:playerGeometry options:nil]];
        
        _node.physicsBody.categoryBitMask = PLAYERCATEGORY;
        _node.physicsBody.collisionBitMask = BULLETCATEGORY;
        
        _node.physicsBody.mass = 0;
        
        [target.rootNode addChildNode:_node];
    }
    
    return self;
}

- (void)createBullet {
    
    CGFloat bulletRadius = 10;
    int bulletImpulse = 10000;
    
    SCNNode *bulletNode = [SCNNode node];
    SCNSphere *bulletGeometry = [SCNSphere sphereWithRadius:bulletRadius];
    bulletNode.opacity = 0;
    bulletNode.geometry = bulletGeometry;
    bulletNode.physicsBody = [SCNPhysicsBody dynamicBody];
    bulletNode.physicsBody.velocityFactor = SCNVector3Make(1, 0.5, 1);
    
    bulletNode.physicsBody.categoryBitMask = BULLETCATEGORY;
    
    bulletNode.position = _node.position;
    
    bulletNode.position = SCNVector3Make(bulletNode.position.x, bulletNode.position.y + 150, bulletNode.position.z);
    
    [_node.parentNode addChildNode:bulletNode];
    
    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:@"art.scnassets"];
    particleSystem.particleSize = 100;
    [bulletNode addParticleSystem:particleSystem];
    
    SCNVector3 displacement = [GeometryHelper getDisplacement:bulletImpulse node:_node];
    
    bulletNode.physicsBody.collisionBitMask = 0;
    
    SCNVector3 impulse = SCNVector3Make(displacement.x, 0, displacement.z);
    [bulletNode.physicsBody applyForce:impulse impulse:YES];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        bulletNode.physicsBody.collisionBitMask = PLAYERCATEGORY | HEROCATEGORY;
    });
}

@end