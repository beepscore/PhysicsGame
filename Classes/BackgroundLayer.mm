//
//  BackgroundLayer.mm
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

-(id)init {
	self = [super init];
	if (self != nil) {
		
		CCSprite *backgroundImage = [CCSprite spriteWithFile:@"background.png"];
		[backgroundImage setPosition:CGPointMake(240.0f, 160.0f)];
		[self addChild:backgroundImage z:0 tag:0];

	}
	
	return self;
}



@end
