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
    
    if (self.mode == DLModeDamaged){
        self.colorBlendFactor = self.colorBlendFactor > 0.5 ? 0 : 1;
    }else{
        self.colorBlendFactor = 0;
    }
    
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
    [self playAnimationWithFrames:self.animations[0] times:@[@(0.1), @(0.25), @(0.1), @(0.25)]];
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

-(void)takeDamage
{
    if (self.mode == DLModeDamaged) return;
    
    [self removeAllActions];
    
    self.color = [UIColor redColor];
    
    isAnimating = YES;
    self.mode = DLModeDamaged;
    [queued removeAllObjects];
    
    __weak DLCharacter *weak = self;
    [self runAction:[SKAction waitForDuration:0.2] completion:^{
        isAnimating = NO;
        weak.mode = DLModeIdle;
    }];
}

-(void)attack
{
    [self playAnimationWithFrames:self.animations[2] times:@[@(0.1), @(0.25), @(0.1), @(0.2)]];
    
    __weak DLCharacter *weak = self;
    [self runAction:[SKAction waitForDuration:0.35] completion:^{
        if (weak.target.mode != DLModeBlocking){
            [weak.target takeDamage];
        }
    }];
}

-(void)block
{
    [self playAnimationWithFrames:self.animations[1] times:@[@(0.1), @(0.1), @(0.2), @(0.3)]];
}

-(void)playAnimationWithFrames:(NSArray *)frames times:(NSArray *)times
{
    [self removeAllActions];
    
    isAnimating = YES;
    
    NSMutableArray *frameActions = [NSMutableArray array];
    
    for (int i = 0; i<frames.count; i++){
        [frameActions addObject:[SKAction animateWithTextures:@[frames[i]] timePerFrame:[times[i] floatValue]]];
    }
    
    [frameActions addObject:[SKAction runBlock:^{ isAnimating = NO; }]];

    [self runAction:[SKAction sequence:frameActions]];
}

@end