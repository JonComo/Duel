//
//  DLMyScene.m
//  Duel
//
//  Created by Jon Como on 7/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "DLMyScene.h"

@implementation DLMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [UIColor whiteColor];
        
        _opponent = [[DLCharacter alloc] initWithTexturePrefix:@"knight"];
        _opponent.position = CGPointMake(size.width/2 + 40, size.height/2);
        _opponent.xScale = -1;
        [self addChild:_opponent];
        
        _player = [[DLCharacter alloc] initWithTexturePrefix:@"knight"];
        _player.position = CGPointMake(size.width/2 - 40, size.height/2);
        [self addChild:_player];
        
        _player.target = _opponent;
        _opponent.target = _player;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x < self.size.width/2){
            [self.player inputBlock:YES];
        }else{
            [self.player inputAttack];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.player inputBlock:NO];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    for (DLObject *object in self.children){
        [object update];
    }
    
    if (arc4random()%100 > 98){
        [self.opponent inputAttack];
    }
}

@end