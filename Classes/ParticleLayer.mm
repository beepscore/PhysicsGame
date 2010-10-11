//
//  ParticleLayer.mm
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import "ParticleLayer.h"


@implementation ParticleLayer
@synthesize emitter;

-(id) init
{
	if( (self=[super init])) {
		// Snow emitter
		particleSystemSprite = (CCSprite*) self;
		//self.emitter = [CCParticleSnow node];	 // Fast snow storm
		self.emitter = [SlowParticleSnow node]; // Slow snow fall
		
		[particleSystemSprite addChild: emitter z:500]; 
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		emitter.position = ccp(s.width/2,450.0f); 
		
		
		
		CGPoint p = emitter.position;
		emitter.position = ccp( p.x, p.y-110);
		emitter.life = 3;
		emitter.lifeVar = 1;
		
		// gravity
		emitter.gravity = ccp(0,-10);
		
		// speed of particles
		emitter.speed = 130;
		emitter.speedVar = 30;
		
		
		ccColor4F startColor = emitter.startColor;
		startColor.r = 0.9f;
		startColor.g = 0.9f;
		startColor.b = 0.9f;
		emitter.startColor = startColor;
		
		ccColor4F startColorVar = emitter.startColorVar;
		startColorVar.b = 0.1f;
		emitter.startColorVar = startColorVar;
		
		emitter.emissionRate = emitter.totalParticles/emitter.life;
		
		emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"snow.png"];
		
	}
	return self;
}
@end
