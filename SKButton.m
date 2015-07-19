//
//  SKButton.m
//  Iron cage
//
//  Created by Adnan Zahid on 6/24/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "SKButton.h"

@implementation SKButton

- (instancetype)initWithTexture:(SKTexture *)texture color:(SKColor *)color size:(CGSize)size {
    return [self initWithTextureNormal:texture selected:nil disabled:nil];
}

- (instancetype)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected {
    return [self initWithTextureNormal:normal selected:selected disabled:nil];
}

- (instancetype)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected disabled:(SKTexture *)disabled {
    self = [super initWithTexture:normal color:[SKColor whiteColor] size:normal.size];
    if (self) {
        [self setMyNormalTexture:normal];
        [self setSelectedTexture:selected];
        [self setDisabledTexture:disabled];
        [self setIsEnabled:YES];
        [self setIsSelected:NO];
        
        _title = [SKLabelNode labelNodeWithFontNamed:@"AcademyEngravedLetPlain"];
        [_title setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [_title setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        
        [self addChild:_title];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (instancetype)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected {
    return [self initWithImageNamedNormal:normal selected:selected disabled:nil];
}

- (instancetype)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected disabled:(NSString *)disabled {
    SKTexture *textureNormal = nil;
    if (normal) {
        textureNormal = [SKTexture textureWithImageNamed:normal];
    }
    
    SKTexture *textureSelected = nil;
    if (selected) {
        textureSelected = [SKTexture textureWithImageNamed:selected];
    }
    
    SKTexture *textureDisabled = nil;
    if (disabled) {
        textureDisabled = [SKTexture textureWithImageNamed:disabled];
    }
    
    return [self initWithTextureNormal:textureNormal selected:textureSelected disabled:textureDisabled];
}

- (void)setTouchUpInsideTarget:(id)target action:(SEL)action {
    _targetTouchUpInside = target;
    _actionTouchUpInside = action;
}

- (void)setTouchDownTarget:(id)target action:(SEL)action {
    _targetTouchDown = target;
    _actionTouchDown = action;
}

- (void)setTouchUpTarget:(id)target action:(SEL)action {
    _targetTouchUp = target;
    _actionTouchUp = action;
}

- (void)setIsEnabled:(BOOL)isEnabled {
    _isEnabled = isEnabled;
    if ([self disabledTexture]) {
        if (!_isEnabled) {
            [self setTexture:_disabledTexture];
        } else {
            [self setTexture:_myNormalTexture];
        }
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if ([self selectedTexture] && [self isEnabled]) {
        if (_isSelected) {
            [self setTexture:_selectedTexture];
        } else {
            [self setTexture:_myNormalTexture];
        }
    }
}

#if TARGET_OS_IPHONE

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self isEnabled]) {
        if (_actionTouchDown){
            [self.parent performSelectorOnMainThread:_actionTouchDown withObject:_targetTouchDown waitUntilDone:YES];
            [self setIsSelected:YES];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self isEnabled]) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInNode:self.parent];
        
        if (CGRectContainsPoint(self.frame, touchPoint)) {
            [self setIsSelected:YES];
        } else {
            [self setIsSelected:NO];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    if ([self isEnabled] && CGRectContainsPoint(self.frame, touchPoint)) {
        if (_actionTouchUpInside){
            
            [self.parent performSelectorOnMainThread:_actionTouchUpInside withObject:_targetTouchUpInside waitUntilDone:YES];
        }
    }
    [self setIsSelected:NO];
    if (_actionTouchUp){
        [self.parent performSelectorOnMainThread:_actionTouchUp withObject:_targetTouchUp waitUntilDone:YES];
    }
}
#else
- (void)mouseDown:(NSEvent *)theEvent {
    if ([self isEnabled]) {
        if (_actionTouchDown){
            [self.parent performSelectorOnMainThread:_actionTouchDown withObject:_targetTouchDown waitUntilDone:YES];
            [self setIsSelected:YES];
        }
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
    
    if ([self isEnabled]) {
        CGPoint touchPoint = [theEvent locationInNode:self.parent];
        
        if (CGRectContainsPoint(self.frame, touchPoint)) {
            [self setIsSelected:YES];
        } else {
            [self setIsSelected:NO];
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    
    CGPoint touchPoint = [theEvent locationInNode:self.parent];
    
    if ([self isEnabled] && CGRectContainsPoint(self.frame, touchPoint)) {
        if (_actionTouchUpInside){
            [self.parent performSelectorOnMainThread:_actionTouchUpInside withObject:_targetTouchUpInside waitUntilDone:YES];
        }
    }
    [self setIsSelected:NO];
    if (_actionTouchUp){
        [self.parent performSelectorOnMainThread:_actionTouchUp withObject:_targetTouchUp waitUntilDone:YES];
    }
}
#endif

@end