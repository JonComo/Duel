//
//  DLCharacter.h
//  Duel
//
//  Created by Jon Como on 7/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "DLObject.h"

typedef enum
{
    DLModeIdle,
    DLModeBlocking,
    DLModeAttacking,
    DLModeDamaged
} DLMode;

@interface DLCharacter : DLObject

@property (nonatomic, assign) DLMode mode;

@property (nonatomic, weak) DLCharacter *target;

-(id)initWithTexturePrefix:(NSString *)prefix;

-(void)inputBlock:(BOOL)down;
-(void)inputAttack;
-(void)takeDamage;

@end