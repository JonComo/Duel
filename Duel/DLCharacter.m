//
//  DLCharacter.m
//  Duel
//
//  Created by Jon Como on 7/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "DLCharacter.h"

@implementation DLCharacter
{
    NSMutableArray *queued;
    
    BOOL isBlocking;
    BOOL isAnimating;
}

-(id)initWithTexturePrefix:(NSString *)prefix
{
    if (self = [super initWithColor:nil size:CGSizeMake(200, 200)]) {
        //load up textures
        self.texturePrefix = prefix;
        self.animations = [NSMutableArray array];
        
        [self.animations addObject:[DLObject texturesForAnimation:@"idle" prefix:prefix count:4]];
        [self.animations addObject:[DLObject texturesForAnimation:@"block" prefix:prefix count:4]];
        [self.animations addObject:[DLObject texturesForAnimation:@"swing" prefix:prefix count:4]];
        
        _mode = DLModeIdle;
        queued = [NSMutableArray array];
        
        [self idle];
    }
    
    return self;
}

-(void)update
{
    [super update];
    
    if (!isAnimating)
    {
        if (isBlocking && self.mode == DLModeBlocking){
            if (queued.count > 0 && [queued[0] intValue] == DLModeBlocking)
                [queued removeObjectAtIndex:0];
            return;
        }
        
        //deque mode
        if (queued.count > 0){
            NSNumber *next = queued[0];
            self.mode = [next intValue];
            [queued removeObjectAtIndex:0];
        }else{
            self.mode = DLModeIdle;
        }
        
        [self act];
    }
}

-(void)act
{
    switch (self.mode) {
        case DLModeIdle:
            [self idle];
            break;
        case DLModeBlocking:
            [self block];
            break;
        case DLModeAttacking:
            [self attack];
            break;
            
        default:
            break;
    }
}

-(void)queueMode:(int)mode
{
    if (self.mode == DLModeIdle){
        //dont have to wait while idled
        self.mode = mode;
        [self act];
    }else{
        if ([[queued lastObject] intValue] != mode)
            [queued addObject:@(mode)];
    }
}

-(void)idle
{
    [self playAnimationWithFrames:self.animations[0]];
}

-(void)inputBlock:(BOOL)down
{
    isBlocking = down;
    
    if (down){
        [self queueMode:DLModeBlocking];
    }
}

-(void)inputAttack
{
    [self queueMode:DLModeAttacking];
}

-(void)attack
{
    [self playAnimationWithFrames:self.animations[2]];
}

-(void)block
{
    [self playAnimationWithFrames:self.animations[1]];
}

-(void)playAnimationWithFrames:(NSArray *)frames
{
    [self removeAllActions];
    
    isAnimating = YES;
    
    SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:0.1];
    [self runAction:[SKAction sequence:@[animation, [SKAction runBlock:^{ isAnimating = NO; }]]]];
}

@end