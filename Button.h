//
//  Button.h
//  Iron cage
//
//  Created by Adnan Zahid on 6/27/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "SKButton.h"

@interface Button : NSObject

@property SKButton *button;

- (id)initWithName:(NSString *)buttonName offset:(int)offset X:(CGFloat)X Y:(CGFloat)Y;

- (id)initWithName:(NSString *)buttonName offset:(int)offset X:(CGFloat)X Y:(CGFloat)Y scale:(float)scale;

@end