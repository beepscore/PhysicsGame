//
//  GameplayLayer.mm
//  PhysicsGame
//
//  Created by Rod Strougo on Feb 2010.
//  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
//

#import "GameplayLayer.h"


@implementation GameplayLayer

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}



-(void)createPhysicsWorld {
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = true;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity, doSleep);
	
	world->SetContinuousPhysics(true);

#if (BOX2D_DEBUG_DRAW_ON)	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	//		flags += b2DebugDraw::e_jointBit;
			flags += b2DebugDraw::e_aabbBit;
	//		flags += b2DebugDraw::e_pairBit;
			flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
#endif	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2PolygonShape groundBox;		
	
	// bottom
	groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox);
	
	// top
	groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox);
	
	// left
	groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox);
	
	// right
	groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox);
	
}


-(void)addNewBodyWithCoords:(CGPoint)p 
			 withDimensions:(CGPoint)boxDimensions 
				 andDensity:(float32)boxDensity 
			  andWithSprite:(NSString*)spriteFileName {
	
	
	CCSprite *sprite = nil;
	if (spriteFileName != nil) {
		sprite = [CCSprite spriteWithFile:spriteFileName];
		[sprite setPosition:ccp(p.x,p.y)]; // Remember ccp() is macro for CGPointMake()
		[self addChild:sprite];
		
		
		if ([spriteFileName isEqualToString:ICE_BLOCK_FILENAME_PENGUIN]) {
			// Lets add the penguin animations
			CCAnimation *penguinAnimation = [CCAnimation animationWithName:@"penguinMoves" delay:0.5f];
			[penguinAnimation addFrameWithFilename:@"penguino1.png"];
			[penguinAnimation addFrameWithFilename:@"penguino2.png"];
			[penguinAnimation addFrameWithFilename:@"penguino3.png"];
			[penguinAnimation addFrameWithFilename:@"penguino4.png"];
			
			[sprite addAnimation:penguinAnimation];
			id action = [CCAnimate actionWithAnimation:penguinAnimation restoreOriginalFrame:NO];
			id actionCall = [CCCallFunc actionWithTarget:self selector:@selector(playRandomArcticSqueakSound)];
			id actionSequence = [CCSequence actions:actionCall,action,nil];
			id repeatForeverMoves = [CCRepeatForever actionWithAction:actionSequence];
			[sprite stopAllActions];
			[sprite runAction:repeatForeverMoves];
			
		}
		
		
	}
	
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;

	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	
	// Tell the physics world to create the body
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;

	dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = boxDensity;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.5f; // 0 is a lead ball, 1 is a super bouncy ball
	body->CreateFixture(&fixtureDef);
}


-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(1.0f/60.0f, velocityIterations, positionIterations);

	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}

#if (BOX2D_DEBUG_DRAW_ON)	
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}
#endif

-(void)playSoundWithID:(int)soundID withChannelGroupID:(int)channelGroupID shouldLoop:(BOOL)loopYesNo {
	if (_appState == kAppStateReady) {
		//CCLOG(@"AppState is ready");
		am = [CDAudioManager sharedManager];
		soundEngine = am.soundEngine;
		
		/* @param soundId the id of the sound to play (buffer id).
		 * @param channelGroupId the channel group that will be used to play the sound.
		 * @param pitch pitch multiplier. e.g 1.0 is unaltered, 0.5 is 1 octave lower. 
		 * @param pan stereo position. -1 is fully left, 0 is centre and 1 is fully right.
		 * @param gain gain multiplier. e.g. 1.0 is unaltered, 0.5 is half the gain
		 * @param loop should the sound be looped or one shot.
		 * @return the id of the source being used to play the sound or CD_MUTE if the sound engine is muted or non functioning */
		
		// Play the sound
		[soundEngine playSound:soundID channelGroupId:channelGroupID pitch:1.0f pan:0.0f gain:1.0f loop:loopYesNo];
		
		
	} else if (_appState == kAppStateSoundBuffersLoading) {
			CCLOG(@"Sound buffers could still be loading ...");
			//Check if sound buffers have completed loading, asynchLoadProgress represents fraction of completion and 1.0 is complete.
			if ([CDAudioManager sharedManager].soundEngine.asynchLoadProgress >= 1.0f) {
				//Sounds have finished loading
				_appState = kAppStateReady;
				//[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(backgroundMusicFinished)]; 
				//[[CDAudioManager sharedManager].soundEngine setChannelGroupNonInterruptible:CGROUP_NON_INTERRUPTIBLE isNonInterruptible:TRUE];
				[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:TRUE];
			} else {
				CCLOG(@"Denshion: sound buffers loading %0.2f",[CDAudioManager sharedManager].soundEngine.asynchLoadProgress);
			}	
	} 
}


-(void)playRandomArcticSqueakSound {
#if (SOUND_TURNED_ON)
	int shouldPlayAudio = (random() % 3) + 1;
	if (shouldPlayAudio == 1) {
		[self playSoundWithID:SND_ID_PENGUIN_SQUEAK_1 withChannelGroupID:CGROUP_BG_AMBIENCE shouldLoop:NO];
	} else if (shouldPlayAudio == 2) {
		[self playSoundWithID:SND_ID_PENGUIN_SQUEAK_2 withChannelGroupID:CGROUP_BG_AMBIENCE shouldLoop:NO];
	} else if (shouldPlayAudio == 3) {
		[self playSoundWithID:SND_ID_PENGUIN_SQUEAK_3 withChannelGroupID:CGROUP_BG_AMBIENCE shouldLoop:NO];
	} 
#endif
}



-(void)playBackgroundMusic {
	// Lets make sure the audio engine is ready
	if (_appState == kAppStateReady) {
		am = [CDAudioManager sharedManager];
		soundEngine = am.soundEngine;
	
		[am playBackgroundMusic:@"Penguino.mp3" loop:YES];
		NSLog(@"Playing BG Music");
		
	}
}


-(void) loadSoundBuffers:(NSObject*) data {
	
	//Wait for the audio manager if it is not initialised yet
	while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {
		[NSThread sleepForTimeInterval:0.1];
		//NSLog(@"Waiting for sound enging to initialize");
	}	
	//kAMStateUninitialised, //!Audio manager has not been initialised - do not use
	//kAMStateInitialising,  //!Audio manager is in the process of initialising - do not use
	//kAMStateInitialised	   //!Audio manager is initialised - safe to use
	
	
	//Load the buffers with audio data. There is no correspondence between voices/channels and
	//buffers.  For example you can play the same sound in multiple channel groups with different
	//pitch, pan and gain settings.
	//Buffers can be loaded with different sounds simply by calling loadBuffer again, however,
	//any sources attached to the buffer will be stopped if they are currently playing
	//Use: afconvert -f caff -d ima4 yourfile.wav to create an ima4 compressed version of a wave file
	CDSoundEngine *sse = [CDAudioManager sharedManager].soundEngine;

	//Code for loading buffers synchronously
	[sse loadBuffer:SND_ID_THROWSOUND1 filePath:@"SnowThrow1.wav"];
	[sse loadBuffer:SND_ID_THROWSOUND2 filePath:@"SnowThrow2.wav"];
	[sse loadBuffer:SND_ID_PENGUIN_SQUEAK_1 filePath:@"PenguinSqueak1.mp3"];
	[sse loadBuffer:SND_ID_PENGUIN_SQUEAK_2 filePath:@"PenguinSqueak2.mp3"];
	[sse loadBuffer:SND_ID_PENGUIN_SQUEAK_3 filePath:@"PenguinSqueak3.mp3"];
	_appState = kAppStateReady;
		
	//Load sound buffers asynchrounously
	/*
	NSMutableArray *loadRequests = [[[NSMutableArray alloc] init] autorelease];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_DRUMLOOP filePath:@"808_120bpm.caf"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_TONELOOP filePath:@"sine440.caf"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_BALL filePath:@"ballbounce.wav"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_GUN filePath:@"machinegun.caf"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_STAB filePath:@"rustylow.wav"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_COWBELL filePath:@"cowbell.wav"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_EXPLODE filePath:@"explodelow.wav"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_ID_KARATE filePath:@"karate.wav"] autorelease]];
	[sse loadBuffersAsynchronously:loadRequests];
	_appState = kAppStateSoundBuffersLoading;
	*/
	//Sound engine is now set up. You can check the functioning property to see if everything worked.
	//In addition the loadBuffer method returns a boolean indicating whether it worked.
	//If your buffers loaded and the functioning = TRUE then you are set to play sounds.
	
	[self playBackgroundMusic];
}
	
	

-(void)initializeSoundEngine {
	
	am = nil;
	soundEngine = nil;
	
	if ([CDAudioManager sharedManagerState] != kAMStateInitialised) {
		//The audio manager is not initialised yet so kick off the sound loading as an NSOperation that will wait for
		//the audio manager
		NSInvocationOperation* bufferLoadOp = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadSoundBuffers:) object:nil] autorelease];
		NSOperationQueue *opQ = [[[NSOperationQueue alloc] init] autorelease]; 
		[opQ addOperation:bufferLoadOp];
		_appState = kAppStateAudioManagerInitialising;
	} else {
		[self loadSoundBuffers:nil];
		_appState = kAppStateSoundBuffersLoading;
	}
}


-(void)setupAudioManager {
	//Channel groups define how voices are shared, the maximum number of voices is defined by 
	//CD_MAX_SOURCES in the CocosDenshion.h file
	//When a request is made to play a sound within a channel group the next available voice
	//is used.  If no voices are free then the least recently used voice is stopped and reused.
	int channelGroupCount = CGROUP_TOTAL;
	int channelGroups[CGROUP_TOTAL];
	channelGroups[CGROUP_BG_MUSIC] = 1;//This means only 1 loop will play at a time
	channelGroups[CGROUP_BG_AMBIENCE] = 16;//16 voices to be shared by the fx
	
	//Initialise audio manager asynchronously as it can take a few seconds
	[CDAudioManager initAsynchronously:kAudioManagerFxPlusMusicIfNoOtherAudio channelGroupDefinitions:channelGroups channelGroupTotal:channelGroupCount];
	//[CDAudioManager initAsynchronously:kAudioManagerFxPlusMusic channelGroupDefinitions:channelGroups channelGroupTotal:channelGroupCount];
}




-(id)init {
	if ((self=[super init])) {
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		
		[self createPhysicsWorld];
		
		[self addNewBodyWithCoords:ccp((screenSize.width/2)+80.0f, screenSize.height/2) 
					withDimensions:ccp(1.0f,0.5f) 
						andDensity:3.0f 
					 andWithSprite:ICE_BLOCK_FILENAME_1];
		
		
		[self addNewBodyWithCoords:ccp((screenSize.width/2)+80.0f, (screenSize.height/2)+30.0f) 
					withDimensions:ccp(1.0f,0.5f) 
						andDensity:3.0f 
					 andWithSprite:ICE_BLOCK_FILENAME_2];
		
		[self addNewBodyWithCoords:ccp((screenSize.width/2)+80.0f, (screenSize.height/2)+60.0f) 
					withDimensions:ccp(0.5f,0.5f) 
						andDensity:3.0f 
					 andWithSprite:ICE_BLOCK_FILENAME_3];
		
		
		[self addNewBodyWithCoords:ccp((screenSize.width/2)+80.0f, (screenSize.height/2)+90.0f) 
					withDimensions:ccp(0.5f,0.5f) 
						andDensity:3.0f 
					 andWithSprite:ICE_BLOCK_FILENAME_4];
		
		[self addNewBodyWithCoords:ccp((screenSize.width/2)+80.0f, (screenSize.height/2)+120.0f) 
					withDimensions:ccp(0.5f,0.5f) 
						andDensity:3.0f 
					 andWithSprite:ICE_BLOCK_FILENAME_5];
		
		
		[self addNewBodyWithCoords:ccp((screenSize.width/2)+80.0f, (screenSize.height/2)+150.0f) 
					withDimensions:ccp(0.65f,0.9f) 
						andDensity:3.0f 
					 andWithSprite:ICE_BLOCK_FILENAME_PENGUIN];

		
		// Sound and Music
		#if (SOUND_TURNED_ON)
		[self setupAudioManager]; // This could be in the AppDelegate
		[self initializeSoundEngine];
		[self schedule:@selector(playRandomArcticSqueakSound) interval:5.0f];
		#endif
		
		// Start the scheduler to call the tick function
		[self schedule: @selector(tick:)];
		
	}
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		startPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
		
	}
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		
		CGPoint endPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
				
		double diffX = endPoint.x - startPoint.x;
		double diffY = endPoint.y - startPoint.y;
		double dist = sqrt(diffX * diffX + diffY * diffY);   // a^2 + b^2 = c^2  --> http://en.wikipedia.org/wiki/Pythagorean_theorem
		
		
		// I'm couting a flick as greater then 10.0f pixels, play with this value
		if (dist > 10.0f) {
			// Create the object and add impulse
			CCSprite *sprite = nil;
			#if (ICE_BLOCK_GRAPHICS_ON)
				sprite = [CCSprite spriteWithFile:SNOWBALL_FILENAME];
				[sprite setPosition:ccp(startPoint.x,startPoint.y)]; // Remember ccp() is macro for CGPointMake()
				[self addChild:sprite];
			#endif
			
			
			
			// The snowball is a circle body (instead of a rectangle box)		
			b2CircleShape circleShape;
			b2FixtureDef fd;
			b2Vec2 initVel;
			b2BodyDef circleBodyDefinition;
			circleBodyDefinition.type = b2_dynamicBody;
			circleBodyDefinition.position.Set(startPoint.x/PTM_RATIO, startPoint.y/PTM_RATIO);
			circleBodyDefinition.angle = 0.000000f;
			circleBodyDefinition.userData = sprite;
			b2Body *body = world->CreateBody(&circleBodyDefinition);
			initVel.Set(0.000000f, 0.000000f);
			body->SetLinearVelocity(initVel);
			
			// Lets add a random spin on the snowball, makes it look better
			int generatedAngularVelocity = (random()  % 20) + 1;
			if (generatedAngularVelocity < 10) { generatedAngularVelocity = generatedAngularVelocity * -1; }
			body->SetAngularVelocity(generatedAngularVelocity);
		
			circleShape.m_radius = 0.5f;
			fd.shape = &circleShape;
			fd.density = 1.000f;
			fd.friction = 1.0f;
			fd.restitution = 0.6f;
			fd.userData = sprite;
			
			body->CreateFixture(&fd);
			
			// 2. Add an impulse on the direction of the flick and with the flick force
			
			CGPoint forceVector = CGPointMake((endPoint.x-startPoint.x)/PTM_RATIO,(endPoint.y-startPoint.y)/PTM_RATIO);
			forceVector = CGPointMake(forceVector.x*2, forceVector.y*2);
			
			b2Vec2 blockImpulse = b2Vec2(forceVector.x,forceVector.y);
			body->ApplyImpulse(blockImpulse, body->GetPosition());
			
			
			int whichSoundToPlay = (random() % 100) +1;
			if (whichSoundToPlay <= 50) {
				[self playSoundWithID:SND_ID_THROWSOUND1 withChannelGroupID:CGROUP_BG_AMBIENCE shouldLoop:NO];
			} else {
				[self playSoundWithID:SND_ID_THROWSOUND2 withChannelGroupID:CGROUP_BG_AMBIENCE shouldLoop:NO];
			}
			
			
		} else {
			//NSLog(@"No Flick occured");
		}
	}
}

#if (ACCELEROMETER_ON)
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
	#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}
#endif


@end
