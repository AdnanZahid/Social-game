//
//  ControlDelegate.h
//  Social game
//
//  Created by Adnan Zahid on 7/17/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ControlDelegate <NSObject>

- (void)UpAction;
- (void)DownAction;
- (void)LeftAction;
- (void)RightAction;
- (void)FireAction;

@end