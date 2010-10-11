//
//  GameplayLayer.h
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// Sound Imports
#import "CocosDenshion.h"
#import "CDAudioManager.h"

// Game Contants
#import "Constants.h"

@interface GameplayLayer : CCLayer {
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	
	CGPoint startPoint;
	
	// Sound/Audio Items
	CDAudioManager *am;
	CDSoundEngine  *soundEngine;
	tAppState		_appState;
	
	
}



@end
