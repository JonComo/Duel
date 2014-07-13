//
//  DLObject.m
//  Duel
//
//  Created by Jon Como on 7/12/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "DLObject.h"

@implementation DLObject

-(void)update
{
    
}

+(NSArray *)texturesForAnimation:(NSString *)animation prefix:(NSString *)prefix count:(int)count
{
    NSMutableArray *textures = [NSMutableArray array];
    for (int i = 0; i<count; i++) {
        SKTexture *tex = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_%@_%i", prefix, animation, i]];
        tex.filteringMode = SKTextureFilteringNearest;
        if (tex) [textures addObject:tex];
    }
    
    return textures;
}

@end