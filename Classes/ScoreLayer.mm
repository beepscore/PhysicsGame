//
//  ScoreLayer.mm
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import "ScoreLayer.h"


@implementation ScoreLayer
-(id)init {
	self = [super init];
	if (self != nil) {

		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLabel *label = [CCLabel labelWithString:@"Flick to launch snowball" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:50];
		[label setColor:ccc3(0,0,0)];
		label.position = ccp( screenSize.width/2, screenSize.height-30);
		
	}
	
	return self;
}


@end
