//
//  SlowParticleSnow.mm
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import "SlowParticleSnow.h"


@implementation SlowParticleSnow

-(id) init
{
	//return [self initWithTotalParticles:700];
	return [self initWithTotalParticles:75]; // A lot less snow flakes
	
}

-(id) initWithTotalParticles:(int)p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	duration = -1;
	
	// gravity
	gravity.x = 0;
	gravity.y = -1;
	
	// angle
	angle = -90;
	angleVar = 5;
	
	// speed of particles
	speed = 5;
	speedVar = 1;
	
	// radial
	radialAccel = 0;
	radialAccelVar = 1;
	
	// tagential
	tangentialAccel = 0;
	tangentialAccelVar = 1;
	
	// emitter position
	self.position = (CGPoint) {
		[[CCDirector sharedDirector] winSize].width / 2,
		[[CCDirector sharedDirector] winSize].height + 10
	};
	posVar = ccp( [[CCDirector sharedDirector] winSize].width / 2, 0 );
	
	// life of particles
	life = 45;
	lifeVar = 15;
	
	// size, in pixels
	startSize = 8.0f;//10.0f;
	startSizeVar = 5.0f;//5.0f;
	endSize = kParticleStartSizeEqualToEndSize;
	
	// emits per second
	emissionRate = 10;
	
	// color of particles
	startColor.r = 1.0f;
	startColor.g = 1.0f;
	startColor.b = 1.0f;
	//startColor.a = 1.0f;
	startColor.a = 0.6f; // Changed to make the flakes lighter
	startColorVar.r = 0.0f;
	startColorVar.g = 0.0f;
	startColorVar.b = 0.0f;
	startColorVar.a = 0.0f;
	endColor.r = 1.0f;
	endColor.g = 1.0f;
	endColor.b = 1.0f;
	endColor.a = 0.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	
	// additive
	blendAdditive = NO;
	
	return self;
}





@end
