//
//  GameScene.mm
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import "GameScene.h"


@implementation GameScene


-(id)init {
	self = [super init];
	if (self != nil) {
		
		// Create the layers
		
//		// Background Layer
		BackgroundLayer *backgroundLayer = [BackgroundLayer node];
		[self addChild:backgroundLayer z:kBackgroundLayerZValue];

		
		// Gameplay Layer
		GameplayLayer *gameplayLayer = [GameplayLayer node];
		[self addChild:gameplayLayer z:kGameplayLayerZValue];

		
//		// Score/Instructions Layer
		ScoreLayer *scoreLayer = [ScoreLayer node];
		[self addChild:scoreLayer z:kScoreLayerZValue];
		
		
//		// Particle System Layer
		ParticleLayer *particleLayer = [ParticleLayer node];
		[self addChild:particleLayer z:kParticleSystemLayerZValue];
		
		
	}
	return self;
}





@end
