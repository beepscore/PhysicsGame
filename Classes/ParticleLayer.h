//
//  ParticleLayer.h
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SlowParticleSnow.h"

@interface ParticleLayer : CCLayer {
	CCParticleSystem	*emitter;
	CCSprite *particleSystemSprite;
	
}
@property (readwrite,retain) CCParticleSystem *emitter;

@end
