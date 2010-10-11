/*
 *  Constants.h
 *  PhysicsGame
 *
 *  Created by Rod Strougo on Feb 2010.
 *  Copyright 2010 Prop Group. Code is free to re-use (see Cocos2d license). Most of the source is from Cocos2d examples. See license for Artwork and Sound assets.
 *
 */


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// Values used in positioning the layers
#define	kBackgroundLayerZValue 0
#define kGameplayLayerZValue 5
#define kScoreLayerZValue 10
#define kParticleSystemLayerZValue 3

// Set this to 0 for OFF, and 1 for ON
// sbchanged
//#define BOX2D_DEBUG_DRAW_ON 1
#define BOX2D_DEBUG_DRAW_ON 0


// Set this to 0 for OFF, and 1 for ON

// sb changed
//#define ICE_BLOCK_GRAPHICS_ON 0
#define ICE_BLOCK_GRAPHICS_ON 1

#if (ICE_BLOCK_GRAPHICS_ON)
// Ice blocks from the bottom to the top
#define ICE_BLOCK_FILENAME_1 @"ice2.1.png"
#define ICE_BLOCK_FILENAME_2 @"ice2.2.png"
#define ICE_BLOCK_FILENAME_3 @"ice1.1.png"
#define ICE_BLOCK_FILENAME_4 @"ice1.2.png"
#define ICE_BLOCK_FILENAME_5 @"ice1.3.png"
#define ICE_BLOCK_FILENAME_PENGUIN @"penguino1.png"
#define SNOWBALL_FILENAME @"ball.1-1.png"

#else

// Ice blocks from the bottom to the top
// nil values means no graphics/sprite overlays, only the Box2D debug draw, if enabled
#define ICE_BLOCK_FILENAME_1 nil
#define ICE_BLOCK_FILENAME_2 nil
#define ICE_BLOCK_FILENAME_3 nil
#define ICE_BLOCK_FILENAME_4 nil
#define ICE_BLOCK_FILENAME_5 nil
#define ICE_BLOCK_FILENAME_PENGUIN nil
#define SNOWBALL_FILENAME nil

#endif

// Set this to 0 for OFF, and 1 for ON
#define SOUND_TURNED_ON 0


// ###  SOUNDS & MUSIC ITEMS BELOW ###
// *** CocosDenshion Settings
typedef enum {
	kAppStateAudioManagerInitialising,	//Audio manager is being initialised
	kAppStateSoundBuffersLoading,		//Sound buffers are loading
	kAppStateReady						//Everything is loaded
} tAppState;


///////////////////////////////////////////////////////
//Sound ids, these equate to buffer identifiers
//which are 0 indexed and sequential.  You do not have
//to use all the identifiers but an exception will be
//thrown if you specify an identifier that is greater 
//than or equal to the total number of buffers
#define SND_ID_STARTUP 0 // Startup Sound
#define SND_ID_THROWSOUND1 1
#define SND_ID_THROWSOUND2 2
#define SND_ID_PENGUIN_SQUEAK_1 3
#define SND_ID_PENGUIN_SQUEAK_2 4
#define SND_ID_PENGUIN_SQUEAK_3 5

//Channel group ids, the channel groups define how voices
//will be shared.  If you wish you can simply have a single
//channel group and all sounds will share all the voices
#define CGROUP_BG_MUSIC 0
#define CGROUP_BG_AMBIENCE 1
//#define CGROUP_NON_INTERRUPTIBLE 4

#define CGROUP_TOTAL 2

// Set this to 0 for OFF and 1 for ON
// If ON, the Accelerometer will change gravity
#define ACCELEROMETER_ON 0
