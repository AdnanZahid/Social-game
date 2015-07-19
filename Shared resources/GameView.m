//
//  GameView.m
//  Social game
//
//  Created by Adnan Zahid on 7/10/15.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "GameView.h"

@implementation GameView {
    
    SCNScene *scene;
    Player *hero;
    
    NSMutableArray *gameCharacters;
    int ID;
    
    HUD *hud;
    int health;
}

SocketIOClient *socketIO;

- (void)awakeFromNib {
    
    gameCharacters = [NSMutableArray array];
    
    scene = [[SceneFactory alloc] sceneWithTarget:self];
    
    hud = [HUD sceneWithSize:CGSizeMake(1024, 768)];
    self.overlaySKScene = hud;
    hud.controlDelegate = self;
    
    health = 100;
    
    [self setupFloor];
    
    [self connectToServer];
    
    [self receiveIDFromServer];
    
    [self receiveSpawnFromServer];
    
    [self receiveRequestIDFromServer];
    
    [self receivePositionFromServer];
    
    [self receiveRotationFromServer];
    
    [self receiveFireFromServer];
    
    [self receiveGameOverFromServer];
    
    scene.physicsWorld.contactDelegate = self;
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact {
    
    SCNPhysicsBody *firstBody;
    SCNPhysicsBody *secondBody;
    
    SCNNode *firstNode;
    SCNNode *secondNode;
    
    if (contact.nodeA.physicsBody.categoryBitMask < contact.nodeB.physicsBody.categoryBitMask) {
        firstBody = contact.nodeA.physicsBody;
        secondBody = contact.nodeB.physicsBody;
        
        firstNode = contact.nodeA;
        secondNode = contact.nodeB;
        
    }
    else {
        firstBody = contact.nodeB.physicsBody;
        secondBody = contact.nodeA.physicsBody;
        
        firstNode = contact.nodeB;
        secondNode = contact.nodeA;
    }
    
    if (firstBody.categoryBitMask == PLAYERCATEGORY | firstBody.categoryBitMask == HEROCATEGORY) {
        if (secondBody.categoryBitMask == BULLETCATEGORY) {
            
            [self createParticleOfSize:100 contactPoint:contact.contactPoint];
            
            [secondNode removeFromParentNode];
            
            if (firstBody.categoryBitMask == HEROCATEGORY) {
                
                health -= 10;
                [hud damage:health];
                
                if (health == 0) {
                    
                    [self gameOver];
                }
            }
        }
    }
}

- (void)gameOver {
    
    [self sendGameOverToServer];
}

- (void)createParticleOfSize:(int)size contactPoint:(SCNVector3)contactPoint {
    
    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"explosion.scnp" inDirectory:@"art.scnassets"];
    particleSystem.particleSize = size;
    
    particleSystem.particleColor = [SCNColor orangeColor];
    
    SCNNode *explosionNode = [SCNNode node];
    explosionNode.position = contactPoint;
    
    [explosionNode addParticleSystem:particleSystem];
    
    [scene.rootNode addChildNode:explosionNode];
}

- (void)connectToServer {
    
    socketIO = [[SocketIOClient alloc] initWithSocketURL:@"http://192.168.1.6:80" options:nil];
    [socketIO connect];
    
    [socketIO on:@"connect" callback:^(NSArray* data, void (^ack)(NSArray*)) {
    }];
}

- (void)receiveIDFromServer {
    
    [socketIO on:@"assignID" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        
        ID = [[data objectAtIndex:0] intValue];
        
        [self setupHero];
        
        [self setupCamera];
    }];
}

- (void)sendRequestIDToServer {
    
    NSArray *IDArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:ID], nil];
    
    [socketIO emit:@"requestID" withItems:@[IDArray]];
}

- (void)receiveRequestIDFromServer {
    
    [socketIO on:@"requestID" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        
        [self sendRequestIDToServer];
        
        [self sendPositionToServer];
        
        [self sendRotationToServer];
    }];
}

- (void)receiveSpawnFromServer {
    
    [socketIO on:@"spawn" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        
        int enemyIDValue = [[data objectAtIndex:0] intValue];
        
        int zPosition = -(enemyIDValue * 2000);
        
        Player *enemy = [[Player alloc] initWithTarget:scene characterID:enemyIDValue Z:zPosition angle:(enemyIDValue) % 2];
        
        if ([gameCharacters count] <= enemyIDValue) {
            
            [gameCharacters insertObject:enemy atIndex:enemyIDValue];
        }
        else {
            [gameCharacters replaceObjectAtIndex:enemyIDValue withObject:enemy];
        }
        
        [hud spawn:enemyIDValue position:CGPointMake(0, -zPosition/50) isHero:NO];
    }];
}

- (void)sendPositionToServer {
    
    NSArray *positionArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithInt:ID],
                              [NSNumber numberWithDouble:hero.node.position.x],
                              [NSNumber numberWithDouble:hero.node.position.y],
                              [NSNumber numberWithDouble:hero.node.position.z], nil];
    
    [socketIO emit:@"position" withItems:@[positionArray]];
}

- (void)receivePositionFromServer {
    
    [socketIO on:@"position" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        
        NSArray *position = [data objectAtIndex:0];
        
        int characterID = [[position objectAtIndex:0] intValue];
        
        Player *characterToMove = (Player *)[gameCharacters objectAtIndex:characterID];
        
        characterToMove.node.position = SCNVector3Make([[position objectAtIndex:1] intValue],
                                                       [[position objectAtIndex:2] intValue],
                                                       [[position objectAtIndex:3] intValue]);
        
        [hud position:characterID position:CGPointMake(characterToMove.node.position.x/50, -characterToMove.node.position.z/50)];
    }];
}

- (void)sendRotationToServer {
    
    NSArray *rotationArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithInt:ID],
                              [NSNumber numberWithDouble:hero.node.eulerAngles.x],
                              [NSNumber numberWithDouble:hero.node.eulerAngles.y],
                              [NSNumber numberWithDouble:hero.node.eulerAngles.z], nil];
    
    [socketIO emit:@"rotation" withItems:@[rotationArray]];
}

- (void)receiveRotationFromServer {
    
    [socketIO on:@"rotation" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        
        NSArray *rotation = [data objectAtIndex:0];
        
        int characterID = [[rotation objectAtIndex:0] intValue];
        
        Player *characterToRotate = (Player *)[gameCharacters objectAtIndex:characterID];
        
        characterToRotate.node.eulerAngles = SCNVector3Make([[rotation objectAtIndex:1] floatValue],
                                                            [[rotation objectAtIndex:2] floatValue],
                                                            [[rotation objectAtIndex:3] floatValue]);
    }];
}

- (void)sendFireToServer {
    
    NSArray *fireArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:ID], nil];
    
    [socketIO emit:@"fire" withItems:@[fireArray]];
}

- (void)receiveFireFromServer {
    
    [socketIO on:@"fire" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        
        NSArray *fire = [data objectAtIndex:0];
        
        int characterID = [[fire objectAtIndex:0] intValue];
        
        if (ID != characterID) {
            
            Player *characterToFire = (Player *)[gameCharacters objectAtIndex:characterID];
            [characterToFire createBullet];
        }
    }];
}

- (void)sendGameOverToServer {
    
    NSArray *gameOverArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:ID], nil];
    
    [socketIO emit:@"gameOver" withItems:@[gameOverArray]];
}

- (void)receiveGameOverFromServer {
    
    [socketIO on:@"gameOver" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        
        NSArray *gameOver = [data objectAtIndex:0];
        
        int characterID = [[gameOver objectAtIndex:0] intValue];
        
        Player *characterToGameOver = (Player *)[gameCharacters objectAtIndex:characterID];
        
        [characterToGameOver.node removeFromParentNode];
        
        SCNVector3 explosionPosition = SCNVector3Make(characterToGameOver.node.position.x, characterToGameOver.node.position.y + 200, characterToGameOver.node.position.z);
        
        [self createParticleOfSize:300 contactPoint:explosionPosition];
        
        [hud removeBlip:characterID];
    }];
}

#if TARGET_OS_IPHONE
#else
- (void)keyDown:(NSEvent *)theEvent {
    
    unsigned short keyCode = theEvent.keyCode;
    
    [self isMoved:keyCode];
    
    [self isRotated:keyCode];
    
    [self isFired:keyCode];
}
#endif

- (SCNVector3)displacement {
    
    int velocity = 50;
    SCNVector3 displacement = [GeometryHelper getDisplacement:velocity node:hero.node];
    
    return displacement;
}

- (void)isMoved:(short)keyCode {
    
    SCNVector3 displacement = [self displacement];
    
    if (keyCode == FORWARD_KEY || keyCode == BACK_KEY || keyCode == A_KEY || keyCode == D_KEY) {
        
        if (keyCode == FORWARD_KEY) {
            
            [self UpAction];
        }
        else if (keyCode == BACK_KEY) {
            
            [self DownAction];
        }
        else if (keyCode == A_KEY) {
            
            hero.node.position = SCNVector3Make(hero.node.position.x + displacement.z, hero.node.position.y, hero.node.position.z + displacement.x);
            
            [self sendPositionToServer];
        }
        else if (keyCode == D_KEY) {
            
            hero.node.position = SCNVector3Make(hero.node.position.x - displacement.z, hero.node.position.y, hero.node.position.z - displacement.x);
            
            [self sendPositionToServer];
        }
    }
}

- (void)UpAction {
    
    SCNVector3 displacement = [self displacement];
    
    hero.node.position = SCNVector3Make(hero.node.position.x + displacement.x, hero.node.position.y, hero.node.position.z + displacement.z);
    
    [self sendPositionToServer];
}

- (void)DownAction {
    
    SCNVector3 displacement = [self displacement];
    
    hero.node.position = SCNVector3Make(hero.node.position.x - displacement.x, hero.node.position.y, hero.node.position.z - displacement.z);
    
    [self sendPositionToServer];
}

- (void)LeftAction {
    
    CGFloat displacement = M_PI_4/8;
    
    hero.node.eulerAngles = SCNVector3Make(hero.node.eulerAngles.x, hero.node.eulerAngles.y + displacement, hero.node.eulerAngles.z);
    
    [self sendRotationToServer];
}

- (void)RightAction {
    
    CGFloat displacement = M_PI_4/8;
    
    hero.node.eulerAngles = SCNVector3Make(hero.node.eulerAngles.x, hero.node.eulerAngles.y - displacement, hero.node.eulerAngles.z);
    
    [self sendRotationToServer];
}

- (void)FireAction {
    
    [hero createBullet];
    
    [self sendFireToServer];
}

- (void)isRotated:(short)keyCode {
    
    if (keyCode == W_KEY || keyCode == S_KEY || keyCode == LEFT_KEY || keyCode == RIGHT_KEY) {
        
        CGFloat displacement = M_PI_4/8;
        
        if (keyCode == W_KEY) {
            
            hero.node.eulerAngles = SCNVector3Make(hero.node.eulerAngles.x + displacement, hero.node.eulerAngles.y, hero.node.eulerAngles.z);
            
            [self sendRotationToServer];
        }
        else if (keyCode == S_KEY) {
            
            hero.node.eulerAngles = SCNVector3Make(hero.node.eulerAngles.x - displacement, hero.node.eulerAngles.y, hero.node.eulerAngles.z);
            
            [self sendRotationToServer];
        }
        else if (keyCode == LEFT_KEY) {
            
            [self LeftAction];
        }
        else if (keyCode == RIGHT_KEY) {
            
            [self RightAction];
        }
    }
}

- (void)isFired:(short)keyCode {
    
    if (keyCode == SPACE_KEY) {
        
        [self FireAction];
    }
}

- (void)setupHero {
    
    hero = [[Player alloc] initWithTarget:scene characterID:ID Z:-(ID * 2000) angle:(ID) % 2];
    
    hero.node.physicsBody.categoryBitMask = HEROCATEGORY;
    
    for (int i = 0; i < ID; i ++) {
        
        [gameCharacters insertObject:[NSNull null] atIndex:i];
    }
    
    [gameCharacters insertObject:hero atIndex:ID];
    
    [hud spawn:ID position:CGPointMake(0, -hero.node.position.z/50) isHero:YES];
}

- (void)setupCamera {
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.zFar = 50000;
    [hero.node addChildNode:cameraNode];
    
    cameraNode.position = SCNVector3Make(0, 350, 0);
    cameraNode.eulerAngles = SCNVector3Make(-M_PI_4/2, 0, 0);
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    [cameraNode addChildNode:lightNode];
}

- (void)setupFloor {
    SCNFloor *floor = [SCNFloor new];
    floor.reflectivity = 0.0;
    
    SCNNode *floorNode = [SCNNode new];
    floorNode.geometry = floor;
    
    SCNMaterial *floorMaterial = [SCNMaterial new];
    floorMaterial.litPerPixel = NO;
    
#if TARGET_OS_IPHONE
    floorMaterial.diffuse.contents = [UIImage imageNamed:@"grass"];
#else
    floorMaterial.diffuse.contents = [NSImage imageNamed:@"grass"];
#endif
    
    floorMaterial.diffuse.wrapS = SCNWrapModeRepeat;
    floorMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    
    floor.materials = @[floorMaterial];
    
    [scene.rootNode addChildNode:floorNode];
}

@end