//
//  DLObject.h
//  Duel
//
//  Created by Jon Como on 7/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DLObject : SKSpriteNode

@property (nonatomic, copy) NSString *texturePrefix;
@property (nonatomic, strong) NSMutableArray *animations;

-(void)update;

+(NSArray *)texturesForAnimation:(NSString *)animation prefix:(NSString *)prefix count:(int)count;

@end