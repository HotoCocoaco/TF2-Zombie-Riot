#pragma semicolon 1
#pragma newdecls required

#include <tf2_stocks>
#include <sdkhooks>
#include <collisionhook>
#include <clientprefs>
#include <dhooks>
#include <tf2items>
#include <tf_econ_data>
#include <tf2attributes>
#include <lambda>
#include <cbasenpc>
#include <morecolors>
#tryinclude <menus-controller>

#define CHAR_FULL	"█"
#define CHAR_PARTFULL	"▓"
#define CHAR_PARTEMPTY	"▒"
#define CHAR_EMPTY	"░"

#define NPC_HARD_LIMIT 42 
#define ZR_MAX_NPCS (NPC_HARD_LIMIT*2)
#define ZR_MAX_NPCS_ALLIED 42 //Never need more.
#define ZR_MAX_LAG_COMP 128 
#define ZR_MAX_BUILDINGS 64 //cant ever have more then 64 realisticly speaking
#define ZR_MAX_TRAPS 64
#define ZR_MAX_BREAKBLES 32
#define ZR_MAX_SPAWNERS 32 //cant ever have more then 32, if your map does, then what thed fuck are you doing ?
#define ZR_MAX_GIBCOUNT 20 //Anymore then this, and it will only summon 1 gib per zombie instead.

#define MAX_PLAYER_COUNT			12
#define MAX_PLAYER_COUNT_STRING		"12"
//cant do more then 12, more then 12 cause memory isssues because that many npcs can just cause that much lag


//#pragma dynamic    131072
//Allah This plugin has so much we need to do this.

// THESE ARE TO TOGGLE THINGS!

#define LagCompensation

#define HaveLayersForLagCompensation

//Not used cus i need all the performance i can get.

#define NoSendProxyClass

//maybe doing this will help lag, as there are no aim layers in zombies, they always look forwards no matter what.

//edit: No, makes you miss more often.


//Comment this out, and reload the plugin once ingame if you wish to have infinite cash.

public const float OFF_THE_MAP[3] = { 16383.0, 16383.0, -16383.0 };

ConVar CvarNoRoundStart;
ConVar CvarDisableThink;
ConVar CvarInfiniteCash;
ConVar CvarNoSpecialZombieSpawn;
//ConVar CvarEnablePrivatePlugins;
ConVar CvarMaxBotsForKillfeed;
ConVar CvarXpMultiplier;

bool Toggle_sv_cheats = false;
bool b_MarkForReload = false; //When you wanna reload the plugin on map change...
//#define CompensatePlayers

//#define FastStart

// THESE ARE TO TOGGLE THINGS!


//MOST THINGS ARE HARDCODED TO BLUE AND RED!!!! REASON IS COLLISSION ISSUES WITH BASEBOSS AND OTHER STUFF!
//If you can make it cross team work then be my guest but i seriously cannot see a way to do this without 5x the effort.

//RED: Humans
//BLUE: Enemy zombies

//some zombies are on red.


//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!

/*
	THIS CODE IS COMPRISED OF MULTIPLE CODERS JUST ADDING THEIR THINGS!
	SO HOW THIS CODE WORKS CAN HEAVILY VARY FROM FILE TO FILE!!!
	
	Also keep in mind that i (artvin) started coding here with only half a year of knowledege so you'll see a fuckton of shitcode.
	
	Current coders that in anyway actively helped, in order of how much:
	
	Batfoxkid
	Artvin
	Mikusch
	Suza
	Alex
	Spookmaster
	
	Alot of code is borrowed/just takes from other plugins i or friends made, often with permission,
	rarely without cus i couldnt contact the person or it was just open sourcecode, credited anyways when i did that.
*/

//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!
//ATTENTION PLEASE!!!!!!!!!

#define FAR_FUTURE	100000000.0
#define MAXENTITIES	2048
#define MAXTF2PLAYERS	36

#define CHAR_FULL	"█"
#define CHAR_PARTFULL	"▓"
#define CHAR_PARTEMPTY	"▒"
#define CHAR_EMPTY	"░"

#define CONFIG_CFG	CONFIG ... "/%s.cfg"

#define DISPENSER_BLUEPRINT	"models/buildables/dispenser_blueprint.mdl"
#define SENTRY_BLUEPRINT	"models/buildables/sentry1_blueprint.mdl"

native any FuncToVal(Function bruh);
/*
enum
{
	EF_BONEMERGE			= 0x001,	// Performs bone merge on client side
	EF_BRIGHTLIGHT 			= 0x002,	// DLIGHT centered at entity origin
	EF_DIMLIGHT 			= 0x004,	// player flashlight
	EF_NOINTERP				= 0x008,	// don't interpolate the next frame
	EF_NOSHADOW				= 0x010,	// Don't cast no shadow
	EF_NODRAW				= 0x020,	// don't draw entity
	EF_NORECEIVESHADOW		= 0x040,	// Don't receive no shadow
	EF_BONEMERGE_FASTCULL	= 0x080,	// For use with EF_BONEMERGE. If this is set, then it places this ent's origin at its
										// parent and uses the parent's bbox + the max extents of the aiment.
										// Otherwise, it sets up the parent's bones every frame to figure out where to place
										// the aiment, which is inefficient because it'll setup the parent's bones even if
										// the parent is not in the PVS.
	EF_ITEM_BLINK			= 0x100,	// blink an item so that the user notices it.
	EF_PARENT_ANIMATES		= 0x200,	// always assume that the parent entity is animating
	EF_MAX_BITS = 10
};*/

enum
{
	Ammo_Metal = 3,		// 3	Metal
	Ammo_Jar = 6,		// 6	Jar
	Ammo_Pistol,		// 7	Pistol
	Ammo_Rocket,		// 8	Rocket Launchers
	Ammo_Flame,		// 9	Flamethrowers
	Ammo_Flare,		// 10	Flare Guns
	Ammo_Grenade,		// 11	Grenade Launchers
	Ammo_Sticky,		// 12	Stickybomb Launchers
	Ammo_Minigun,		// 13	Miniguns
	Ammo_Bolt,		// 14	Resuce Ranger, Cursader's Crossbow
	Ammo_Syringe,		// 15	Needle Guns
	Ammo_Sniper,		// 16	Sniper Rifles
	Ammo_Arrow,		// 17	Huntsman
	Ammo_SMG,		// 18	SMGs
	Ammo_Revolver,		// 19	Revolverss
	Ammo_Shotgun,		// 20	Shotgun, Shortstop, Force-A-Nature, Soda Popper
	Ammo_Heal,		// 21 Healing Ammunition
	Ammo_Medigun,		// 22 Medigun Ammunition
	Ammo_Laser,		// 23 Laser Battery
	Ammo_Hand_Grenade,		// 24 Hand Grenade types
	Ammo_Potion_Supply,		// 25 Drink Types
	Ammo_MAX
};

Handle SyncHud_Notifaction;
Handle SyncHud_WandMana;

ConVar zr_spawnprotectiontime;
//ConVar tf_bot_quota;

bool DoingLagCompensation;

float f_BotDelayShow[MAXTF2PLAYERS];
float f_OneShotProtectionTimer[MAXTF2PLAYERS];
int Dont_Crouch[MAXENTITIES]={0, ...};

int CurrentPlayers;

ConVar cvarTimeScale;
ConVar CvarMpSolidObjects; //mp_solidobjects 
ConVar CvarTfMMMode; // tf_mm_servermode
ConVar sv_cheats;
bool b_PhasesThroughBuildingsCurrently[MAXTF2PLAYERS];
Cookie CookieXP;
Cookie Niko_Cookies;

bool b_LagCompNPC_No_Layers;
bool b_LagCompNPC_AwayEnemies;
bool b_LagCompNPC_ExtendBoundingBox;
bool b_LagCompNPC_BlockInteral;

bool b_LagCompAlliedPlayers; //Make sure this actually compensates allies.

bool i_HasBeenBackstabbed[MAXENTITIES];
bool i_HasBeenHeadShotted[MAXENTITIES];

bool thirdperson[MAXTF2PLAYERS];
bool b_DoNotUnStuck[MAXENTITIES];

float f_ShowHudDelayForServerMessage[MAXTF2PLAYERS];
//float Check_Standstill_Delay[MAXTF2PLAYERS];
//bool Check_Standstill_Applied[MAXTF2PLAYERS];

float f_StuckTextChatNotif[MAXTF2PLAYERS];

float max_mana[MAXTF2PLAYERS];
float mana_regen[MAXTF2PLAYERS];
bool has_mage_weapon[MAXTF2PLAYERS];

int i_WhatLevelForHudIsThisClientAt[MAXTF2PLAYERS];

//bool Wand_Fired;

TFClassType CurrentClass[MAXTF2PLAYERS];
TFClassType WeaponClass[MAXTF2PLAYERS];
int CurrentAmmo[MAXTF2PLAYERS][Ammo_MAX];
int i_SemiAutoWeapon[MAXENTITIES];
int i_SemiAutoWeapon_AmmoCount[MAXENTITIES]; //idk like 10 slots lol
bool i_WeaponCannotHeadshot[MAXENTITIES];
float i_WeaponDamageFalloff[MAXENTITIES];

#define MAXSTICKYCOUNTTONPC 12
const int i_MaxcountSticky = MAXSTICKYCOUNTTONPC;
int i_StickyToNpcCount[MAXENTITIES][MAXSTICKYCOUNTTONPC]; //12 should be the max amount of stickies.
int i_StickyAccessoryLogicItem[MAXTF2PLAYERS]; //Item for stickies like "no bounce"

float f_SemiAutoStats_FireRate[MAXENTITIES];
int i_SemiAutoStats_MaxAmmo[MAXENTITIES];
float f_SemiAutoStats_ReloadTime[MAXENTITIES];

float f_MedigunChargeSave[MAXTF2PLAYERS][4];

float Increaced_Sentry_damage_Low[MAXENTITIES];
float Increaced_Sentry_damage_High[MAXENTITIES];
float Resistance_for_building_Low[MAXENTITIES];


float Increaced_Overall_damage_Low[MAXENTITIES];
float Resistance_Overall_Low[MAXENTITIES];
float f_EmpowerStateSelf[MAXENTITIES];
float f_EmpowerStateOther[MAXENTITIES];

//This is for going through things via lag comp or other reasons to teleport things away.
//bool Do_Not_Regen_Mana[MAXTF2PLAYERS];;
bool i_ClientHasCustomGearEquipped[MAXTF2PLAYERS]={false, ...};
	
int Animation_Setting[MAXTF2PLAYERS];
int Animation_Index[MAXTF2PLAYERS];
bool b_IsPlayerNiko[MAXTF2PLAYERS];

float delay_hud[MAXTF2PLAYERS];
float f_DelayBuildNotif[MAXTF2PLAYERS];
float f_ClientInvul[MAXTF2PLAYERS]; //Extra ontop of uber if they somehow lose it to some god damn reason.

int Current_Mana[MAXTF2PLAYERS];
float Mana_Regen_Delay[MAXTF2PLAYERS];
float Mana_Hud_Delay[MAXTF2PLAYERS];

bool b_NpcHasDied[MAXENTITIES]={true, ...};
const int i_MaxcountNpc = ZR_MAX_NPCS;
int i_ObjectsNpcs[ZR_MAX_NPCS];

const int i_Maxcount_Apply_Lagcompensation = ZR_MAX_LAG_COMP;
int i_Objects_Apply_Lagcompensation[ZR_MAX_LAG_COMP];
bool b_DoNotIgnoreDuringLagCompAlly[MAXENTITIES]={false, ...};

bool b_IsAlliedNpc[MAXENTITIES]={false, ...};
const int i_MaxcountNpc_Allied = ZR_MAX_NPCS_ALLIED;
int i_ObjectsNpcs_Allied[ZR_MAX_NPCS_ALLIED];

const int i_MaxcountBuilding = ZR_MAX_BUILDINGS;
int i_ObjectsBuilding[ZR_MAX_BUILDINGS];
bool i_IsABuilding[MAXENTITIES];

const int i_MaxcountTraps = ZR_MAX_TRAPS;
int i_ObjectsTraps[ZR_MAX_TRAPS];

const int i_MaxcountBreakable = ZR_MAX_BREAKBLES;
int i_ObjectsBreakable[ZR_MAX_BREAKBLES];

//We kinda check these almost 24/7, its better to put them into an array!
const int i_MaxcountSpawners = ZR_MAX_SPAWNERS;
int i_ObjectsSpawners[ZR_MAX_SPAWNERS];


bool b_IsAGib[MAXENTITIES];
int i_NpcInternalId[MAXENTITIES];
bool b_IsCamoNPC[MAXENTITIES];

float f_TimeUntillNormalHeal[MAXENTITIES]={0.0, ...};
bool f_ClientServerShowMessages[MAXTF2PLAYERS];

//Needs to be global.
int i_HowManyBombsOnThisEntity[MAXENTITIES][MAXTF2PLAYERS];
float f_TargetWasBlitzedByRiotShield[MAXENTITIES][MAXENTITIES];
float f_ChargeTerroriserSniper[MAXENTITIES];
bool b_npcspawnprotection[MAXENTITIES];
float f_LowTeslarDebuff[MAXENTITIES];
float f_HighTeslarDebuff[MAXENTITIES];
float f_VeryLowIceDebuff[MAXENTITIES];
float f_LowIceDebuff[MAXENTITIES];
float f_HighIceDebuff[MAXENTITIES];
bool b_Frozen[MAXENTITIES];
float f_TankGrabbedStandStill[MAXENTITIES];
float f_StunExtraGametimeDuration[MAXENTITIES];
bool b_PernellBuff[MAXENTITIES];
float f_MaimDebuff[MAXENTITIES];
float f_CrippleDebuff[MAXENTITIES];
int BleedAmountCountStack[MAXENTITIES];
int g_particleCritText;
int LastHitId[MAXENTITIES];
int DamageBits[MAXENTITIES];
float Damage[MAXENTITIES];
int LastHitWeaponRef[MAXENTITIES];
Handle IgniteTimer[MAXENTITIES];
int IgniteFor[MAXENTITIES];
int IgniteId[MAXENTITIES];
int IgniteRef[MAXENTITIES];

bool b_StickyIsSticking[MAXENTITIES];

RenderMode i_EntityRenderMode[MAXENTITIES]={RENDER_NORMAL, ...};
int i_EntityRenderColour1[MAXENTITIES]={255, ...};
int i_EntityRenderColour2[MAXENTITIES]={255, ...};
int i_EntityRenderColour3[MAXENTITIES]={255, ...};
int i_EntityRenderColour4[MAXENTITIES]={255, ...};
bool i_EntityRenderOverride[MAXENTITIES]={false, ...};

//6 wearables
int i_Wearable[MAXENTITIES][6];

float f_WidowsWineDebuff[MAXENTITIES];
float f_WidowsWineDebuffPlayerCooldown[MAXTF2PLAYERS];

int i_Hex_WeaponUsesTheseAbilities[MAXENTITIES];

#define ABILITY_NONE                 0          	//Nothing special.

#define ABILITY_M1				(1 << 1) 
#define ABILITY_M2				(1 << 2) 
#define ABILITY_R				(1 << 3) 	

#define FL_WIDOWS_WINE_DURATION 4.0


int i_HexCustomDamageTypes[MAXENTITIES]; //We use this to avoid using tf2's damage types in cases we dont want to, i.e. too many used, we cant use more. For like white stuff and all, this is just extra on what we already have.

//Use what already exists in tf2 please, only add stuff here if it needs extra spacing like ice damage and so on
//I dont want to use DMG_SHOCK for example due to its extra ugly effect thats annoying!

#define ZR_DAMAGE_NONE                	0          	//Nothing special.
#define ZR_DAMAGE_ICE					(1 << 1)
#define ZR_DAMAGE_LASER_NO_BLAST		(1 << 2)

//ATTRIBUTE ARRAY SUBTITIUTE
//ATTRIBUTE ARRAY SUBTITIUTE
//ATTRIBUTE ARRAY SUBTITIUTE
int Armor_Level[MAXPLAYERS + 1]={0, ...}; 				//701
int Jesus_Blessing[MAXPLAYERS + 1]={0, ...}; 				//777
float Panic_Attack[MAXENTITIES]={0.0, ...};				//651
float Mana_Regen_Level[MAXPLAYERS]={0.0, ...};				//405
int i_HeadshotAffinity[MAXPLAYERS + 1]={0, ...}; 				//785
int i_SurvivalKnifeCount[MAXENTITIES]={0, ...}; 				//33
int i_BarbariansMind[MAXPLAYERS + 1]={0, ...}; 				//830
int i_SoftShoes[MAXPLAYERS + 1]={0, ...}; 				//527
int i_GlitchedGun[MAXENTITIES]={0, ...}; 				//731
int i_AresenalTrap[MAXENTITIES]={0, ...}; 				//719
int i_ArsenalBombImplanter[MAXENTITIES]={0, ...}; 				//544
int i_NoBonusRange[MAXENTITIES]={0, ...}; 				//410
int i_BuffBannerPassively[MAXENTITIES]={0, ...}; 				//786
int i_BadHealthRegen[MAXENTITIES]={0, ...}; 				//805

int i_LowTeslarStaff[MAXENTITIES]={0, ...}; 				//3002
int i_HighTeslarStaff[MAXENTITIES]={0, ...}; 				//3000
int b_PhaseThroughBuildingsPerma[MAXTF2PLAYERS];
bool b_FaceStabber[MAXTF2PLAYERS];
bool b_IsCannibal[MAXTF2PLAYERS];
bool b_HasGlassBuilder[MAXTF2PLAYERS];
bool b_LeftForDead[MAXTF2PLAYERS];

Function EntityFuncAttack[MAXENTITIES];
Function EntityFuncAttack2[MAXENTITIES];
Function EntityFuncAttack3[MAXENTITIES];
Function EntityFuncReload4[MAXENTITIES];
//Function EntityFuncReloadSingular5[MAXENTITIES];

int i_assist_heal_player[MAXTF2PLAYERS];
float f_assist_heal_player_time[MAXTF2PLAYERS];
int LimitNpcs;

//ATTRIBUTE ARRAY SUBTITIUTE
//ATTRIBUTE ARRAY SUBTITIUTE
//ATTRIBUTE ARRAY SUBTITIUTE

bool b_Is_Npc_Projectile[MAXENTITIES];
bool b_Is_Player_Projectile[MAXENTITIES];
bool b_Is_Player_Projectile_Through_Npc[MAXENTITIES];
bool b_Is_Blue_Npc[MAXENTITIES];
bool b_IsInUpdateGroundConstraintLogic;

int i_ExplosiveProjectileHexArray[MAXENTITIES];
int h_NpcCollissionHookType[MAXENTITIES];
#define EP_GENERIC                  		0          					// Nothing special.
#define EP_NO_KNOCKBACK              		(1 << 0)   					// No knockback
#define EP_DEALS_SLASH_DAMAGE              	(1 << 1)   					// Slash Damage (For no npc scaling, or ignoring resistances.)
#define EP_DEALS_CLUB_DAMAGE              	(1 << 2)   					// To deal melee damage.



bool b_Map_BaseBoss_No_Layers[MAXENTITIES];
float f_TempCooldownForVisualManaPotions[MAXPLAYERS+1];
float f_DelayLookingAtHud[MAXPLAYERS+1];
bool b_EntityIsArrow[MAXENTITIES];
bool b_EntityIsWandProjectile[MAXENTITIES];
int i_WandIdNumber[MAXENTITIES]; //This is to see what wand is even used. so it does its own logic and so on.
float f_WandDamage[MAXENTITIES]; //
int i_WandOwner[MAXENTITIES]; //
int i_WandWeapon[MAXENTITIES]; //
int i_WandParticle[MAXENTITIES]; //Only one allowed, dont use more. ever. ever ever. lag max otherwise.

int g_iLaserMaterial_Trace, g_iHaloMaterial_Trace;


#define EXPLOSION_AOE_DAMAGE_FALLOFF 1.7
#define LASER_AOE_DAMAGE_FALLOFF 1.5
#define EXPLOSION_RADIUS 150.0
#define EXPLOSION_RANGE_FALLOFF 0.4

//#define DO_NOT_COMPENSATE_THESE 211, 442, 588, 30665, 264, 939, 880, 1123, 208, 1178, 594, 954, 1127, 327, 1153, 425, 1081, 740, 130, 595, 207, 351, 1083, 58, 528, 1151, 996, 1092, 752, 308, 1007, 1004, 1005, 206, 305

bool b_Do_Not_Compensate[MAXENTITIES];
bool b_Only_Compensate_CollisionBox[MAXENTITIES];
bool b_Only_Compensate_AwayPlayers[MAXENTITIES];
bool b_ExtendBoundingBox[MAXENTITIES];
bool b_BlockLagCompInternal[MAXENTITIES];
bool b_Dont_Move_Building[MAXENTITIES];
bool b_Dont_Move_Allied_Npc[MAXENTITIES];
int b_BoundingBoxVariant[MAXENTITIES];
bool b_IsAloneOnServer = false;
bool b_ThisEntityIgnored[MAXENTITIES];
bool b_ThisEntityIgnoredEntirelyFromAllCollisions[MAXENTITIES];
bool b_ThisEntityIsAProjectileForUpdateContraints[MAXENTITIES];

bool b_IsPlayerABot[MAXPLAYERS+1];
float f_CooldownForHurtHud[MAXPLAYERS];	
//Otherwise we get kicks if there is too much hurting going on.

Address g_hSDKStartLagCompAddress;
Address g_hSDKEndLagCompAddress;
bool g_GottenAddressesForLagComp;

//Handle g_hSDKIsClimbingOrJumping;
//SDKCalls
Handle g_hUpdateCollisionBox;
//Handle g_hMyNextBotPointer;
//Handle g_hGetLocomotionInterface;
//Handle g_hGetIntentionInterface;
//Handle g_hGetBodyInterface;
//Handle g_hGetVisionInterface;
//Handle g_hGetPrimaryKnownThreat;
//Handle g_hAddKnownEntity;
//Handle g_hGetKnownEntity;
//Handle g_hGetKnown;
//Handle g_hUpdatePosition;
//Handle g_hUpdateVisibilityStatus;
//Handle g_hRun;
//Handle g_hApproach;
//Handle g_hFaceTowards;
//Handle g_hGetVelocity;
//Handle g_hSetVelocity;
//Handle g_hStudioFrameAdvance;
//Handle g_hJump;
//Handle g_hSDKIsOnGround;
//DynamicHook g_hAlwaysTransmit;
// Handle g_hJumpAcrossGap;
//Handle g_hDispatchAnimEvents;
//Handle g_hGetMaxAcceleration;
//Handle g_hGetGroundSpeed;
//Handle g_hGetVectors;
//Handle g_hGetGroundMotionVector;
//Handle g_hLookupPoseParameter;
//Handle g_hSetPoseParameter;
//Handle g_hGetPoseParameter;
Handle g_hLookupActivity;
Handle g_hSDKWorldSpaceCenter;
//Handle g_hStudio_FindAttachment;
//Handle g_hGetAttachment;
//Handle g_hAddGesture;
//Handle g_hRemoveGesture;
//Handle g_hRestartGesture;
//Handle g_hIsPlayingGesture;
//Handle g_hFindBodygroupByName;
//Handle g_hSetBodyGroup;
//Handle g_hSelectWeightedSequence;
Handle g_hResetSequenceInfo;

//Death
//Handle g_hNextBotCombatCharacter_Event_Killed;
//Handle g_hCBaseCombatCharacter_Event_Killed;

//PluginBot SDKCalls
//Handle g_hGetEntity;
//Handle g_hGetBot;

//DHooks
//Handle g_hGetCurrencyValue;
//Handle g_hEvent_Killed;
//Handle g_hEvent_Ragdoll;
//Handle g_hHandleAnimEvent;
//Handle g_hGetFrictionSideways;
//Handle g_hGetStepHeight;
//Handle g_hGetGravity;
//Handle g_hGetRunSpeed;
//Handle g_hGetGroundNormal;
//Handle g_hShouldCollideWithAlly;
//Handle g_hShouldCollideWithAllyInvince;
//Handle g_hShouldCollideWithAllyEnemy;
//Handle g_hShouldCollideWithAllyEnemyIngoreBuilding;
//Handle g_hGetSolidMask;
//Handle g_hStartActivity;
//Handle g_hGetActivity;
//Handle g_hIsActivity;
//Handle g_hGetHullWidth;
//Handle g_hGetHullHeight;
//Handle g_hGetStandHullHeight;
//Handle g_hGetHullWidthGiant;
//Handle g_hGetHullHeightGiant;
//Handle g_hGetStandHullHeightGiant;

DynamicHook g_DHookRocketExplode; //from mikusch but edited
DynamicHook g_DHookMedigunPrimary; 

Handle g_hSDKMakeCarriedObjectDispenser;
Handle g_hSDKMakeCarriedObjectSentry;
Handle gH_BotAddCommand = INVALID_HANDLE;

int CurrentGibCount = 0;
bool b_LimitedGibGiveMoreHealth[MAXENTITIES];
//GLOBAL npc things

float played_headshotsound_already [MAXTF2PLAYERS];

int played_headshotsound_already_Case [MAXTF2PLAYERS];
int played_headshotsound_already_Pitch [MAXTF2PLAYERS];

float f_IsThisExplosiveHitscan[MAXENTITIES];
float f_CustomGrenadeDamage[MAXENTITIES];

float f_TraceAttackWasTriggeredSameFrame[MAXENTITIES];

enum
{
	STEPTYPE_NORMAL = 1,	
	STEPTYPE_COMBINE = 2,	
	STEPTYPE_PANZER = 3,
	STEPTYPE_COMBINE_METRO = 4,
	STEPTYPE_TANK = 5,
	STEPTYPE_ROBOT = 6
}

enum
{
	STEPSOUND_NORMAL = 1,	
	STEPSOUND_GIANT = 2,	
}

enum
{
	BLEEDTYPE_NORMAL = 1,	
	BLEEDTYPE_METAL = 2,	
	BLEEDTYPE_RUBBER = 3,	
	BLEEDTYPE_XENO = 4,
	BLEEDTYPE_SKELETON = 5
}

//#define COMBINE_CUSTOM_MODEL "models/zombie_riot/combine_attachment_police_59.mdl"

//This model is used to do custom models for npcs, mainly so we can make cool animations without bloating downloads
#define COMBINE_CUSTOM_MODEL "models/zombie_riot/combine_attachment_police_175.mdl"

#define DEFAULT_UPDATE_DELAY_FLOAT 0.02 //Make it 0 for now

#define DEFAULT_HURTDELAY 0.35 //Make it 0 for now


#define RAD2DEG(%1) ((%1) * (180.0 / FLOAT_PI))
#define DEG2RAD(%1) ((%1) * FLOAT_PI / 180.0)

#define	SHAKE_START					0			// Starts the screen shake for all players within the radius.
#define	SHAKE_STOP					1			// Stops the screen shake for all players within the radius.
#define	SHAKE_AMPLITUDE				2			// Modifies the amplitude of an active screen shake for all players within the radius.
#define	SHAKE_FREQUENCY				3			// Modifies the frequency of an active screen shake for all players within the radius.
#define	SHAKE_START_RUMBLEONLY		4			// Starts a shake effect that only rumbles the controller, no screen effect.
#define	SHAKE_START_NORUMBLE		5			// Starts a shake that does NOT rumble the controller.

#define GORE_ABDOMEN	  (1 << 0)
#define GORE_FOREARMLEFT  (1 << 1)
#define GORE_HANDRIGHT	(1 << 2)
#define GORE_FOREARMRIGHT (1 << 3)
#define GORE_HEAD		 (1 << 4)
#define GORE_HEADLEFT	 (1 << 5)
#define GORE_HEADRIGHT	(1 << 6)
#define GORE_UPARMLEFT	(1 << 7)
#define GORE_UPARMRIGHT   (1 << 8)
#define GORE_HANDLEFT	 (1 << 9)

#define MAXENTITIES	2048

//I put these here so we can change them on fly if we need to, cus zombies can be really loud, or quiet.

#define NORMAL_ZOMBIE_SOUNDLEVEL	 80
#define NORMAL_ZOMBIE_VOLUME	 0.9

#define BOSS_ZOMBIE_SOUNDLEVEL	 90
#define BOSS_ZOMBIE_VOLUME	 1.0

#define RAIDBOSS_ZOMBIE_SOUNDLEVEL	 95
#define RAIDBOSSBOSS_ZOMBIE_VOLUME	 1.0

#define ARROW_TRAIL "effects/arrowtrail_blu.vmt"
#define ARROW_TRAIL_RED "effects/arrowtrail_red.vmt"

char g_ArrowHitSoundSuccess[][] = {
	"weapons/fx/rics/arrow_impact_flesh.wav",
	"weapons/fx/rics/arrow_impact_flesh2.wav",
	"weapons/fx/rics/arrow_impact_flesh3.wav",
	"weapons/fx/rics/arrow_impact_flesh4.wav",
};

char g_ArrowHitSoundMiss[][] = {
	"weapons/fx/rics/arrow_impact_concrete.wav",
	"weapons/fx/rics/arrow_impact_concrete2.wav",
	"weapons/fx/rics/arrow_impact_concrete4.wav",
};

char g_GibSound[][] = {
	"physics/flesh/flesh_squishy_impact_hard1.wav",
	"physics/flesh/flesh_squishy_impact_hard2.wav",
	"physics/flesh/flesh_squishy_impact_hard3.wav",
	"physics/flesh/flesh_squishy_impact_hard4.wav",
	"physics/flesh/flesh_bloody_break.wav",
};
char g_GibEating[][] = {
	"physics/flesh/flesh_squishy_impact_hard1.wav",
	"physics/flesh/flesh_squishy_impact_hard2.wav",
	"physics/flesh/flesh_squishy_impact_hard3.wav",
	"physics/flesh/flesh_squishy_impact_hard4.wav",
};

char g_GibSoundMetal[][] = {
	"ui/item_metal_pot_drop.wav",
	"ui/item_metal_scrap_drop.wav",
	"ui/item_metal_scrap_pickup.wav",
	"ui/item_metal_scrap_pickup.wav",
	"ui/item_metal_weapon_drop.wav",
};

char g_CombineSoldierStepSound[][] = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav",
};

char g_CombineMetroStepSound[][] = {
	"npc/metropolice/gear1.wav",
	"npc/metropolice/gear2.wav",
	"npc/metropolice/gear3.wav",
	"npc/metropolice/gear4.wav",
	"npc/metropolice/gear5.wav",
	"npc/metropolice/gear6.wav",
};

char g_PanzerStepSound[][] = {
	"mvm/giant_common/giant_common_step_01.wav",
	"mvm/giant_common/giant_common_step_02.wav",
	"mvm/giant_common/giant_common_step_03.wav",
	"mvm/giant_common/giant_common_step_04.wav",
	"mvm/giant_common/giant_common_step_05.wav",
	"mvm/giant_common/giant_common_step_06.wav",
	"mvm/giant_common/giant_common_step_07.wav",
	"mvm/giant_common/giant_common_step_08.wav",
};

char g_RobotStepSound[][] = {
	"mvm/player/footsteps/robostep_01.wav",
	"mvm/player/footsteps/robostep_02.wav",
	"mvm/player/footsteps/robostep_03.wav",
	"mvm/player/footsteps/robostep_04.wav",
	"mvm/player/footsteps/robostep_05.wav",
	"mvm/player/footsteps/robostep_06.wav",
	"mvm/player/footsteps/robostep_07.wav",
	"mvm/player/footsteps/robostep_08.wav",
	"mvm/player/footsteps/robostep_09.wav",
	"mvm/player/footsteps/robostep_10.wav",
	"mvm/player/footsteps/robostep_11.wav",
	"mvm/player/footsteps/robostep_12.wav",
	"mvm/player/footsteps/robostep_13.wav",
	"mvm/player/footsteps/robostep_14.wav",
	"mvm/player/footsteps/robostep_15.wav",
	"mvm/player/footsteps/robostep_16.wav",
	"mvm/player/footsteps/robostep_17.wav",
	"mvm/player/footsteps/robostep_18.wav",

};

char g_TankStepSound[][] = {
	"infected_riot/tank/tank_walk_1.mp3",
};

float f_ArrowDamage[MAXENTITIES];
int f_ArrowTrailParticle[MAXENTITIES]={INVALID_ENT_REFERENCE, ...};

//Arrays for npcs!
int i_NoEntityFoundCount[MAXENTITIES]={0, ...};
float f3_CustomMinMaxBoundingBox[MAXENTITIES][3];
bool b_DissapearOnDeath[MAXENTITIES];
bool b_IsGiant[MAXENTITIES];
bool b_Pathing[MAXENTITIES];
bool b_Jumping[MAXENTITIES];
bool b_AllowBackWalking[MAXENTITIES];
float fl_JumpStartTime[MAXENTITIES];
float fl_JumpCooldown[MAXENTITIES];
float fl_NextThinkTime[MAXENTITIES];
float fl_NextRunTime[MAXENTITIES];
float fl_NextMeleeAttack[MAXENTITIES];
float fl_Speed[MAXENTITIES];
int i_Target[MAXENTITIES];
float fl_GetClosestTargetTime[MAXENTITIES];
float fl_GetClosestTargetNoResetTime[MAXENTITIES];
float fl_NextHurtSound[MAXENTITIES];
float fl_HeadshotCooldown[MAXENTITIES];
bool b_CantCollidie[MAXENTITIES];
bool b_CantCollidieAlly[MAXENTITIES];
bool b_BuildingIsStacked[MAXENTITIES];
bool b_bBuildingIsPlaced[MAXENTITIES];
bool b_XenoInfectedSpecialHurt[MAXENTITIES];
float fl_XenoInfectedSpecialHurtTime[MAXENTITIES];
bool b_DoGibThisNpc[MAXENTITIES];

int i_SpawnProtectionEntity[MAXENTITIES]={-1, ...};
float f3_VecPunchForce[MAXENTITIES][3];
float fl_NextDelayTime[MAXENTITIES];
float fl_NextIdleSound[MAXENTITIES];
float fl_AttackHappensMinimum[MAXENTITIES];
float fl_AttackHappensMaximum[MAXENTITIES];
bool b_AttackHappenswillhappen[MAXENTITIES];
bool b_thisNpcIsABoss[MAXENTITIES];
bool b_StaticNPC[MAXENTITIES];
float f3_VecTeleportBackSave[MAXENTITIES][3];
float f3_VecTeleportBackSaveJump[MAXENTITIES][3];
bool b_NPCVelocityCancel[MAXENTITIES];
float fl_DoSpawnGesture[MAXENTITIES];
bool b_isWalking[MAXENTITIES];
int i_StepNoiseType[MAXENTITIES];
int i_NpcStepVariation[MAXENTITIES];
int i_BleedType[MAXENTITIES];
int i_State[MAXENTITIES];
bool b_movedelay[MAXENTITIES];
float fl_NextRangedAttack[MAXENTITIES];
int i_AttacksTillReload[MAXENTITIES];
bool b_Gunout[MAXENTITIES];
float fl_ReloadDelay[MAXENTITIES];
float fl_InJump[MAXENTITIES];
float fl_DoingAnimation[MAXENTITIES];
float fl_NextRangedBarrage_Spam[MAXENTITIES];
float fl_NextRangedBarrage_Singular[MAXENTITIES];
bool b_NextRangedBarrage_OnGoing[MAXENTITIES];
float fl_NextTeleport[MAXENTITIES];
bool b_Anger[MAXENTITIES];
float fl_NextRangedSpecialAttack[MAXENTITIES];
bool b_RangedSpecialOn[MAXENTITIES];
float fl_RangedSpecialDelay[MAXENTITIES];
float fl_movedelay[MAXENTITIES];
float fl_NextChargeSpecialAttack[MAXENTITIES];
float fl_AngerDelay[MAXENTITIES];
bool b_FUCKYOU[MAXENTITIES];
bool b_FUCKYOU_move_anim[MAXENTITIES];
bool b_healing[MAXENTITIES];
bool b_new_target[MAXENTITIES];
float fl_ReloadIn[MAXENTITIES];
int i_TimesSummoned[MAXENTITIES];
float fl_AttackHappens_2[MAXENTITIES];
float fl_Charge_delay[MAXENTITIES];
float fl_Charge_Duration[MAXENTITIES];
bool b_movedelay_gun[MAXENTITIES];
bool b_Half_Life_Regen[MAXENTITIES];
float fl_Dead_Ringer_Invis[MAXENTITIES];
float fl_Dead_Ringer[MAXENTITIES];
bool b_Dead_Ringer_Invis_bool[MAXENTITIES];
int i_AttacksTillMegahit[MAXENTITIES];

float fl_NextFlameSound[MAXENTITIES];
float fl_FlamerActive[MAXENTITIES];
bool b_DoSpawnGesture[MAXENTITIES];
bool b_LostHalfHealth[MAXENTITIES];
bool b_LostHalfHealthAnim[MAXENTITIES];
bool b_DuringHighFlight[MAXENTITIES];
bool b_DuringHook[MAXENTITIES];
bool b_GrabbedSomeone[MAXENTITIES];
bool b_UseDefaultAnim[MAXENTITIES];
bool b_FlamerToggled[MAXENTITIES];
float fl_WaveScale[MAXENTITIES];
float fl_StandStill[MAXENTITIES];
float fl_GrappleCooldown[MAXENTITIES];
float fl_HookDamageTaken[MAXENTITIES];

bool b_PlayHurtAnimation[MAXENTITIES];
bool b_follow[MAXENTITIES];
bool b_movedelay_walk[MAXENTITIES];
bool b_movedelay_run[MAXENTITIES];
bool b_IsFriendly[MAXENTITIES];
bool b_stand_still[MAXENTITIES];
bool b_Reloaded[MAXENTITIES];
float fl_Following_Master_Now[MAXENTITIES];
float fl_DoingSpecial[MAXENTITIES];
float fl_ComeToMe[MAXENTITIES];
int i_MedkitAnnoyance[MAXENTITIES];
float fl_idle_talk[MAXENTITIES];
float fl_heal_cooldown[MAXENTITIES];
float fl_Hurtie[MAXENTITIES];
float fl_ExtraDamage[MAXENTITIES];
int i_Changed_WalkCycle[MAXENTITIES];
bool b_WasSadAlready[MAXENTITIES];
int i_TargetAlly[MAXENTITIES];
bool b_GetClosestTargetTimeAlly[MAXENTITIES];
float fl_Duration[MAXENTITIES];
int i_OverlordComboAttack[MAXENTITIES];

int i_Activity[MAXENTITIES];
int i_PoseMoveX[MAXENTITIES];
int i_PoseMoveY[MAXENTITIES];
//Arrays for npcs!
bool b_bThisNpcGotDefaultStats_INVERTED[MAXENTITIES];
float b_isGiantWalkCycle[MAXENTITIES];

bool Is_a_Medic[MAXENTITIES]; //THIS WAS INSIDE THE NPCS!
int i_CreditsOnKill[MAXENTITIES];

int i_InSafeZone[MAXENTITIES];
float fl_MeleeArmor[MAXENTITIES];
float fl_RangedArmor[MAXENTITIES];

bool b_ScalesWithWaves[MAXENTITIES]; //THIS WAS INSIDE THE NPCS!

float f_StuckOutOfBoundsCheck[MAXENTITIES];

bool EscapeModeMap;
int g_particleImpactMetal;

char c_HeadPlaceAttachmentGibName[MAXENTITIES][64];

/*
	Above Are Variables/Defines That Are Shared

	Below Are Shared Overrides
*/

#include "shared/stocks_override.sp"
#include "shared/npc_stats.sp"	// NPC Stats is required here due to important methodmap

/*
	Below Are Variables/Defines That Are Per Gamemode
*/

#if defined ZR
#include "zombie_riot/zr_core.sp"
#endif

#if defined RPG
#include "rpg_fortress/rpg_core.sp"
#endif

/*
	Below Are Non-Shared Variables/Defines
*/

#include "shared/attributes.sp"
#include "shared/buildonbuilding.sp"
#include "shared/commands.sp"
#include "shared/configs.sp"
#include "shared/convars.sp"
#include "shared/custom_melee_logic.sp"
#include "shared/dhooks.sp"
#include "shared/events.sp"
#include "shared/npcs.sp"
#include "shared/npc_death_showing.sp"
#include "shared/sdkcalls.sp"
#include "shared/sdkhooks.sp"
#include "shared/stocks.sp"
#include "shared/store.sp"
#include "shared/thirdperson.sp"
#include "shared/viewchanges.sp"
#include "shared/wand_projectile.sp"

#if defined LagCompensation
#include "shared/baseboss_lagcompensation.sp"
#endif

public Plugin myinfo =
{
	name		=	"NPC Gamemode Core",
	author		=	"Artvin & Batfoxkid & Mikusch",
	description	=	"Zombie Riot & RPG Fortress",
	version		=	"manual"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	MarkNativeAsOptional("FuncToVal");
	CreateNative("FuncToVal", Native_FuncToVal);
	CreateNative("ZR_ApplyKillEffects", Native_ApplyKillEffects);
	CreateNative("ZR_GetLevelCount", Native_GetLevelCount);
	
	Thirdperson_PluginLoad();
	
#if defined ZR
	ZR_PluginLoad();
#endif
	
	return APLRes_Success;
}

public void OnPluginStart()
{
	CurrentAmmo[0] = { 1, 1, 1, 200, 1, 1, 1,
	48,
	24,
	200,
	16,
	20,
	32,
	200,
	20,
	190,
	25,
	12,
	100,
	30,
	38,
	200,
	1000,
	100,
	1,
	1};
	
	Commands_PluginStart();
	Events_PluginStart();

	
	RegServerCmd("zr_update_blocked_nav", OnReloadBlockNav, "Reload Nav Blocks");
	RegAdminCmd("sm_play_viewmodel_anim", Command_PlayViewmodelAnim, ADMFLAG_ROOT, "Testing viewmodel animation manually");
	RegConsoleCmd("sm_make_niko", Command_MakeNiko, "Turn This player into niko");
	
	RegAdminCmd("sm_change_collision", Command_ChangeCollision, ADMFLAG_GENERIC, "change all npc's collisions");
	
	RegAdminCmd("sm_toggle_fake_cheats", Command_ToggleCheats, ADMFLAG_GENERIC, "ToggleCheats");
	RegAdminCmd("zr_reload_plugin", Command_ToggleReload, ADMFLAG_GENERIC, "Reload plugin on map change");
	
	RegAdminCmd("sm_test_hud_notif", Command_Hudnotif, ADMFLAG_GENERIC, "Hud Notif");
//	HookEvent("npc_hurt", OnNpcHurt);
	
	sv_cheats = FindConVar("sv_cheats");
	cvarTimeScale = FindConVar("host_timescale");
//	tf_bot_quota = FindConVar("tf_bot_quota");

	CvarMpSolidObjects = FindConVar("tf_solidobjects");
	if(CvarMpSolidObjects)
		CvarMpSolidObjects.Flags &= ~(FCVAR_NOTIFY | FCVAR_REPLICATED);

	CvarTfMMMode = FindConVar("tf_mm_servermode");
	if(CvarTfMMMode)
		CvarTfMMMode.Flags &= ~(FCVAR_NOTIFY | FCVAR_REPLICATED);

	
	FindConVar("tf_bot_count").Flags &= ~FCVAR_NOTIFY;
	FindConVar("sv_tags").Flags &= ~FCVAR_NOTIFY;

	sv_cheats.Flags &= ~FCVAR_NOTIFY;
	
	Niko_Cookies = new Cookie("zr_niko", "Are you a niko", CookieAccess_Protected);
	
	LoadTranslations("zombieriot.phrases");
	LoadTranslations("zombieriot.phrases.zombienames");
	LoadTranslations("zombieriot.phrases.weapons.description");
	LoadTranslations("zombieriot.phrases.weapons");
	LoadTranslations("zombieriot.phrases.bob");
	LoadTranslations("zombieriot.phrases.icons"); 
	LoadTranslations("common.phrases");

	LoadTranslations("rpgfortress.phrases.enemynames");
	
	DHook_Setup();
	SDKCall_Setup();
	ConVar_PluginStart();
	NPC_PluginStart();
	SDKHook_PluginStart();
	Thirdperson_PluginStart();
//	Building_PluginStart();
#if defined LagCompensation
	OnPluginStart_LagComp();
#endif
	NPC_Base_InitGamedata();
	
#if defined ZR
	ZR_PluginStart();
#endif
	//Global Hud for huds.
	SyncHud_Notifaction = CreateHudSynchronizer();
	SyncHud_WandMana = CreateHudSynchronizer();
		
	for(int client=1; client<=MaxClients; client++)
	{
		if(IsClientInGame(client))
		{
			CurrentClass[client] = TF2_GetPlayerClass(client);
		}
	}
}

public Action Timer_Temp(Handle timer)
{
	if(CvarDisableThink.BoolValue)
	{
		float gameTime = GetGameTime() + 1.0;
		for(int i = MaxClients + 1; i < MAXENTITIES; i++)
		{
			view_as<CClotBody>(i).m_flNextDelayTime = gameTime;
		}
	}
	
#if defined ZR
	if(IsValidEntity(EntRefToEntIndex(RaidBossActive)))
	{
		if (RaidModeTime > GetGameTime() && RaidModeTime < GetGameTime() + 60.0)
		{
			PlayTickSound(true, false);
		}
		for(int client=1; client<=MaxClients; client++)
		{
			if(IsClientInGame(client))
			{
				Calculate_And_Display_hp(client, EntRefToEntIndex(RaidBossActive), 0.0, true);
			}
		}
	}
	if (GetWaveSetupCooldown() > GetGameTime() && GetWaveSetupCooldown() < GetGameTime() + 10.0)
	{
		PlayTickSound(false, true);
	}
	NPC_SpawnNext(false, false, false);
#endif
	
	return Plugin_Continue;
}

public void OnPluginEnd()
{
	ConVar_Disable();
	
	for(int i=1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			DHook_UnhookClient(i);
			OnClientDisconnect(i);
		}
	}
	
	char buffer[64];
	for(int i=MAXENTITIES; i>MaxClients; i--)
	{
		if(IsValidEntity(i) && GetEntityClassname(i, buffer, sizeof(buffer)))
		{
			if(!StrContains(buffer, "base_boss"))
				RemoveEntity(i);
		}
	}
	
}

public void OnMapStart()
{
	PrecacheSound("weapons/knife_swing_crit.wav");
	PrecacheSound("weapons/shotgun/shotgun_dbl_fire.wav");
	PrecacheSound("npc/vort/attack_shoot.wav");
	PrecacheSound("npc/strider/fire.wav");
	PrecacheSound("weapons/shotgun/shotgun_fire7.wav");
	PrecacheSound("#items/tf_music_upgrade_machine.wav");
	PrecacheSound("physics/metal/metal_box_impact_bullet1.wav");
	PrecacheSound("misc/halloween/spell_overheal.wav");
	PrecacheSound("weapons/gauss/fire1.wav");
	PrecacheSound("items/powerup_pickup_knockout_melee_hit.wav");
	PrecacheSound("weapons/capper_shoot.wav");

	PrecacheSound("zombiesurvival/headshot1.wav");
	PrecacheSound("zombiesurvival/headshot2.wav");
	PrecacheSound("misc/halloween/clock_tick.wav");
	PrecacheSound("mvm/mvm_bomb_warning.wav");
	PrecacheSound("weapons/jar_explode.wav");
	PrecacheSound("player/crit_hit5.wav");
	PrecacheSound("player/crit_hit4.wav");
	PrecacheSound("player/crit_hit3.wav");
	PrecacheSound("player/crit_hit2.wav");
	PrecacheSound("player/crit_hit.wav");
	
	MapStartResetAll();
	
#if defined ZR
	ZR_MapStart();
#endif
	OnMapStart_NPC_Base();
	SDKHook_MapStart();
	ViewChange_MapStart();
	MapStart_CustomMeleePrecache();
	WandStocks_Map_Precache();
	
	g_iHaloMaterial_Trace = PrecacheModel("materials/sprites/halo01.vmt");
	g_iLaserMaterial_Trace = PrecacheModel("materials/sprites/laserbeam.vmt");
	
	CreateTimer(0.2, Timer_Temp, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void OnMapEnd()
{
#if defined ZR
	Store_RandomizeNPCStore(true);
	OnRoundEnd(null, NULL_STRING, false);
	OnMapEndWaves();
#endif
	ConVar_Disable();
}

public void OnConfigsExecuted()
{
	if(b_MarkForReload)
	{
		ServerCommand("sm plugins reload zombie_riot");
		return;
	}
	RequestFrame(Configs_ConfigsExecuted);
}

public Action OnReloadBlockNav(int args)
{
	UpdateBlockedNavmesh();
	return Plugin_Handled;
}

public Action Command_MakeNiko(int client, int args)
{
	if(b_IsPlayerNiko[client])
	{
		PrintToChat(client,"You are no longer niko, respawn to apply");
		b_IsPlayerNiko[client] = false;
	}
	else
	{
		PrintToChat(client,"You are now niko, respawn to apply");
		b_IsPlayerNiko[client] = true;
	}
	return Plugin_Handled;
}
public Action Command_PlayViewmodelAnim(int client, int args)
{
	//What are you.
	if(args < 1)
    {
        ReplyToCommand(client, "[SM] Usage: sm_play_viewmodel_anim <target> <index>");
        return Plugin_Handled;
    }
    
	static char targetName[MAX_TARGET_LENGTH];
    
	static char pattern[PLATFORM_MAX_PATH];
	GetCmdArg(1, pattern, sizeof(pattern));
	
	char buf[12];
	GetCmdArg(2, buf, sizeof(buf));
	int anim_index = StringToInt(buf); 

	int targets[MAXPLAYERS], matches;
	bool targetNounIsMultiLanguage;
	if((matches=ProcessTargetString(pattern, client, targets, sizeof(targets), 0, targetName, sizeof(targetName), targetNounIsMultiLanguage)) < 1)
	{
		ReplyToTargetError(client, matches);
		return Plugin_Handled;
	}
	
	for(int target; target<matches; target++)
	{
		int viewmodel = GetEntPropEnt(targets[target], Prop_Send, "m_hViewModel");
		if(viewmodel>MaxClients && IsValidEntity(viewmodel)) //For some reason it plays the horn anim again, just set it to idle!
		{
			int animation = anim_index;
			SetEntProp(viewmodel, Prop_Send, "m_nSequence", animation);
		}
	}
	
	return Plugin_Handled;
}

public Action Command_ChangeCollision(int client, int args)
{
	char buf[12];
	GetCmdArg(1, buf, sizeof(buf));
	int Collision = StringToInt(buf); 
	
	for(int entitycount; entitycount<i_MaxcountNpc; entitycount++)
	{
		int baseboss_index = EntRefToEntIndex(i_ObjectsNpcs[entitycount]);
		if (IsValidEntity(baseboss_index) && baseboss_index != 0)
		{
			Change_Npc_Collision(baseboss_index, Collision);
		}
	}
	return Plugin_Handled;
}

public Action Command_ToggleCheats(int client, int args)
{
	if(Toggle_sv_cheats)
	{
		Toggle_sv_cheats = false;
		for(int i=1; i<=MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsFakeClient(i))
			{
				SendConVarValue(i, sv_cheats, "0");
			}
		}	
	}
	else
	{
		Toggle_sv_cheats = true;
		for(int i=1; i<=MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsFakeClient(i))
			{
				SendConVarValue(i, sv_cheats, "1");
			}
		}
	}
	return Plugin_Handled;
}


public Action Command_Hudnotif(int client, int args)
{
	char buf[64];
	GetCmdArg(1, buf, sizeof(buf));
	ShowGameText(client, buf, 0, "%t", "A Miniboss has Spawned..");
	
	return Plugin_Handled;
}

public Action Command_ToggleReload(int client, int args)
{
	if(b_MarkForReload)
	{
		PrintToChat(client, "The plugin WILL NOT reload on map change.");
		b_MarkForReload = false;
	}
	else
	{
		PrintToChat(client, "The plugin WILL reload on map change.");
		b_MarkForReload = true;
	}
	return Plugin_Handled;
}
				
public void OnClientPutInServer(int client)
{
	b_IsPlayerABot[client] = false;
	if(IsFakeClient(client))
	{
		TF2_ChangeClientTeam(client, TFTeam_Blue);
		DHook_HookClient(client);
		b_IsPlayerABot[client] = true;
		return;
	}
	
	DHook_HookClient(client);
	SDKHook_HookClient(client);
	WeaponClass[client] = TFClass_Unknown;
	
	CClotBody npc = view_as<CClotBody>(client);
	npc.m_bThisEntityIgnored = false;
	f_ShowHudDelayForServerMessage[client] = GetGameTime() + 50.0;
	
#if defined ZR
	ZR_ClientPutInServer(client);
#endif
	
	if(AreClientCookiesCached(client)) //Ingore this. This only bugs it out, just force it, who cares.
		OnClientCookiesCached(client);	
	
}

public void OnClientCookiesCached(int client)
{
	char buffer[12];
	
#if defined ZR
	Tutorial_LoadCookies(client);

	CookieScrap.Get(client, buffer, sizeof(buffer));
	Scrap[client] = StringToInt(buffer);
	
	if(Scrap[client] < 0)
	{
		Scrap[client] = 0;
	}
#endif
	
	ThirdPerson_OnClientCookiesCached(client);
	CookieXP.Get(client, buffer, sizeof(buffer));
	XP[client] = StringToInt(buffer);
	Level[client] = XpToLevel(XP[client]);
	
	char buffer_niko[12];
	Niko_Cookies.Get(client, buffer_niko, sizeof(buffer_niko));
	if(StringToInt(buffer_niko) == 1)
	{
	 	b_IsPlayerNiko[client] = true;
	}
	else
	{
		b_IsPlayerNiko[client] = false;
	}
	
	Store_ClientCookiesCached(client);
}

public void OnClientDisconnect(int client)
{
	Store_ClientDisconnect(client);
	
#if defined ZR
	ZR_ClientDisconnect(client);
	
	if(Scrap[client] > -1)
	{
		char buffer[12];
		IntToString(Scrap[client], buffer, sizeof(buffer));
		CookieScrap.Set(client, buffer);
	}
	Scrap[client] = -1;
#endif
	
	WeaponClass[client] = TFClass_Unknown;
	
	if(XP[client] > 0)
	{
		char buffer[12];
		IntToString(XP[client], buffer, sizeof(buffer));
		CookieXP.Set(client, buffer);
		
		int niko_int = 0;
		
		if(b_IsPlayerNiko[client])
			niko_int = 1;
			
		IntToString(niko_int, buffer, sizeof(buffer));
		Niko_Cookies.Set(client, buffer);
	}
	XP[client] = 0;
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if(b_IsPlayerABot[client])
		return Plugin_Continue;
	
#if defined LagCompensation
	OnPlayerRunCmd_Lag_Comp(client, angles, tickcount);
#endif

#if defined ZR
	Escape_PlayerRunCmd(client);
	
	//tutorial stuff.
	Tutorial_MakeClientNotMove(client);
#endif

	if(buttons & IN_ATTACK)
	{
		int entity = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if(entity > MaxClients)
		{
			
#if defined ZR
			f_Actualm_flNextPrimaryAttack[entity] = GetEntPropFloat(entity, Prop_Send, "m_flNextPrimaryAttack");
#endif
			
			bool cancel_attack = false;
			cancel_attack = Attributes_Fire(client, entity);
			
			if(cancel_attack)
			{
				buttons &= ~IN_ATTACK;
				return Plugin_Changed;
			}
		}
	}
	
#if defined ZR
	static bool was_reviving[MAXTF2PLAYERS];
	static int was_reviving_this[MAXTF2PLAYERS];
#endif

	static int holding[MAXTF2PLAYERS];
	if(holding[client])
	{
		if(!(buttons & holding[client]))
			holding[client] = 0;
	}
	else if(buttons & IN_ATTACK2)
	{
		holding[client] = IN_ATTACK2;
		
		#if defined ZR
		b_IgnoreWarningForReloadBuidling[client] = false;
		#endif
		
		int weapon_holding = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if(weapon_holding != -1)
		{
			if(EntityFuncAttack2[weapon_holding] && EntityFuncAttack2[weapon_holding]!=INVALID_FUNCTION)
			{
				bool result = false; //ignore crit.
				int slot = 2;
				Action action;
				Call_StartFunction(null, EntityFuncAttack2[weapon_holding]);
				Call_PushCell(client);
				Call_PushCell(weapon_holding);
				Call_PushCellRef(result);
				Call_PushCell(slot); //This is attack 2 :)
				Call_Finish(action);
			}
			
			#if defined ZR
			char classname[36];
			GetEntityClassname(weapon_holding, classname, sizeof(classname));
			
			if(TF2_GetClassnameSlot(classname) == TFWeaponSlot_Melee)
			{
				if(EntityFuncAttack2[weapon_holding] != MountBuildingToBack && TeutonType[client] == TEUTON_NONE)
				{
					b_IgnoreWarningForReloadBuidling[client] = true;
					Pickup_Building_M2(client, weapon, false);
				}
			}
			#endif
		}
		
		StartPlayerOnlyLagComp(client, true);
		if(InteractKey(client, weapon_holding, false)) //doesnt matter which one
		{
			buttons &= ~IN_ATTACK2;
			EndPlayerOnlyLagComp(client);
			return Plugin_Changed;
		}
		EndPlayerOnlyLagComp(client);
	}
	else if(buttons & IN_RELOAD)
	{
		holding[client] = IN_RELOAD;
		
		#if defined ZR
		if(angles[0] < -70.0)
		{
			int entity = EntRefToEntIndex(Building_Mounted[client]);
			if(IsValidEntity(entity))
			{
				Building_Interact(client, entity, true);
			}
		}
		else
		#endif
		{
			int weapon_holding = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			
			StartPlayerOnlyLagComp(client, true);
			if(InteractKey(client, weapon_holding, true))
			{
				buttons &= ~IN_RELOAD;
				EndPlayerOnlyLagComp(client);
				return Plugin_Changed;
			}
			EndPlayerOnlyLagComp(client);
			
			if(weapon_holding != -1)
			{
				if(EntityFuncAttack3[weapon_holding] && EntityFuncAttack3[weapon_holding]!=INVALID_FUNCTION)
				{
					bool result = false; //ignore crit.
					int slot = 3;
					Action action;
					Call_StartFunction(null, EntityFuncAttack3[weapon_holding]);
					Call_PushCell(client);
					Call_PushCell(weapon_holding);
					Call_PushCellRef(result);
					Call_PushCell(slot);	//This is R :)
					Call_Finish(action);
				}
			}
		}
	}
	else if(buttons & IN_SCORE)
	{
		holding[client] = IN_SCORE;
		
#if defined ZR
		if(dieingstate[client] == 0)
		{
			if(WaitingInQueue[client])
			{
				Queue_Menu(client);
			}
			else
			{
				Store_Menu(client);
			}
		}
#endif
		
#if defined RPG
		FakeClientCommandEx(client, "sm_store");
#endif
	}
	
#if defined ZR
	else if(buttons & IN_ATTACK3)
	{
		holding[client] = IN_ATTACK3;
		
		if(TeutonType[client] == TEUTON_NONE)
		{
			if(IsPlayerAlive(client))
			{
				M3_Abilities(client);
			}
		}
	}
	
	if(holding[client] == IN_RELOAD && dieingstate[client] <= 0 && IsPlayerAlive(client) && TeutonType[client] == TEUTON_NONE)
	{
		int target = GetClientPointVisibleRevive(client);
		if(target > 0 && target <= MaxClients)
		{
			float Healer[3];
			Healer[2] += 62;
			GetEntPropVector(client, Prop_Data, "m_vecAbsOrigin", Healer); 
			float Injured[3];
			Injured[2] += 62;
			GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", Injured);
			if(GetVectorDistance(Healer, Injured) <= 250.0)
			{
				SetEntityMoveType(target, MOVETYPE_NONE);
				was_reviving[client] = true;
				f_DelayLookingAtHud[client] = GetGameTime() + 0.5;
				f_DelayLookingAtHud[target] = GetGameTime() + 0.5;
				PrintCenterText(client, "%t", "Reviving", dieingstate[target]);
				PrintCenterText(target, "%t", "You're Being Revived.", dieingstate[target]);
				was_reviving_this[client] = target;
				f_DisableDyingTimer[target] = GetGameTime() + 0.05;
				if(i_CurrentEquippedPerk[client] == 1)
				{
					dieingstate[target] -= 2;
				}
				else
				{
					dieingstate[target] -= 1;
				}
				
				if(dieingstate[target] <= 0)
				{
					SetEntityMoveType(target, MOVETYPE_WALK);
					RequestFrame(Movetype_walk, target);
					dieingstate[target] = 0;
					
					SetEntPropEnt(target, Prop_Send, "m_hObserverTarget", client);
					f_WasRecentlyRevivedViaNonWave[target] = GetGameTime() + 1.0;
					DHook_RespawnPlayer(target);
					
					float pos[3], ang[3];
					GetEntPropVector(client, Prop_Data, "m_vecOrigin", pos);
					GetEntPropVector(client, Prop_Data, "m_angRotation", ang);
					ang[2] = 0.0;
					SetEntProp(target, Prop_Send, "m_bDucked", true);
					SetEntityFlags(target, GetEntityFlags(target)|FL_DUCKING);
					CClotBody npc = view_as<CClotBody>(client);
					npc.m_bThisEntityIgnored = false;
					TeleportEntity(target, pos, ang, NULL_VECTOR);
					SetEntityCollisionGroup(target, 5);
					PrintCenterText(client, "");
					PrintCenterText(target, "");
					DoOverlay(target, "");
					if(!EscapeMode)
					{
						SetEntityHealth(target, 50);
						RequestFrame(SetHealthAfterRevive, target);
					}	
					else
					{
						SetEntityHealth(target, 150);
						RequestFrame(SetHealthAfterRevive, target);						
					}
					int entity, i;
					while(TF2U_GetWearable(target, entity, i))
					{
						SetEntityRenderMode(entity, RENDER_NORMAL);
						SetEntityRenderColor(entity, 255, 255, 255, 255);
					}
					SetEntityRenderMode(target, RENDER_NORMAL);
					SetEntityRenderColor(target, 255, 255, 255, 255);
				}
			}
			else if (was_reviving[client])
			{
				SetEntityMoveType(target, MOVETYPE_WALK);
				was_reviving[client] = false;
				PrintCenterText(client, "");
				PrintCenterText(target, "");
			}
		}
		else if(target > MaxClients)
		{
			float Healer[3];
			Healer[2] += 62;
			GetEntPropVector(client, Prop_Data, "m_vecAbsOrigin", Healer); 
			float Injured[3];
			Injured[2] += 62;
			GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", Injured);
			if(GetVectorDistance(Healer, Injured) <= 250.0)
			{
				int ticks;
				was_reviving[client] = true;
				f_DelayLookingAtHud[client] = GetGameTime() + 0.5;
				was_reviving_this[client] = target;
				if(i_CurrentEquippedPerk[client] == 1)
				{
					ticks = Citizen_ReviveTicks(target, 2, client);
				}
				else
				{
					ticks = Citizen_ReviveTicks(target, 1, client);
				}
				
				if(ticks <= 0)
				{
					PrintCenterText(client, "");
				}
				else
				{
					PrintCenterText(client, "%t", "Reviving", ticks);
				}
			}
			else if (was_reviving[client])
			{
				was_reviving[client] = false;
				PrintCenterText(client, "");
			}
		}
		else if (was_reviving[client])
		{
			was_reviving[client] = false;
			PrintCenterText(client, "");
			if(IsValidClient(was_reviving_this[client]))
			{
				SetEntityMoveType(was_reviving_this[client], MOVETYPE_WALK);
				PrintCenterText(was_reviving_this[client], "");
			}
		}
	}
	else if (was_reviving[client])
	{
		was_reviving[client] = false;
		PrintCenterText(client, "");
		if(IsValidClient(was_reviving_this[client]))
		{
			SetEntityMoveType(was_reviving_this[client], MOVETYPE_WALK);
			PrintCenterText(was_reviving_this[client], "");
		}
	}
	
//	Building_PlayerRunCmd(client, buttons);
#endif	// ZR

	return Plugin_Continue;
}

public void Movetype_walk(int client)
{
	if(IsValidClient(client))
	{
		SetEntityMoveType(client, MOVETYPE_WALK);
	}
	
}

#if defined ZR
public void OnPlayerRunCmdPost(int client, int buttons, int impulse, const float vel[3], const float angles[3])
{
	SemiAutoWeapon(client, buttons);
	Pets_PlayerRunCmdPost(client, buttons, angles);
	Medikit_healing(client, buttons);
}
#endif

public void Update_Ammo(int  client)
{
	for(int i; i<Ammo_MAX; i++)
	{
		CurrentAmmo[client][i] = GetAmmo(client, i);
	}	
}

public Action TF2_CalcIsAttackCritical(int client, int weapon, char[] classname, bool &result)
{
	RequestFrame(Update_Ammo, client);

	Action action = Plugin_Continue;
	Function func = EntityFuncAttack[weapon];
	if(func && func!=INVALID_FUNCTION)
	{
		int slot = 1;
		Call_StartFunction(null, func);
		Call_PushCell(client);
		Call_PushCell(weapon);
		Call_PushCellRef(result);
		Call_PushCell(slot);	//This is m1 :)
		Call_Finish(action);
	}
	
	if(i_SemiAutoWeapon[weapon])
	{
		i_SemiAutoWeapon_AmmoCount[weapon] -= 1;
		PrintHintText(client, "[%i/%i]", i_SemiAutoStats_MaxAmmo[weapon],i_SemiAutoWeapon_AmmoCount[weapon]);
		StopSound(client, SNDCHAN_STATIC, "UI/hint.wav");
	}
	
	if(TF2_GetClassnameSlot(classname) == TFWeaponSlot_Melee)
	{
		float attack_speed;
		
		attack_speed = 1.0 / Attributes_FindOnWeapon(client, weapon, 6, true, 1.0);
		
		if(attack_speed > 5.0)
		{
			attack_speed *= 0.5; //Too fast! It makes animations barely play at all
		}
		
		TF2Attrib_SetByDefIndex(client, 201, attack_speed);
			
		if(!IsWandWeapon(weapon) && StrContains(classname, "tf_weapon_wrench"))
		{
			if(Panic_Attack[weapon] && !IsEngineerWeapon(weapon))
			{
				float flHealth = float(GetEntProp(client, Prop_Send, "m_iHealth"));
				float flpercenthpfrommax = flHealth / SDKCall_GetMaxHealth(client);
				
				if(flpercenthpfrommax >= 1.0)
					flpercenthpfrommax = 1.0; //maths to not allow negative suuuper slow attack speed
					
				float Attack_speed = flpercenthpfrommax / Panic_Attack[weapon];
				
				if(Attack_speed <= Panic_Attack[weapon])
				{
					Attack_speed = Panic_Attack[weapon]; //DONT GO ABOVE THIS, WILL BREAK SOME MELEE'S DUE TO THEIR ALREADY INCREACED ATTACK SPEED.
				}
				else if (Attack_speed >= 1.15)
				{
					Attack_speed = 1.15; //hardcoding this lol
				}
				/*
				if(TF2_IsPlayerInCondition(client,TFCond_RuneHaste))
					Attack_speed = 1.0; //If they are last, dont alter attack speed, otherwise breaks melee, again.
					//would also make them really op
				*/
				TF2Attrib_SetByDefIndex(weapon, 396, Attack_speed);
			}
			if(!StrContains(classname, "tf_weapon_knife"))
			{
				Handle swingTrace;
				b_LagCompNPC_No_Layers = true;
				float vecSwingForward[3];
				StartLagCompensation_Base_Boss(client);
				DoSwingTrace_Custom(swingTrace, client, vecSwingForward);
				FinishLagCompensation_Base_boss();
				int target = TR_GetEntityIndex(swingTrace);	
										
				float vecHit[3];
				TR_GetEndPosition(vecHit, swingTrace);	
					
				int Item_Index = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
				PlayCustomWeaponSoundFromPlayerCorrectly(target, client, weapon, Item_Index, classname);	
					
				if(target > 0)
				{
				//	PrintToChatAll("%i",MELEE_HIT);
				//	SDKCall_CallCorrectWeaponSound(weapon, MELEE_HIT, 1.0);
				// 	This doesnt work sadly and i dont have the power/patience to make it work, just do a custom check with some big shit, im sorry.
					float damage = 40.0;
					
					Address address = TF2Attrib_GetByDefIndex(weapon, 2);
					if(address != Address_Null)
						damage *= TF2Attrib_GetValue(address);
						
					
					address = TF2Attrib_GetByDefIndex(weapon, 1);
					if(address != Address_Null)
						damage *= TF2Attrib_GetValue(address);
						
					SDKHooks_TakeDamage(target, client, client, damage, DMG_CLUB, weapon, CalculateDamageForce(vecSwingForward, 20000.0), vecHit, false); //, CalculateBulletDamageForce(m_vecDirShooting, 1.0));	
				}
				delete swingTrace;
			}
			else
			{
				DataPack pack;
				//The delay is usually 0.2 seconds.
				CreateDataTimer(0.2, Timer_Do_Melee_Attack, pack, TIMER_FLAG_NO_MAPCHANGE);
				pack.WriteCell(GetClientUserId(client));
				pack.WriteCell(EntIndexToEntRef(weapon));
				pack.WriteString(classname);
			}
		}
	}
	else
	{
		TF2Attrib_SetByDefIndex(client, 201, 1.0);
	}
	return action;
}

public void OnEntityCreated(int entity, const char[] classname)
{
#if defined ZR
	if (!StrContains(classname, "info_player_teamspawn")) 
	{
		for (int i = 0; i < ZR_MAX_SPAWNERS; i++)
		{
			if (!IsValidEntity(i_ObjectsSpawners[i]) || i_ObjectsSpawners[i] == 0)
			{
				Spawner_AddToArray(entity);
				i_ObjectsSpawners[i] = entity;
				i = ZR_MAX_SPAWNERS;
			}
		}
		return;
	}
#endif
	
	if (entity > 0 && entity <= 2048 && IsValidEntity(entity))
	{
		
#if defined ZR
		i_WhatBuilding[entity] = 0;
		StoreWeapon[entity] = -1;
		b_SentryIsCustom[entity] = false;
#endif
		
		LastHitId[entity] = -1;
		DamageBits[entity] = -1;
		Damage[entity] = 0.0;
		LastHitWeaponRef[entity] = -1;
		IgniteTimer[entity] = INVALID_HANDLE;
		IgniteFor[entity] = -1;
		IgniteId[entity] = -1;
		IgniteRef[entity] = -1;

		//Normal entity render stuff, This should be set to these things on spawn, just to be sure.
		b_DoNotIgnoreDuringLagCompAlly[entity] = false;
		i_EntityRenderMode[entity] = RENDER_NORMAL;
		i_EntityRenderColour1[entity] = 255;
		i_EntityRenderColour2[entity] = 255;
		i_EntityRenderColour3[entity] = 255;
		i_EntityRenderColour4[entity] = 255;
		i_EntityRenderOverride[entity] = false;
		b_StickyIsSticking[entity] = false;

		b_ThisEntityIsAProjectileForUpdateContraints[entity] = false;
		b_EntityIsArrow[entity] = false;
		b_EntityIsWandProjectile[entity] = false;
		CClotBody npc = view_as<CClotBody>(entity);
		b_Is_Npc_Projectile[entity] = false;
		b_Is_Player_Projectile[entity] = false;
		b_Is_Blue_Npc[entity] = false;
		EntityFuncAttack[entity] = INVALID_FUNCTION;
		EntityFuncAttack2[entity] = INVALID_FUNCTION;
		EntityFuncAttack3[entity] = INVALID_FUNCTION;
		EntityFuncReload4[entity] = INVALID_FUNCTION;
		b_Map_BaseBoss_No_Layers[entity] = false;
		b_Is_Player_Projectile_Through_Npc[entity] = false;
		i_IsABuilding[entity] = false;
		i_InSafeZone[entity] = 0;
		h_NpcCollissionHookType[entity] = 0;
		OnEntityCreated_Build_On_Build(entity, classname);
		SetDefaultValuesToZeroNPC(entity);
		i_SemiAutoWeapon[entity] = false;
		b_NpcHasDied[entity] = true;
		
		if(!StrContains(classname, "env_entity_dissolver"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly_Disolve);
		}
		else if(!StrContains(classname, "tf_ammo_pack"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly);
		}
#if defined ZR
		else if(!StrContains(classname, "item_currencypack_custom"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly);
		}
#endif
		else if(!StrContains(classname, "tf_projectile_energy_ring"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly);
		}
		else if(!StrContains(classname, "entity_medigun_shield"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly);
		}
		else if(!StrContains(classname, "tf_projectile_energy_ball"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly);
		}
		else if(!StrContains(classname, "item_powerup_rune"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly);
		}
		else if(!StrContains(classname, "tf_projectile_spellfireball"))
		{
			SDKHook(entity, SDKHook_SpawnPost, ApplyExplosionDhook_Fireball);
			#if defined ZR
			SDKHook(entity, SDKHook_SpawnPost, Wand_Necro_Spell);
			SDKHook(entity, SDKHook_SpawnPost, Wand_Calcium_Spell);
			#endif
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
			SDKHook(entity, SDKHook_SpawnPost, Set_Projectile_Collision);
			SDKHook(entity, SDKHook_SpawnPost, See_Projectile_Team);
			RequestFrame(See_Projectile_Team, EntIndexToEntRef(entity));
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
		//	ApplyExplosionDhook_Rocket(entity);
			//SDKHook_SpawnPost doesnt work
		}
		else if(!StrContains(classname, "vgui_screen")) //Delete dispenser screen cut its really not needed at all, just takes up stuff for no reason
		{
			SDKHook(entity, SDKHook_SpawnPost, Delete_instantly);
		}
		else if(!StrContains(classname, "tf_weapon_wrench")) //need custom logic here
		{
			OnWrenchCreated(entity);
		}
		else if(!StrContains(classname, "base_boss"))
		{
			SDKHook(entity, SDKHook_SpawnPost, Check_For_Team_Npc);
		//	Check_For_Team_Npc(EntIndexToEntRef(entity)); //Dont delay ?
		}
		else if(!StrContains(classname, "func_breakable"))
		{
			for (int i = 0; i < ZR_MAX_BREAKBLES; i++)
			{
				if (EntRefToEntIndex(i_ObjectsBreakable[i]) <= 0)
				{
					i_ObjectsBreakable[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_BREAKBLES;
				}
			}
			SDKHook(entity, SDKHook_OnTakeDamagePost, Func_Breakable_Post);
		}
		else if(!StrContains(classname, "tf_projectile_syringe"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
			SDKHook(entity, SDKHook_SpawnPost, Set_Projectile_Collision);
			SDKHook(entity, SDKHook_SpawnPost, See_Projectile_Team);
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			RequestFrame(See_Projectile_Team, EntIndexToEntRef(entity));
			//SDKHook_SpawnPost doesnt work
		}
		
		else if(!StrContains(classname, "tf_projectile_healing_bolt"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
			SDKHook(entity, SDKHook_SpawnPost, Set_Projectile_Collision);
			SDKHook(entity, SDKHook_SpawnPost, See_Projectile_Team_Player);
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			//SDKHook_SpawnPost doesnt work
		}
		
		else if(!StrContains(classname, "tf_projectile_pipe_remote"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
			SDKHook(entity, SDKHook_SpawnPost, Set_Projectile_Collision);
			SDKHook(entity, SDKHook_SpawnPost, See_Projectile_Team);
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			ApplyExplosionDhook_Pipe(entity, true);
			//SDKHook_SpawnPost doesnt work
		}
		else if(!StrContains(classname, "tf_projectile_arrow"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
			SDKHook(entity, SDKHook_SpawnPost, Set_Projectile_Collision);
			SDKHook(entity, SDKHook_SpawnPost, See_Projectile_Team);
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			RequestFrame(See_Projectile_Team, EntIndexToEntRef(entity));
			//SDKHook_SpawnPost doesnt work
		}
		else if(!StrContains(classname, "prop_dynamic"))
		{
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
		}
		else if(!StrContains(classname, "prop_physics_multiplayer"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
		}
		else if(!StrContains(classname, "prop_physics_override"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			b_Is_Player_Projectile[entity] = true; //Pretend its a player projectile for now.
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
		}
		else if(!StrContains(classname, "func_door_rotating"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			b_Is_Player_Projectile[entity] = true; //Pretend its a player projectile for now.
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
		}
		else if(!StrContains(classname, "prop_physics"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
			b_Is_Player_Projectile[entity] = true; //Pretend its a player projectile for now.
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
		}
		else if(!StrContains(classname, "tf_projectile_pipe"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
			SDKHook(entity, SDKHook_SpawnPost, Set_Projectile_Collision);
			SDKHook(entity, SDKHook_SpawnPost, See_Projectile_Team);
			ApplyExplosionDhook_Pipe(entity, false);
			
#if defined ZR
			SDKHook(entity, SDKHook_SpawnPost, Is_Pipebomb);
#endif
			
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			RequestFrame(See_Projectile_Team, EntIndexToEntRef(entity));
			//SDKHook_SpawnPost doesnt work
		}
		else if(!StrContains(classname, "tf_projectile_rocket"))
		{
			b_ThisEntityIsAProjectileForUpdateContraints[entity] = true;
			SDKHook(entity, SDKHook_SpawnPost, ApplyExplosionDhook_Rocket);
			npc.bCantCollidie = true;
			npc.bCantCollidieAlly = true;
			SDKHook(entity, SDKHook_SpawnPost, Set_Projectile_Collision);
			SDKHook(entity, SDKHook_SpawnPost, See_Projectile_Team);
		//	SDKHook(entity, SDKHook_ShouldCollide, Never_ShouldCollide);
			RequestFrame(See_Projectile_Team, EntIndexToEntRef(entity));
		}
		
#if defined ZR
		else if (!StrContains(classname, "tf_weapon_medigun")) 
		{
			Medigun_OnEntityCreated(entity);
		}
		else if (!StrContains(classname, "tf_weapon_handgun_scout_primary")) 
		{
			ScatterGun_Prevent_M2_OnEntityCreated(entity);
		}
		else if (!StrContains(classname, "tf_weapon_particle_cannon")) 
		{
			OnManglerCreated(entity);
		}
#endif
		
		else if(!StrContains(classname, "obj_"))
		{
			npc.bCantCollidieAlly = true;
			i_IsABuilding[entity] = true;
			for (int i = 0; i < ZR_MAX_BUILDINGS; i++)
			{
				if (EntRefToEntIndex(i_ObjectsBuilding[i]) <= 0)
				{
					i_ObjectsBuilding[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_BUILDINGS;
				}
			}
			
#if defined ZR
			SDKHook(entity, SDKHook_SpawnPost, Building_EntityCreatedPost);
#endif
			
		}
		/*
		else if(!StrContains(classname, "tf_gamerules_data"))
		{
			GetEntPropString(i, Prop_Data, "m_iName", buffer, sizeof(buffer));
		}
		*/
		else if(!StrContains(classname, "trigger_hurt"))
		{
			SDKHook(entity, SDKHook_StartTouch, SDKHook_SafeSpot_StartTouch);
			SDKHook(entity, SDKHook_EndTouch, SDKHook_SafeSpot_EndTouch);
		}
		else if(!StrContains(classname, "func_respawnroom"))
		{
			SDKHook(entity, SDKHook_StartTouch, SDKHook_RespawnRoom_StartTouch);
			SDKHook(entity, SDKHook_EndTouch, SDKHook_RespawnRoom_EndTouch);
		}
	}
	
}

public void SDKHook_SafeSpot_StartTouch(int entity, int target)
{
	if(target > 0 && target < sizeof(i_InSafeZone))
	{
		i_InSafeZone[target]++;
	}
}

public void SDKHook_SafeSpot_EndTouch(int entity, int target)
{
	if(target > 0 && target < sizeof(i_InSafeZone))
	{
		i_InSafeZone[target]--;
	}
}

public void SDKHook_RespawnRoom_StartTouch(int entity, int target)
{
	if(target > 0 && target < sizeof(i_InSafeZone) && GetEntProp(entity, Prop_Send, "m_iTeamNum") == GetEntProp(target, Prop_Send, "m_iTeamNum"))
		i_InSafeZone[target]++;
}

public void SDKHook_RespawnRoom_EndTouch(int entity, int target)
{
	if(target > 0 && target < sizeof(i_InSafeZone) && GetEntProp(entity, Prop_Send, "m_iTeamNum") == GetEntProp(target, Prop_Send, "m_iTeamNum"))
		i_InSafeZone[target]--;
}

public void Set_Projectile_Collision(int entity)
{
	if(IsValidEntity(entity) && GetEntProp(entity, Prop_Send, "m_iTeamNum") != view_as<int>(TFTeam_Blue))
	{
		SetEntityCollisionGroup(entity, 27);
	}
}

public void Check_For_Team_Npc(int entity)
{
//	int entity = EntRefToEntIndex(ref);
	if (IsValidEntity(entity))
	{
		CClotBody npcstats = view_as<CClotBody>(entity);
		if(!npcstats.m_bThisNpcGotDefaultStats_INVERTED) //IF THIS IS FALSE, then that means that a baseboss spawned without getting default stats.
		{
			//ADD TELEPORT LOGIC IF NEEDED!!!
			RequestFrame(Check_For_Team_Npc_Delayed, EntIndexToEntRef(entity)); //outside plugins are doing something...., give them time to do their crap...
			return;
		}
		b_NpcHasDied[entity] = false;
		b_IsAlliedNpc[entity] = false;
		if(GetEntProp(entity, Prop_Send, "m_iTeamNum") == view_as<int>(TFTeam_Red))
		{
		//	SDKHook(entity, SDKHook_TraceAttack, NPC_TraceAttack);
			SDKHook(entity, SDKHook_OnTakeDamage, NPC_OnTakeDamage);
			SDKHook(entity, SDKHook_OnTakeDamagePost, NPC_OnTakeDamage_Post);
			npcstats.bCantCollidieAlly = true;
			npcstats.bCantCollidie = false;
			b_IsAlliedNpc[entity] = true;
			if(!npcstats.m_bThisNpcGotDefaultStats_INVERTED) //IF THIS IS FALSE, then that means that a baseboss spawned without getting default stats.
			{
				npcstats.SetDefaultStatsZombieRiot(view_as<int>(TFTeam_Red));
			}
			
			if(npcstats.m_bThisEntityIgnored) //do not collide. This is just as a global rule.
			{
				npcstats.bCantCollidie = true;
			}
			
			SetEntProp(entity, Prop_Send, "m_bGlowEnabled", false);
			
			for (int i = 0; i < ZR_MAX_NPCS_ALLIED; i++)
			{
				if (EntRefToEntIndex(i_ObjectsNpcs_Allied[i]) <= 0)
				{
					i_ObjectsNpcs_Allied[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_NPCS_ALLIED;
				}
			}
			
		}	
		else
		{
			//This code only exists if a base_boss that gets summoned isnt a boss, and also isnt applied by the plugin, so it will default to a non boss
			//As a safety measure.
			//Todo: If any map has any base_boss, detect and apply.
			//Idea: detect if team 0, if yes, move to zombie team and apply boss status!
		//	PrintToChatAll("%i",GetCustomKeyValue(entity,"m_bThisEntityIgnored", "1", 2));
		//	SetCustomKeyValue(client, "m_bThisEntityIgnored", "0");
			
			SDKHook(entity, SDKHook_TraceAttack, NPC_TraceAttack);
			SDKHook(entity, SDKHook_OnTakeDamage, NPC_OnTakeDamage);
			if(!npcstats.m_bThisNpcGotDefaultStats_INVERTED) //IF THIS IS FALSE, then that means that a baseboss spawned without getting default stats.
			{
				b_Map_BaseBoss_No_Layers[entity] = true;
				SDKHook(entity, SDKHook_OnTakeDamagePost, Map_BaseBoss_Damage_Post);
				npcstats.SetDefaultStatsZombieRiot(view_as<int>(TFTeam_Blue));
			}
			
			else
			{
				SDKHook(entity, SDKHook_OnTakeDamagePost, NPC_OnTakeDamage_Post);	
			}
			
			
			npcstats.bCantCollidie = true;
			npcstats.bCantCollidieAlly = false;
			b_Is_Blue_Npc[entity] = true;
			for (int i = 0; i < ZR_MAX_NPCS; i++)
			{
				if (EntRefToEntIndex(i_ObjectsNpcs[i]) <= 0)
				{
					i_ObjectsNpcs[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_NPCS;
				}
			}
			for (int i = 0; i < ZR_MAX_LAG_COMP; i++) //Make them lag compensate
			{
				if (EntRefToEntIndex(i_Objects_Apply_Lagcompensation[i]) <= 0)
				{
					i_Objects_Apply_Lagcompensation[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_LAG_COMP;
				}
			}
		}
	}
}


public void Check_For_Team_Npc_Delayed(int ref)
{
	int entity = EntRefToEntIndex(ref);
	if (IsValidEntity(entity))
	{
		CClotBody npcstats = view_as<CClotBody>(entity);
		b_NpcHasDied[entity] = false;
		b_IsAlliedNpc[entity] = false;
		if(GetEntProp(entity, Prop_Send, "m_iTeamNum") == view_as<int>(TFTeam_Red))
		{
		//	SDKHook(entity, SDKHook_TraceAttack, NPC_TraceAttack);
			SDKHook(entity, SDKHook_OnTakeDamage, NPC_OnTakeDamage);
			SDKHook(entity, SDKHook_OnTakeDamagePost, NPC_OnTakeDamage_Post);
			npcstats.bCantCollidieAlly = true;
			npcstats.bCantCollidie = false;
			b_IsAlliedNpc[entity] = true;
			if(!npcstats.m_bThisNpcGotDefaultStats_INVERTED) //IF THIS IS FALSE, then that means that a baseboss spawned without getting default stats.
			{
				npcstats.SetDefaultStatsZombieRiot(view_as<int>(TFTeam_Red));
			}
			
			if(npcstats.m_bThisEntityIgnored) //do not collide. This is just as a global rule.
			{
				npcstats.bCantCollidie = true;
			}
			
			SetEntProp(entity, Prop_Send, "m_bGlowEnabled", false);
			
			for (int i = 0; i < ZR_MAX_NPCS_ALLIED; i++)
			{
				if (EntRefToEntIndex(i_ObjectsNpcs_Allied[i]) <= 0)
				{
					i_ObjectsNpcs_Allied[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_NPCS_ALLIED;
				}
			}
			
		}	
		else
		{
			//This code only exists if a base_boss that gets summoned isnt a boss, and also isnt applied by the plugin, so it will default to a non boss
			//As a safety measure.
			//Todo: If any map has any base_boss, detect and apply.
			//Idea: detect if team 0, if yes, move to zombie team and apply boss status!
		//	PrintToChatAll("%i",GetCustomKeyValue(entity,"m_bThisEntityIgnored", "1", 2));
		//	SetCustomKeyValue(client, "m_bThisEntityIgnored", "0");
			
			SDKHook(entity, SDKHook_TraceAttack, NPC_TraceAttack);
			SDKHook(entity, SDKHook_OnTakeDamage, NPC_OnTakeDamage);
			if(!npcstats.m_bThisNpcGotDefaultStats_INVERTED) //IF THIS IS FALSE, then that means that a baseboss spawned without getting default stats.
			{
				b_Map_BaseBoss_No_Layers[entity] = true;
				SDKHook(entity, SDKHook_OnTakeDamagePost, Map_BaseBoss_Damage_Post);
				npcstats.SetDefaultStatsZombieRiot(view_as<int>(TFTeam_Blue));
			}
			
			else
			{
				SDKHook(entity, SDKHook_OnTakeDamagePost, NPC_OnTakeDamage_Post);	
			}
			
			npcstats.bCantCollidie = true;
			npcstats.bCantCollidieAlly = false;
			b_Is_Blue_Npc[entity] = true;
			for (int i = 0; i < ZR_MAX_NPCS; i++)
			{
				if (EntRefToEntIndex(i_ObjectsNpcs[i]) <= 0)
				{
					i_ObjectsNpcs[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_NPCS;
				}
			}
			for (int i = 0; i < ZR_MAX_LAG_COMP; i++) //Make them lag compensate
			{
				if (EntRefToEntIndex(i_Objects_Apply_Lagcompensation[i]) <= 0)
				{
					i_Objects_Apply_Lagcompensation[i] = EntIndexToEntRef(entity);
					i = ZR_MAX_LAG_COMP;
				}
			}
			
		}
	}
}

public void Delete_instantly(int entity)
{
	RemoveEntity(entity);
}

public void Delete_instantly_Disolve(int entity) //arck, they are client side...
{
	RemoveEntity(entity);
}

/*
public void Delete_instantly_Laser_ball(int entity)
{
	int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if(owner <= MaxClients)
	{
		RemoveEntity(entity);
	}
	if(GetEntProp(entity, Prop_Send, "m_iTeamNum") == view_as<int>(TFTeam_Blue))
	{
		b_Is_Npc_Projectile[entity] = true; 
	}
}
*/
public void OnEntityDestroyed(int entity)
{
	if(IsValidEntity(entity))
	{
		#if defined LagCompensation
		OnEntityDestroyed_LagComp(entity);
		#endif
		
		if(entity > MaxClients)
		{
			NPC_CheckDead(entity);
			b_IsAGib[entity] = false;
			i_ExplosiveProjectileHexArray[entity] = 0; //reset on destruction.
			
#if defined ZR
			OnEntityDestroyed_BackPack(entity);
#endif
			
			RemoveNpcThingsAgain(entity);
			IsCustomTfGrenadeProjectile(entity, 0.0);
			
			if(h_NpcCollissionHookType[entity] != 0)
			{
				if(!DHookRemoveHookID(h_NpcCollissionHookType[entity]))
				{
					PrintToConsoleAll("Somehow Failed to unhook h_NpcCollissionHookType");
				}
			}
		}
	}
	
	OnEntityDestroyed_Build_On_Build(entity);
}

public void RemoveNpcThingsAgain(int entity)
{
	//Dont have to check for if its an npc or not, really doesnt matter in this case, just be sure to delete it cus why not
	//incase this breaks, add a baseboss check
	CleanAllAppliedEffects(entity);
	
#if defined ZR
	CleanAllApplied_Aresenal(entity);
	CleanAllApplied_Cryo(entity);
	b_NpcForcepowerupspawn[entity] = 0;	
#endif
	
	i_HexCustomDamageTypes[entity] = 0;
}

public void CheckIfAloneOnServer()
{
	b_IsAloneOnServer = false;
	int players;

#if defined ZR
	int player_alone;
#endif

	for(int client=1; client<=MaxClients; client++)
	{
		
#if defined ZR
		if(IsClientInGame(client) && GetClientTeam(client)==2 && !IsFakeClient(client) && TeutonType[client] != TEUTON_WAITING)
#else
		if(IsClientInGame(client) && GetClientTeam(client)==2 && !IsFakeClient(client))
#endif
		
		{
			players += 1;

#if defined ZR
			player_alone = client;
#endif

		}
	}
	if(players == 1)
	{
		b_IsAloneOnServer = true;	
	}
	
#if defined ZR
	if (players < 4 && players > 0)
	{
		if (Bob_Exists)
			return;
		
		Spawn_Bob_Combine(player_alone);
		
	}
	else if (Bob_Exists)
	{
		Bob_Exists = false;
		NPC_Despawn_bob(EntRefToEntIndex(Bob_Exists_Index));
		Bob_Exists_Index = -1;
	}
#endif

#if defined RPG
	CurrentPlayers = players;
#endif
}

/*
//Looping function for above!
for(int entitycount; entitycount<i_MaxcountNpc; entitycount++)
{
	int entity = EntRefToEntIndex(i_ObjectsNpcs[entitycount]);
}
*/

/*
//Looping function for above!
for(int entitycount; entitycount<i_MaxcountBuilding; entitycount++)
{
	int entity = EntRefToEntIndex(i_ObjectsBuilding[entitycount]);
}
*/

/*
//Looping function for above!
for(int entitycount; entitycount<i_MaxcountHomingMagicShot; entitycount++)
{
	int entity = EntRefToEntIndex(i_ObjectsHomingMagicShot[entitycount]);
}
*/

public void TF2_OnConditionAdded(int client, TFCond condition)
{
	if(condition == TFCond_Cloaked)
	{
		TF2_RemoveCondition(client, TFCond_Cloaked);
	}
	else if(condition == TFCond_Zoomed && thirdperson[client] && IsPlayerAlive(client))
	{
		SetVariantInt(0);
		AcceptEntityInput(client, "SetForcedTauntCam");
		TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.00001);
	}
	else if (condition == TFCond_Slowed && IsPlayerAlive(client))
	{
		TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.00001);
	}
}

public void TF2_OnConditionRemoved(int client, TFCond condition)
{
	if(IsValidClient(client)) //Need this, i think this has a chance to return -1 for some reason. probably disconnect.
	{
		if(condition == TFCond_Zoomed && thirdperson[client] && IsPlayerAlive(client))
		{
			SetVariantInt(1);
			AcceptEntityInput(client, "SetForcedTauntCam");
			TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.00001);
		}
		else if(condition == TFCond_Slowed && IsPlayerAlive(client))
		{
			TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.00001);
		}
		else if (condition == TFCond_Dazed)
		{
			//Fixes full stuns not unhiding the active weapon when the stun ends
			// ty miku
			int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if(IsValidEntity(weapon))
				SetEntProp(weapon, Prop_Send, "m_fEffects", GetEntProp(weapon, Prop_Send, "m_fEffects") & ~0x020);
		}
	}
}

bool InteractKey(int client, int weapon, bool Is_Reload_Button = false)
{
	if(weapon!=-1) //Just allow. || GetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack")<GetGameTime())
	{
		int entity = GetClientPointVisible(client); //So you can also correctly interact with players holding shit.
		if(entity > 0)
		{
			static char buffer[64];
			if(GetEntityClassname(entity, buffer, sizeof(buffer)))
			{
#if defined ZR
				if(Building_Interact(client, entity, Is_Reload_Button))
					return true;
					
				if(Store_Girogi_Interact(client, entity, buffer, Is_Reload_Button))
					return true;
					
				if(Escape_Interact(client, entity))
					return true;
				
				//if(Store_Interact(client, entity, buffer))
				//	return true;
				
				if(Citizen_Interact(client, entity))
					return true;
#endif
				
			}
		}
	}
	return false;
}

void GiveXP(int client, int xp)
{
	XP[client] += RoundToNearest(float(xp) * CvarXpMultiplier.FloatValue);
	int nextLevel = XpToLevel(XP[client]);
	if(nextLevel > Level[client])
	{
		static const char Names[][] = { "one", "two", "three", "four", "five", "six" };
		ClientCommand(client, "playgamesound ui/mm_level_%s_achieved.wav", Names[GetRandomInt(0, sizeof(Names)-1)]);
		
		int maxhealth = SDKCall_GetMaxHealth(client);
		if(GetClientHealth(client) < maxhealth)
			SetEntityHealth(client, maxhealth);
		
#if defined RPG
		SPrintToChat(client, "%t", "Level Up", nextLevel);
#else
		SetGlobalTransTarget(client);
		PrintToChat(client, "%t", "Level Up", nextLevel);
#endif
		
#if defined ZR
		bool found;
		int slots;
		
		for(Level[client]++; Level[client]<=nextLevel; Level[client]++)
		{
			if(Store_PrintLevelItems(client, Level[client]))
				found = true;
			
			if(!(Level[client] % 2))
				slots++;
		}
		
		if(slots)
		{
			PrintToChat(client, "%t", "Loadout Slots", slots);
		}
		else if(!found)
		{
			PrintToChat(client, "%t", "None");
		}
#endif

#if defined RPG
		Level[client] = nextLevel;
#endif
	}
}

int XpToLevel(int xp)
{
#if defined ZR
	return RoundToFloor(Pow(xp/200.0, 0.5));
#else
	return RoundToFloor(Pow(xp/100.0, 0.5));
#endif
}

int LevelToXp(int lv)
{
#if defined ZR
	return RoundToCeil(Pow(float(lv), 2.0)*200.0);
#else
	return RoundToCeil(Pow(float(lv), 2.0)*100.0);
#endif
}
/*
public void Frame_OffCheats()
{
	CvarCheats.SetBool(false, false, false);
}
*/
public any Native_FuncToVal(Handle plugin, int numParams)
{
	return GetNativeCell(1);
}

public any Native_ApplyKillEffects(Handle plugin, int numParams)
{
	NPC_DeadEffects(GetNativeCell(1));
	return Plugin_Handled;
}

public any Native_GetLevelCount(Handle plugin, int numParams)
{
	return Level[GetNativeCell(1)];
}

//#file "Zombie Riot" broke in sm 1.11

static void MapStartResetAll()
{
	Zero(b_IsAGib);
	Zero(f_StuckTextChatNotif);
	Zero(i_Hex_WeaponUsesTheseAbilities);
	Zero(f_WidowsWineDebuffPlayerCooldown);
	Zero(f_WidowsWineDebuff);
	Zero(f_TempCooldownForVisualManaPotions);
	Zero(i_IsABuilding);
	Zero(f_DelayLookingAtHud);
	Zero(f_TimeUntillNormalHeal);
	Zero(Mana_Regen_Delay);
	Zero(Mana_Hud_Delay);
	Zero(delay_hud);
	Zero(Increaced_Overall_damage_Low);
	Zero(Resistance_Overall_Low);
	Zero(Increaced_Sentry_damage_Low);
	Zero(Increaced_Sentry_damage_High);
	Zero(Resistance_for_building_Low);
	Zero(f_BotDelayShow);
	SDKHooks_ClearAll();
	Zero(f_OneShotProtectionTimer);
	CleanAllNpcArray();
	Zero(f_ClientServerShowMessages);
	Zero(h_NpcCollissionHookType);
	Zero2(i_StickyToNpcCount);
	Zero(f_DelayBuildNotif);
	Zero(f_ClientInvul);
	Zero(i_HasBeenBackstabbed);
	Zero(i_HasBeenHeadShotted);
	Zero(f_StuckTextChatNotif);
	Zero(b_LimitedGibGiveMoreHealth);
	Zero2(f_TargetWasBlitzedByRiotShield);
	Zero(f_StunExtraGametimeDuration);
	CurrentGibCount = 0;
	Zero(f_EmpowerStateSelf);
	Zero(f_EmpowerStateOther);
}
