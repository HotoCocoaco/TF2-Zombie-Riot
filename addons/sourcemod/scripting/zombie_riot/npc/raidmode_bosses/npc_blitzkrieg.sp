#pragma semicolon 1
#pragma newdecls required

static char g_DeathSounds[][] = {
	"mvm/mvm_robo_stun.wav",
	"mvm/mvm_bomb_explode.wav",
};

static char g_HurtSounds[][] = {
	"vo/medic_item_secop_domination01.mp3",
	"vo/medic_item_secop_idle03.mp3",
	"vo/medic_item_secop_idle01.mp3",
	"vo/medic_item_secop_idle02.mp3",
};

static char g_IdleSounds[][] = {
	"vo/medic_specialcompleted11.mp3",
	"vo/medic_specialcompleted12.mp3",
	"vo/medic_specialcompleted08.mp3",
};

static char g_IdleAlertedSounds[][] = {
	"vo/medic_hat_taunts01.mp3",
	"vo/medic_hat_taunts04.mp3",
	"vo/medic_item_secop_round_start05.mp3",
	"vo/medic_item_secop_round_start07.mp3",
	"vo/medic_item_secop_kill_assist01.mp3",
};

static char g_MeleeHitSounds[][] = {
	"vo/medic_laughshort01.mp3",
	"vo/medic_laughshort02.mp3",
	"vo/medic_laughshort03.mp3",
};

static char g_MeleeAttackSounds[][] = {
	"weapons/airstrike_fire_01.wav",
	"weapons/airstrike_fire_02.wav",
	"weapons/airstrike_fire_03.wav",
};

static char g_RangedAttackSounds[][] = {
	"weapons/airstrike_fire_03.wav",
};
static char g_TeleportSounds[][] = {
	"weapons/bison_main_shot.wav",
};

static char g_MeleeMissSounds[][] = {
	"weapons/cbar_miss1.wav",
};

static char g_AngerSounds[][] = {
	"vo/medic_sf13_influx_big02.mp3",
	"vo/medic_sf13_influx_big03.mp3",
	"vo/medic_weapon_taunts03.mp3",
};
static const char g_IdleMusic[][] = {
	"#ui/gamestartup12.mp3",
};
static char g_PullSounds[][] = {
	"weapons/knife_swing.wav",
};

static char gGlow1;
static char gExplosive1;
static char gLaser1;

static int i_AmountProjectiles[MAXENTITIES];
static int i_NpcCurrentLives[MAXENTITIES];
static float i_HealthScale[MAXENTITIES];
static float fl_AlreadyStrippedMusic[MAXTF2PLAYERS];
static float fl_LifelossReload[MAXENTITIES];
static float fl_TheFinalCountdown[MAXENTITIES];
static float fl_TheFinalCountdown2[MAXENTITIES];

static bool b_Are_we_reloading[MAXENTITIES];

static float fl_move_speed[MAXENTITIES];
//Rocket launcher stuff
static float fl_rocket_firerate[MAXENTITIES];
static int i_PrimaryRocketsFired[MAXENTITIES];
static int i_maxfirerockets[MAXENTITIES];
static float fl_rocket_base_dmg[MAXENTITIES];
/*
//Blitz storm.
static bool b_are_we_in_blitzstorm[MAXENTITIES];
static float fl_blitzstrom_cooldown[MAXENTITIES];
static int i_blitzstorm_strikes[MAXENTITIES];
*/
//Wave control
static int i_wave_life1[MAXENTITIES];
static int i_wave_life2[MAXENTITIES];
static int i_wave_life3[MAXENTITIES];
static int i_wave_life4[MAXENTITIES];

//static int i_wave_blitzstorm[MAXENTITIES];

static float fl_blitzscale[MAXENTITIES];

static bool b_final_push[MAXENTITIES];

static int i_final_nr[MAXENTITIES];

static bool b_BlitzLight[MAXENTITIES];
static bool b_BlitzLight_used[MAXENTITIES];
static bool b_BlitzLight_stop[MAXENTITIES];
static bool b_BlitzLight_sound[MAXENTITIES];

static float fl_BlitzLight_Throttle[MAXENTITIES];

#define BLITZLIGHT_SPRITE	  "materials/sprites/laserbeam.vmt"
#define BLITZLIGHT_ACTIVATE	  "vo/medic_sf13_influx_big02.mp3"
#define BLITZLIGHT_ATTACK	  "mvm/ambient_mp3/mvm_siren.mp3"

static bool b_life1[MAXENTITIES];
static bool b_life2[MAXENTITIES];
static bool b_life3[MAXENTITIES];
static bool b_allies[MAXENTITIES];
static bool b_lowplayercount[MAXENTITIES];
static int i_currentwave[MAXENTITIES];

  ///////////////////////
 ///BlitzLight Floats///
///////////////////////

static float BlitzLight_Duration_notick[MAXENTITIES];
int BlitzLight_Beam;

float BlitzLight_Duration[MAXENTITIES];
float BlitzLight_ChargeTime[MAXENTITIES];
float BlitzLight_Scale1[MAXENTITIES];
float BlitzLight_Scale2[MAXENTITIES];
float BlitzLight_Scale2_timer[MAXENTITIES];
float BlitzLight_Scale3[MAXENTITIES];
float BlitzLight_Scale3_timer[MAXENTITIES];
float BlitzLight_DMG[MAXENTITIES];
float BlitzLight_DMG_Base[MAXENTITIES];
float BlitzLight_DMG_Radius[MAXENTITIES];
float BlitzLight_Radius[MAXENTITIES];
float BlitzLight_Angle[MAXENTITIES];

public void Blitzkrieg_OnMapStart()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));       i++) { PrecacheSound(g_DeathSounds[i]);      		}
	for (int i = 0; i < (sizeof(g_HurtSounds));        i++) { PrecacheSound(g_HurtSounds[i]);       		}
	for (int i = 0; i < (sizeof(g_IdleSounds));        i++) { PrecacheSound(g_IdleSounds[i]);       		}
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]);		}
	for (int i = 0; i < (sizeof(g_MeleeHitSounds));    i++) { PrecacheSound(g_MeleeHitSounds[i]);   		}
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds));    i++) { PrecacheSound(g_MeleeAttackSounds[i]);		}
	for (int i = 0; i < (sizeof(g_MeleeMissSounds));   i++) { PrecacheSound(g_MeleeMissSounds[i]); 			}
	for (int i = 0; i < (sizeof(g_TeleportSounds));   i++) { PrecacheSound(g_TeleportSounds[i]);  			}		
	for (int i = 0; i < (sizeof(g_RangedAttackSounds));   i++) { PrecacheSound(g_RangedAttackSounds[i]);	}
	for (int i = 0; i < (sizeof(g_AngerSounds));   i++) { PrecacheSound(g_AngerSounds[i]);   				}
	for (int i = 0; i < (sizeof(g_IdleMusic));   i++) { PrecacheSound(g_IdleMusic[i]);   }
	for (int i = 0; i < (sizeof(g_PullSounds));   i++) { PrecacheSound(g_PullSounds[i]);   }
	
	PrecacheSound("weapons/physcannon/energy_sing_loop4.wav", true);
	PrecacheSound("weapons/physcannon/physcannon_drop.wav", true);
	
	PrecacheSound("player/flow.wav");
	
	PrecacheSound("mvm/mvm_cpoint_klaxon.wav");
	PrecacheSound("mvm/mvm_tank_end.wav");
	PrecacheSound("mvm/mvm_tank_horn.wav");
	PrecacheSound("mvm/mvm_tank_explode.wav");
	PrecacheSound("zombiesurvival/beats/defaultzombiev2/10.mp3");
	
	gLaser1 = PrecacheModel("materials/sprites/laser.vmt");
	gGlow1 = PrecacheModel("sprites/blueglow2.vmt", true);
	
	BlitzLight_Beam = PrecacheModel(BLITZLIGHT_SPRITE);
	
	PrecacheSound(BLITZLIGHT_ACTIVATE, true);
	PrecacheSound(BLITZLIGHT_ATTACK, true);
	
}

static float fl_PlayMusicSound[MAXENTITIES];

methodmap Blitzkrieg < CClotBody
{
	property int m_iAmountProjectiles
	{
		public get()							{ return i_AmountProjectiles[this.index]; }
		public set(int TempValueForProperty) 	{ i_AmountProjectiles[this.index] = TempValueForProperty; }
	}
	property float m_flPlayMusicSound
	{
		public get()							{ return fl_PlayMusicSound[this.index]; }
		public set(float TempValueForProperty) 	{ fl_PlayMusicSound[this.index] = TempValueForProperty; }
	}
		public void PlayIdleSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		EmitSoundToAll(g_IdleSounds[GetRandomInt(0, sizeof(g_IdleSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME, GetRandomInt(BOSS_ZOMBIE_SOUNDLEVEL, 100));
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(24.0, 48.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleSound()");
		#endif
	}
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME, GetRandomInt(BOSS_ZOMBIE_SOUNDLEVEL, 100));
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleAlertSound()");
		#endif
	}
	public void PlayMusicSound() {
		if(this.m_flPlayMusicSound > GetEngineTime())
			return;
			
		EmitSoundToAll(g_IdleMusic[GetRandomInt(0, sizeof(g_IdleMusic) - 1)], this.index, SNDCHAN_AUTO, 120, _, BOSS_ZOMBIE_VOLUME, 100);
		EmitSoundToAll(g_IdleMusic[GetRandomInt(0, sizeof(g_IdleMusic) - 1)], this.index, SNDCHAN_AUTO, 120, _, BOSS_ZOMBIE_VOLUME, 100);
		EmitSoundToAll(g_IdleMusic[GetRandomInt(0, sizeof(g_IdleMusic) - 1)], this.index, SNDCHAN_AUTO, 120, _, BOSS_ZOMBIE_VOLUME, 100);
		EmitSoundToAll(g_IdleMusic[GetRandomInt(0, sizeof(g_IdleMusic) - 1)], this.index, SNDCHAN_AUTO, 120, _, BOSS_ZOMBIE_VOLUME, 100);
		this.m_flPlayMusicSound = GetEngineTime() + 233.0;
		
	}
	public void PlayHurtSound() {
		if(this.m_flNextHurtSound > GetGameTime(this.index))
			return;
			
		this.m_flNextHurtSound = GetGameTime(this.index) + 0.4;
		
		EmitSoundToAll(g_HurtSounds[GetRandomInt(0, sizeof(g_HurtSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME, GetRandomInt(BOSS_ZOMBIE_SOUNDLEVEL, 100));
		
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayHurtSound()");
		#endif
	}
	
	public void PlayDeathSound() {
		
		int sound = GetRandomInt(0, sizeof(g_DeathSounds) - 1);
		
		EmitSoundToAll(g_DeathSounds[sound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
	}
	
	public void PlayMeleeSound() {
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, 0.5);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
	
	public void PlayAngerSound() {
	
		EmitSoundToAll(g_AngerSounds[GetRandomInt(0, sizeof(g_AngerSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll(g_AngerSounds[GetRandomInt(0, sizeof(g_AngerSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
	}
	
	public void PlayRangedSound() {
		EmitSoundToAll(g_RangedAttackSounds[GetRandomInt(0, sizeof(g_RangedAttackSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayRangedSound()");
		#endif
	}
	
	public void PlayTeleportSound() {
		EmitSoundToAll(g_TeleportSounds[GetRandomInt(0, sizeof(g_TeleportSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayTeleportSound()");
		#endif
	}
	public void PlayMeleeHitSound() {
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}

	public void PlayMeleeMissSound() {
		EmitSoundToAll(g_MeleeMissSounds[GetRandomInt(0, sizeof(g_MeleeMissSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CGoreFast::PlayMeleeMissSound()");
		#endif
	}
	public void PlayPullSound() {
		EmitSoundToAll(g_PullSounds[GetRandomInt(0, sizeof(g_PullSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayPullSound()");
		#endif
	}
	public Blitzkrieg(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		Blitzkrieg npc = view_as<Blitzkrieg>(CClotBody(vecPos, vecAng, "models/player/medic.mdl", "1.4", "25000", ally, false, true, true, true)); //giant!
		
		i_NpcInternalId[npc.index] = RAIDMODE_BLITZKRIEG;
		
		FormatEx(c_HeadPlaceAttachmentGibName[npc.index], sizeof(c_HeadPlaceAttachmentGibName[]), "head");
		
		RaidBossActive = EntIndexToEntRef(npc.index);
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_PRIMARY");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		npc.m_flPlayMusicSound = 0.0;
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_GIANT;	
		npc.m_iNpcStepVariation = STEPSOUND_NORMAL;		
		
		npc.m_bThisNpcIsABoss = true;
		
		RaidModeTime = GetGameTime(npc.index) + 200.0;
		
		i_NpcCurrentLives[npc.index] = 0;	//Basically tells the npc which life it currently is in
		
		i_HealthScale[npc.index] = 1.0;	//default 1, this is instantly overriden the moment the npc takes damage.
		
		//i_blitzstorm_strikes[npc.index] = 0;
		
		//fl_blitzstrom_cooldown[npc.index] = GetGameTime(npc.index) + 1.0;
		
		//b_are_we_in_blitzstorm[npc.index] = false;
		
		fl_move_speed[npc.index] = 250.0;	//base move speed when on life 0, when npc loses a life this number is changed. also while blitz is using his melee he moves 50 hu's less
		//rocket launcher stuff
		fl_rocket_firerate[npc.index] = 0.4;	//Base firerate of blitz, overriden once npc takes damage
		fl_rocket_base_dmg[npc.index] = 5.0;	//The base dmg that all scaling is done on
		RaidModeScaling = float(ZR_GetWaveCount()+1);
		
		i_currentwave[npc.index]=(ZR_GetWaveCount()+1);
		
		//wave control	| at which wave or beyond will the life activate | Now that I think about it, this one might just be useless
		i_wave_life1[npc.index] = 15;
		i_wave_life2[npc.index] = 30;
		i_wave_life3[npc.index] = 45;	//fun fact, this just exists, no idea if its used for anything. 
		i_wave_life4[npc.index] = 60;
		
		//i_wave_blitzstorm[npc.index] = 60;	//Blitz storm ability on final wave. | Curently does nothing.
		
		if(RaidModeScaling < 55)
		{
			RaidModeScaling *= 0.16; //abit low, inreacing
		}
		else
		{
			RaidModeScaling *= 0.33;
		}
		
		float amount_of_people = float(CountPlayersOnRed());
		
		if(amount_of_people<8)	//This is to avoid blitz taking so much damage at low player counts that certain abilities just don't trigger
		{
			b_lowplayercount[npc.index]=true;
		}
		else
		{
			b_lowplayercount[npc.index]=false;
		}
		amount_of_people *= 0.12;
		
		if(amount_of_people < 1.0)
			amount_of_people = 1.0;
			
		RaidModeScaling *= amount_of_people; //More then 9 and he raidboss gets some troubles, bufffffffff
		
		Raidboss_Clean_Everyone();
		
		EmitSoundToAll("npc/zombie_poison/pz_alert1.wav", _, _, _, _, 1.0);	
		EmitSoundToAll("npc/zombie_poison/pz_alert1.wav", _, _, _, _, 1.0);	
		
		for(int client_check=1; client_check<=MaxClients; client_check++)
		{
			if(IsClientInGame(client_check) && !IsFakeClient(client_check))
			{
				LookAtTarget(client_check, npc.index);
				SetGlobalTransTarget(client_check);
				ShowGameText(client_check, "voice_player", 1, "%t", "Blitzkrieg Spawn");
			}
		}
		
		for(int client_clear=1; client_clear<=MaxClients; client_clear++)
		{
			fl_AlreadyStrippedMusic[client_clear] = 0.0; //reset to 0
		}
		
		npc.m_flNextRangedBarrage_Spam = GetGameTime(npc.index) + 15.0;	// used for extra rocket spam along side blitz's current rockets
		
		SDKHook(npc.index, SDKHook_Think, Blitzkrieg_ClotThink);
		SDKHook(npc.index, SDKHook_OnTakeDamage, Blitzkrieg_ClotDamaged);
		
		int skin = 5;
		SetEntProp(npc.index, Prop_Send, "m_nSkin", skin);
		
		
		npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/w_models/w_rocketlauncher.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		npc.m_iWearable2 = npc.EquipItem("head", "models/workshop/player/items/medic/Hw2013_Spacemans_Suit/Hw2013_Spacemans_Suit.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		
		npc.m_iWearable3 = npc.EquipItem("head", "models/workshop/player/items/medic/Cardiologists_Camo/Cardiologists_Camo.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable3, "SetModelScale");
		
		npc.m_iWearable4 = npc.EquipItem("head", "models/workshop/player/items/all_class/jogon/jogon_medic.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable4, "SetModelScale");
		
		npc.m_iWearable5 = npc.EquipItem("head", "models/workshop/player/items/medic/Hw2013_Moon_Boots/Hw2013_Moon_Boots.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable5, "SetModelScale");
		
		SetEntityRenderMode(npc.index, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.index, 125, 100, 100, 255);
		
		SetEntityRenderMode(npc.m_iWearable2, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable2, 125, 100, 100, 255);
		
		SetEntityRenderMode(npc.m_iWearable3, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable3, 55, 30, 30, 255);
		
		SetEntityRenderMode(npc.m_iWearable4, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable4, 255, 0, 0, 255);
		
		SetEntityRenderMode(npc.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable5, 125, 100, 100, 255);
		
		//IDLE
		npc.m_flSpeed = fl_move_speed[npc.index];
		
		npc.m_flMeleeArmor = 1.5;	//Blitz naturaly takes 50% extra melee damge while not using melee.
		
		fl_TheFinalCountdown[npc.index] = 0.0;	//used for timer logic on blitzlight
		fl_TheFinalCountdown2[npc.index] = 0.0;	//used for timer logic on blitzlight
		i_PrimaryRocketsFired[npc.index] = 0;	//Checks how many rockets haave been fired by blitz's RL.
		fl_LifelossReload[npc.index] = 1.0;	//how fast blitz reloads when ammo is depleted, this number multiples a base 10 number. Basically: 10*fl_LifelossReload[npc.index]
		i_maxfirerockets[npc.index] = 20;	//blitz's max ammo, this number changes on lifeloss.
		i_final_nr[npc.index] = 0;	//used for logic in blitzlight, basicaly locks out stuff so it doesn't repeat the ability.
		
		//adjust the "/4.0" to adjust how hard raid scaling happens. however be warned that on high player counts/waves blitz's scaling can scale extremely highly. 
		fl_blitzscale[npc.index] = (RaidModeScaling/4.0)*zr_smallmapbalancemulti.FloatValue;	//Storage for current raidmode scaling to use for calculating blitz's health scaling.
		fl_blitzscale[npc.index] *= 60/i_currentwave[npc.index]; //and now we do extra math to make sure blitz's scaling doesn't go to the moon on later waves.
		
		/*
		Original scaling is divided by 4, the multiplied by the numbers bellow.
		4x	Wave 15, origami scaling x4.
		3x	wave 30, original scaling x3.
		2x  wave 45, original scaling x2. | Asuming wave 45, 6 players. scaling=((7.2/4)*60/45)*(1.0+(1-(Health/MaxHealth))*1.22) | The entire scaling.
		1x	wave 60, orginial.
		*/
		
		b_BlitzLight[npc.index]=false;			//First stage of blitzlight, blocks health scaling.
		b_BlitzLight_used[npc.index]=false;		//Tell's the npc that blitzlight has been used, and blocks it from being used again.
		b_BlitzLight_stop[npc.index]=false;		//Tell's the npc when blitzlight has ended
		b_BlitzLight_sound[npc.index]=false;	//Stops sounds related to blitzlight.
		
		BlitzLight_Duration_notick[npc.index]=GetGameTime(npc.index)+300.0;	//Used to findout the current duration of blitzlight without tick's
		
		i_ExplosiveProjectileHexArray[npc.index] = EP_NO_KNOCKBACK;	//Block's KB from certain abilities. mainly blitzlight
		
		b_final_push[npc.index] = false;			//used for blitzlight logic.
		b_Are_we_reloading[npc.index] = false;		//Tell's the npc that it is indeed reloading and that its a good idea to switch to melee. blocks certain abilities, also is used to block the RJ during blitzlight.
		npc.PlayMusicSound();
		npc.StartPathing();
		Music_Stop_All_Beat(client);
		
		npc.m_flCharge_Duration = 0.0;					//during blitzlight, blitz's teleport gets replaced with a dash.
		npc.m_flCharge_delay = GetGameTime(npc.index) + 2.0;
		
		b_life1[npc.index]=false;	//tell's the npc if 1st life is true.
		b_life2[npc.index]=false;	//tell's the npc if 2nd life is true.
		b_life3[npc.index]=false;	//tell's the npc if 3rd life is true.
		
		b_allies[npc.index]=false;

		Citizen_MiniBossSpawn(npc.index);
	
		return npc;
		
		/*
		Thanks to Spookmaster for allowing me to port over his "Holy Moonlight" that his dokmed raidboss uses.
		*/
	}
}

//TODO 
//Rewrite
public void Blitzkrieg_ClotThink(int iNPC)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(iNPC);

	if(RaidModeTime < GetGameTime())
	{
		int entity = CreateEntityByName("game_round_win"); //You loose.
		DispatchKeyValue(entity, "force_map_reset", "1");
		SetEntProp(entity, Prop_Data, "m_iTeamNum", TFTeam_Blue);
		Music_Stop_All_Blitzkrieg(entity);
		DispatchSpawn(entity);
		AcceptEntityInput(entity, "RoundWin");
		Music_RoundEnd(entity);
		RaidBossActive = INVALID_ENT_REFERENCE;
		SDKUnhook(npc.index, SDKHook_Think, Blitzkrieg_ClotThink);
	}
	
	//SetVariantInt(1);
    //AcceptEntityInput(npc.index, "SetBodyGroup");
	
	if(npc.m_flNextDelayTime > GetGameTime(npc.index))
	{
		return;
	}
	
	npc.m_flNextDelayTime = GetGameTime(npc.index) + DEFAULT_UPDATE_DELAY_FLOAT;
	
	npc.Update();
	
	//Think throttling
	if(npc.m_flNextThinkTime > GetGameTime(npc.index)) {
		return;
	}
	if(npc.m_blPlayHurtAnimation)
	{
		npc.AddGesture("ACT_MP_GESTURE_FLINCH_CHEST", false);
		npc.PlayHurtSound();
		npc.m_blPlayHurtAnimation = false;
	}
	
	npc.m_flNextThinkTime = GetGameTime(npc.index) + 0.10;

	if(npc.m_flGetClosestTargetTime < GetGameTime(npc.index))
	{
		for(int client=1; client<=MaxClients; client++)
		{
			if(IsClientInGame(client))
			{
				if(fl_AlreadyStrippedMusic[client] < GetEngineTime())
				{
					Music_Stop_All(client); //This is actually more expensive then i thought.
				}
				SetMusicTimer(client, GetTime() + 5);
				fl_AlreadyStrippedMusic[client] = GetEngineTime() + 5.0;
			}
		}
		npc.m_iTarget = GetClosestTarget(npc.index);
		npc.m_flGetClosestTargetTime = GetGameTime(npc.index) + 1.0;
	}
	int closest = npc.m_iTarget;
	int PrimaryThreatIndex = npc.m_iTarget;
	float Health = float(GetEntProp(npc.index, Prop_Data, "m_iHealth"));
	float MaxHealth = float(GetEntProp(npc.index, Prop_Data, "m_iMaxHealth"));
	if(IsValidEnemy(npc.index, PrimaryThreatIndex))
	{
		
			float vecTarget[3]; vecTarget = WorldSpaceCenter(PrimaryThreatIndex);
		
			float flDistanceToTarget = GetVectorDistance(vecTarget, WorldSpaceCenter(npc.index), true);
			
			float vPredictedPos[3]; vPredictedPos = PredictSubjectPosition(npc, PrimaryThreatIndex);
			
			//Predict their pos.
			if(flDistanceToTarget < npc.GetLeadRadius()) {
				/*
				int color[4];
				color[0] = 255;
				color[1] = 255;
				color[2] = 0;
				color[3] = 255;
			
				int xd = PrecacheModel("materials/sprites/laserbeam.vmt");
			
				TE_SetupBeamPoints(vPredictedPos, vecTarget, xd, xd, 0, 0, 0.25, 0.5, 0.5, 5, 5.0, color, 30);
				TE_SendToAllInRange(vecTarget, RangeType_Visibility);
				*/
				
				
				
				PF_SetGoalVector(npc.index, vPredictedPos);
			} else {
				PF_SetGoalEntity(npc.index, PrimaryThreatIndex);
			}
			npc.StartPathing();
			
			if(fl_TheFinalCountdown2[npc.index] <= GetGameTime(npc.index) && i_final_nr[npc.index] == 1)	//moved the reset due to the funny clot damaged only being called when damaged
			{	//Resets the npc to a base state after blitzlight is used.
				i_final_nr[npc.index]=5;
				
				if(IsValidEntity(npc.m_iWearable1))
					RemoveEntity(npc.m_iWearable1);
				npc.m_iWearable1 = npc.EquipItem("head", "models/workshop/weapons/c_models/c_atom_launcher/c_atom_launcher.mdl");	//The thing everyone fears, the airstrike.
				SetVariantString("1.0");
				AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
				
				b_Are_we_reloading[npc.index]=false;
				
				npc.m_flReloadIn = GetGameTime(npc.index) + 1.0;
				
				
				fl_move_speed[npc.index] = 300.0;
				
					
				npc.m_flNextTeleport = GetGameTime(npc.index) + 1.0;
				
				i_maxfirerockets[npc.index] = 100;
				
				fl_LifelossReload[npc.index] = 0.3;
				
				npc.m_flRangedArmor = 1.0;
				
				int iActivity = npc.LookupActivity("ACT_MP_RUN_PRIMARY");
				if(iActivity > 0) npc.StartActivity(iActivity);
			}
			//Extra rockets during rocket spam, also envokes ioc if blitz is on 3rd life.
			if(npc.m_flNextRangedBarrage_Spam < GetGameTime(npc.index) && npc.m_flNextRangedBarrage_Singular < GetGameTime(npc.index) && flDistanceToTarget > Pow(110.0, 2.0) && flDistanceToTarget < Pow(500.0, 2.0) && i_NpcCurrentLives[npc.index]>4 && !b_Are_we_reloading[npc.index])
			{	
				EmitSoundToAll("mvm/mvm_cpoint_klaxon.wav");
			 	npc.FaceTowards(vecTarget);
				npc.FaceTowards(vecTarget);
				npc.FireRocket(vPredictedPos, 12.5 * i_HealthScale[npc.index], (300.0*i_HealthScale[npc.index]), "models/weapons/w_models/w_rocket_airstrike/w_rocket_airstrike.mdl", 1.0);
				npc.m_iAmountProjectiles += 1;
				npc.PlayRangedSound();
				npc.AddGesture("ACT_MP_ATTACK_STAND_PRIMARY");
				npc.m_flNextRangedBarrage_Singular = GetGameTime(npc.index) + 0.15 / i_HealthScale[npc.index];
				if (npc.m_iAmountProjectiles >= 10.0 * i_HealthScale[npc.index])
				{
					npc.m_iAmountProjectiles = 0;
					npc.m_flNextRangedBarrage_Spam = GetGameTime(npc.index) + 45.0 / i_HealthScale[npc.index];
					if(i_NpcCurrentLives[npc.index]==2)
					{
						Blitzkrieg_IOC_Invoke(EntIndexToEntRef(npc.index), closest);
					}
				}
			}
			//emits blitzlight attack sound.
			if(BlitzLight_Duration_notick[npc.index] <= GetGameTime(npc.index) && !b_BlitzLight_sound[npc.index])
			{
				EmitSoundToAll(BLITZLIGHT_ATTACK);
				b_BlitzLight_sound[npc.index]=true;
			}
			if(!b_BlitzLight[npc.index])	//this checks if the npc is in blitzlight, if it is use dash instead of teleport.
			{
				if(npc.m_flNextTeleport < GetGameTime(npc.index) && flDistanceToTarget > Pow(125.0, 2.0) && flDistanceToTarget < Pow(500.0, 2.0))
				{
					static float flVel[3];
					GetEntPropVector(closest, Prop_Data, "m_vecVelocity", flVel);
	
					if (flVel[0] >= 190.0)
					{
						npc.FaceTowards(vecTarget);
						npc.FaceTowards(vecTarget);
						npc.m_flNextTeleport = GetGameTime(npc.index) + 30.0;
						float Tele_Check = GetVectorDistance(vPredictedPos, vecTarget);
						
						if(Tele_Check > 120.0)
						{
							TeleportEntity(npc.index, vPredictedPos, NULL_VECTOR, NULL_VECTOR);
							npc.PlayTeleportSound();
						}
					}
				}
			}
			else
			{
				npc.m_flSpeed=fl_move_speed[npc.index];
				if(npc.m_flCharge_Duration < GetGameTime(npc.index))
				{
					if(npc.m_flCharge_delay < GetGameTime(npc.index))
					{
						int Enemy_I_See;
						Enemy_I_See = Can_I_See_Enemy(npc.index, PrimaryThreatIndex);
						//Target close enough to hit
						if(IsValidEnemy(npc.index, Enemy_I_See) && Enemy_I_See == PrimaryThreatIndex && flDistanceToTarget > 10000 && flDistanceToTarget < 1000000)
						{
							npc.m_flCharge_delay = GetGameTime(npc.index) + 7.5;
							npc.m_flCharge_Duration = GetGameTime(npc.index) + 1.0;
							PluginBot_Jump(npc.index, vecTarget);
						}
					}
				}
				else
				{
					npc.m_flSpeed=325.0;
				}
			}
			if(i_PrimaryRocketsFired[npc.index] > i_maxfirerockets[npc.index])	//Every x rockets npc enters a 10 second reload time that scales on lifeloss reload.
			{
				npc.AddGesture("ACT_MP_RELOAD_STAND_PRIMARY");
				npc.m_flReloadIn = GetGameTime(npc.index) + (10.0 * fl_LifelossReload[npc.index]);
				npc.m_flMeleeArmor = 1.0;
				i_PrimaryRocketsFired[npc.index] = 0;	//Resets fired rockets to 0 for when reload ends.
				b_Are_we_reloading[npc.index] = true;
				if(IsValidEntity(npc.m_iWearable1))
					RemoveEntity(npc.m_iWearable1);
				npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_ubersaw/c_ubersaw.mdl");	//Replaces current weapon with uber saw.
				SetVariantString("1.0");
				AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
				int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE");	//Sets the correct animation.
				if(iActivity > 0) npc.StartActivity(iActivity);
			}
			if(npc.m_flReloadIn <= GetGameTime(npc.index) && b_Are_we_reloading[npc.index])	//fast1
			{	//this whole mess is used to make sure that blitz gets the correct rocket launcher after reload.
				b_Are_we_reloading[npc.index] = false;
				int iActivity = npc.LookupActivity("ACT_MP_RUN_PRIMARY");
				if(iActivity > 0) npc.StartActivity(iActivity);
				if(i_NpcCurrentLives[npc.index]==0)
				{
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
					npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/w_models/w_rocketlauncher.mdl");
					SetVariantString("1.0");
					AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
				}
				if(i_NpcCurrentLives[npc.index]==1)
				{
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
					npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_liberty_launcher/c_liberty_launcher.mdl");
					SetVariantString("1.0");
					AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
				}
				if(i_NpcCurrentLives[npc.index]==2)
				{
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
					npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_dumpster_device/c_dumpster_device.mdl");
					SetVariantString("1.0");
					AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
				}
				if(i_NpcCurrentLives[npc.index]>=3 && i_currentwave[npc.index]!=i_wave_life3[npc.index])	//Rocket launcher doesn't spawn for the funny wave 45 last push.
				{
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
					npc.m_iWearable1 = npc.EquipItem("head", "models/workshop/weapons/c_models/c_atom_launcher/c_atom_launcher.mdl");
					SetVariantString("1.0");
					AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
				}
			}
			if(flDistanceToTarget < 10000000 && npc.m_flReloadIn <= GetGameTime(npc.index) && !b_Are_we_reloading[npc.index])
			{	//Blitz has infinite range and moves while firing rockets.
				int Enemy_I_See;
				npc.m_flMeleeArmor = 1.5;
				
				Enemy_I_See = Can_I_See_Enemy(npc.index, PrimaryThreatIndex);
				//Target close enough to hit
				if(IsValidEnemy(npc.index, Enemy_I_See))
				{
					//Look at target so we hit.
					npc.FaceTowards(vecTarget, 1500.0);
					//Can we attack right now?
					if(npc.m_flNextMeleeAttack < GetGameTime(npc.index))
					{
						npc.m_flSpeed = fl_move_speed[npc.index]-50;	//50 speed slower when using rocket launcher
						//Play attack anim
						npc.AddGesture("ACT_MP_ATTACK_STAND_PRIMARY");
						float projectile_speed = 500.0*(1.0+(1-(Health/MaxHealth))*1.5);	//Rocket speed, scales on current health.
						vecTarget = PredictSubjectPositionForProjectiles(npc, PrimaryThreatIndex, projectile_speed);
						npc.PlayMeleeSound();
						npc.FireRocket(vecTarget, fl_rocket_base_dmg[npc.index] * i_HealthScale[npc.index], projectile_speed, "models/weapons/w_models/w_rocket_airstrike/w_rocket_airstrike.mdl", 1.0, EP_NO_KNOCKBACK); //remove the no kb if people cant escape, or just lower the dmg
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + fl_rocket_firerate[npc.index];
						i_PrimaryRocketsFired[npc.index]++;	//Adds 1 extra rocket to the shoping list for when we go out shoping in the reload store.
						npc.m_flAttackHappens = 0.0;
					}
				}
				else
				{
					npc.StartPathing();
				}
			}
			else
			{
				npc.StartPathing();
			}
			if(b_Are_we_reloading[npc.index])	//Melee logic for when we are shoping for rockets. aka reloading.
			{
			//Target close enough to hit
			if(flDistanceToTarget < 40000 || npc.m_flAttackHappenswillhappen)
			{
				//Look at target so we hit.
				//npc.FaceTowards(vecTarget, 1000.0);
				
				//Can we attack right now?
				if(npc.m_flNextMeleeAttack < GetGameTime(npc.index) || npc.m_flAttackHappenswillhappen)
				{
					//Play attack ani
					if (!npc.m_flAttackHappenswillhappen)
					{
						npc.m_flSpeed = fl_move_speed[npc.index];
						npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE");
						npc.PlayPullSound();
						npc.m_flAttackHappens = GetGameTime(npc.index)+0.3;
						npc.m_flAttackHappens_bullshit = GetGameTime(npc.index)+0.43;
						npc.m_flAttackHappenswillhappen = true;
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 0.9;
					}
					if (npc.m_flAttackHappens < GetGameTime(npc.index) && npc.m_flAttackHappens_bullshit >= GetGameTime(npc.index) && npc.m_flAttackHappenswillhappen)
					{
						Handle swingTrace;
						npc.FaceTowards(vecTarget, 20000.0);
						if(npc.DoSwingTrace(swingTrace, PrimaryThreatIndex, _, _, _, 1))
						{
							int target = TR_GetEntityIndex(swingTrace);	
						
							float vecHit[3];
							TR_GetEndPosition(vecHit, swingTrace);
							
							if(target > 0) 
							{
								float meleedmg;
								meleedmg = 11.5 * i_HealthScale[npc.index];
								if(target <= MaxClients)
								{
									float Bonus_damage = 1.0;
									int weapon = GetEntPropEnt(target, Prop_Send, "m_hActiveWeapon");
	
									char classname[32];
									GetEntityClassname(weapon, classname, 32);
								
									int weapon_slot = TF2_GetClassnameSlot(classname);
								
									if(weapon_slot != 2 || IsWandWeapon(weapon))
									{
										Bonus_damage = 1.5;
									}
									meleedmg *= Bonus_damage;	//Blitz does 50% less damage to players who hold a melee. blitz also takes base melee damage and not 50% extra
									SDKHooks_TakeDamage(target, npc.index, npc.index, meleedmg, DMG_CLUB, -1, _, vecHit);
								}
								else
								{
									SDKHooks_TakeDamage(target, npc.index, npc.index, meleedmg * 25, DMG_CLUB, -1, _, vecHit);	//this man will obliterate bareny with melee, mark my words.
								}
								
								npc.PlayMeleeHitSound();		
								if(IsValidClient(target))	//This makes the target take knockback if he is ubered.
								{
									if (IsInvuln(target))
									{
										Custom_Knockback(npc.index, target, 450.0);
										TF2_AddCondition(target, TFCond_LostFooting, 0.5);
										TF2_AddCondition(target, TFCond_AirCurrent, 0.5);
									}
									else
									{
										Custom_Knockback(npc.index, target, 225.0);
										TF2_AddCondition(target, TFCond_LostFooting, 0.5);
										TF2_AddCondition(target, TFCond_AirCurrent, 0.5);
									}
								}
								
							
								// Hit sound
								npc.PlayPullSound();
							
							} 
						}
						delete swingTrace;
						npc.m_flAttackHappenswillhappen = false;
					}
					else if (npc.m_flAttackHappens_bullshit < GetGameTime(npc.index) && npc.m_flAttackHappenswillhappen)
					{
						npc.m_flAttackHappenswillhappen = false;
					}
				}
			}
			else
			{
				npc.StartPathing();
			}
		}
	}
	else
	{
		PF_StopPathing(npc.index);
		npc.m_bPathing = false;
		npc.m_flGetClosestTargetTime = 0.0;
		npc.m_iTarget = GetClosestTarget(npc.index);
	}
	
	npc.PlayMusicSound();
	npc.PlayIdleAlertSound();
}

public Action Blitzkrieg_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	//Valid attackers only.	AJA
	if(attacker <= 0)
		return Plugin_Continue;
		
	Blitzkrieg npc = view_as<Blitzkrieg>(victim);
	
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	int closest = npc.m_iTarget;
	
	float Health = float(GetEntProp(npc.index, Prop_Data, "m_iHealth"));
	float MaxHealth = float(GetEntProp(npc.index, Prop_Data, "m_iMaxHealth"));
	
	if(!b_BlitzLight[npc.index])	//Blocks scaling if blitzlight is active
	{	//Blitz's power scales off of current health. the health scaling is dependant on current stage, 1 stage being 15 waves.
		if(i_currentwave[npc.index]<=15)
		{
			RaidModeScaling= fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth)));
			i_HealthScale[npc.index]=fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth)));
			fl_rocket_firerate[npc.index]=((Health/MaxHealth)-0.4)/zr_smallmapbalancemulti.FloatValue;
			if(fl_rocket_firerate[npc.index]<=0.3)//This limits the firerate of the npc.
			{
				fl_rocket_firerate[npc.index]=0.3;
			}
		}
		if(i_currentwave[npc.index]<=30 && i_currentwave[npc.index]>15)	//waves 16-30 he scales with this
		{
			RaidModeScaling= fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth))*1.1);
			i_HealthScale[npc.index]=fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth))*1.1);
			fl_rocket_firerate[npc.index]=((Health/MaxHealth)-0.5)/zr_smallmapbalancemulti.FloatValue;
			if(fl_rocket_firerate[npc.index]<=0.25)//This limits the firerate of the npc.
			{
				fl_rocket_firerate[npc.index]=0.25;
			}
		}
		if(i_currentwave[npc.index]<=45 && i_currentwave[npc.index]>30)//waves 31-45 he scales with this
		{
			RaidModeScaling= fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth))*1.22);
			i_HealthScale[npc.index]=fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth))*1.22);
			fl_rocket_firerate[npc.index]=((Health/MaxHealth)-0.75)/zr_smallmapbalancemulti.FloatValue;
			if(fl_rocket_firerate[npc.index]<=0.075)//This limits the firerate of the npc.
			{
				fl_rocket_firerate[npc.index]=0.075;
			}
		}
		if(i_currentwave[npc.index]>=60)	//beyond wave 60 he scales with this
		{
			RaidModeScaling= fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth))*1.3);
			i_HealthScale[npc.index]=fl_blitzscale[npc.index]*(1.0+(1-(Health/MaxHealth))*1.3);
			fl_rocket_firerate[npc.index]=((Health/MaxHealth)-0.85)/zr_smallmapbalancemulti.FloatValue;
			if(fl_rocket_firerate[npc.index]<=0.01)	//This limits the firerate of the npc. In this case its used to make sure it doesn't go negative or not to reach server crashing levels of firerate.
			{
				fl_rocket_firerate[npc.index]=0.01;
			}
		}
	}
	
	  //////////////////////
	 ///Blitzkrieg Lives///
	//////////////////////
	
	//Blitzkrieg uses lives to buff and to change rocket launchers and for other abilities.
	
	if(Health/MaxHealth>0.5 && Health/MaxHealth<0.75 && !b_life1[npc.index] && i_currentwave[npc.index]>=i_wave_life1[npc.index])	//Lifelosses
	{	//75%-50%
		i_NpcCurrentLives[npc.index]=1;
		b_life1[npc.index]=true;
		if(IsValidEntity(npc.m_iWearable1))
			RemoveEntity(npc.m_iWearable1);
		npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_liberty_launcher/c_liberty_launcher.mdl");	//Liberty
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		i_maxfirerockets[npc.index] =25;	//Buff's the clipsize
		
		fl_LifelossReload[npc.index] = 0.8;	//Buff's the reload speed.
		
		fl_move_speed[npc.index] = 270.0;	//Buff's movement speed.
		
		//fl_rocket_firerate[npc.index] = 0.3;
		
		npc.m_flReloadIn = GetGameTime(npc.index);	//Forces immediate reload.
		
		b_Are_we_reloading[npc.index]=false;	//Forces immediate reload.
		
		npc.PlayAngerSound();
		npc.DispatchParticleEffect(npc.index, "hightower_explosion", NULL_VECTOR, NULL_VECTOR, NULL_VECTOR, npc.FindAttachment("head"), PATTACH_POINT_FOLLOW, true);
		Blitzkrieg_IOC_Invoke(EntIndexToEntRef(npc.index), closest);
		
		CPrintToChatAll("{crimson}Blitzkrieg{default}: {yellow}Life: %i!",i_NpcCurrentLives[npc.index]);
		
		if(IsValidClient(closest))//Fancy text for blitz
		{
			switch(GetRandomInt(1, 3))
			{
				case 1:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: This is only just the beginning {yellow}%N {default}!", closest);
				}
				case 2:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: You think this is the end {yellow}%N {default}?", closest);
				}
				case 3:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: You fool {yellow}%N {default}!", closest);
				}
			}
		}
		
		EmitSoundToAll("mvm/mvm_tank_end.wav");	
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_PRIMARY");
		if(iActivity > 0) npc.StartActivity(iActivity);
	}
	else if(Health/MaxHealth<0.5 && !b_life2[npc.index] && i_currentwave[npc.index]>=i_wave_life2[npc.index])
	{	//50%-25% same thing as before.
		i_NpcCurrentLives[npc.index]=2;
		b_life2[npc.index]=true;
		if(IsValidEntity(npc.m_iWearable1))
			RemoveEntity(npc.m_iWearable1);
		
		npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_dumpster_device/c_dumpster_device.mdl");	//Dumpster deive aka beggars
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		b_Are_we_reloading[npc.index]=false;
		
		npc.m_flReloadIn = GetGameTime(npc.index);
		
		i_maxfirerockets[npc.index] =40;
		
		fl_LifelossReload[npc.index] = 0.75;
		
		//fl_rocket_firerate[npc.index] = 0.25;
		
		fl_move_speed[npc.index] = 275.0;
		
		npc.PlayAngerSound();
		npc.DispatchParticleEffect(npc.index, "hightower_explosion", NULL_VECTOR, NULL_VECTOR, NULL_VECTOR, npc.FindAttachment("head"), PATTACH_POINT_FOLLOW, true);
		Blitzkrieg_IOC_Invoke(EntIndexToEntRef(npc.index), closest);
		
		CPrintToChatAll("{crimson}Blitzkrieg{default}: {yellow}Life: %i!",i_NpcCurrentLives[npc.index]);

		if(IsValidClient(closest))
		{
			switch(GetRandomInt(1, 3))
			{
				case 1:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: Don't get too cocky {yellow}%N {default}!", closest);
				}
				case 2:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: The end is near {yellow}%N {default} are you sure you want to proceed?", closest);
				}
				case 3:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: You Imbecil {yellow}%N {default}!", closest);
				}
			}
		}
		
		EmitSoundToAll("mvm/mvm_tank_end.wav");
					
		int iActivity = npc.LookupActivity("ACT_MP_RUN_PRIMARY");
		if(iActivity > 0) npc.StartActivity(iActivity);
	}
	else if(Health/MaxHealth>0.175 && Health/MaxHealth<0.25 && !b_life3[npc.index] && b_life2[npc.index] && i_currentwave[npc.index]>=i_wave_life3[npc.index])
	{	//25%-ded same thing as before.
		i_NpcCurrentLives[npc.index]=3;
		b_life3[npc.index]=true;
		if(IsValidEntity(npc.m_iWearable1))
			RemoveEntity(npc.m_iWearable1);
		npc.m_iWearable1 = npc.EquipItem("head", "models/workshop/weapons/c_models/c_atom_launcher/c_atom_launcher.mdl");	//The thing everyone fears, the airstrike.
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		EmitSoundToAll("mvm/mvm_tank_end.wav");
		
		b_Are_we_reloading[npc.index]=false;
		
		npc.m_flReloadIn = GetGameTime(npc.index);
		
		i_maxfirerockets[npc.index] = 65;
		
		//fl_rocket_firerate[npc.index] = 0.2;
		
		fl_move_speed[npc.index] = 280.0;
		
		CPrintToChatAll("{crimson}Blitzkrieg{default}: {yellow}Life: %i!",i_NpcCurrentLives[npc.index]);
		
		if(IsValidClient(closest))
		{
			switch(GetRandomInt(1, 3))
			{
				case 1:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: Your own foolishness lead you to this {yellow}%N {default} prepare for complete {red} BLITZKRIEG", closest);
				}
				case 2:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: The end is {red} here {yellow}%N {default} time for you to learn what {red} BLITZKRIEG {default} means", closest);
				}
				case 3:
				{
					CPrintToChatAll("{crimson}Blitzkrieg{default}: You've gone and done it {red} ITS TIME TO DIE {yellow}%N {red} PREPARE FOR FULL BLITZKRIEG", closest);
				}
			}
		}
		
		fl_LifelossReload[npc.index] = 0.65;
		
		npc.PlayAngerSound();
		npc.DispatchParticleEffect(npc.index, "hightower_explosion", NULL_VECTOR, NULL_VECTOR, NULL_VECTOR, npc.FindAttachment("head"), PATTACH_POINT_FOLLOW, true);
		Blitzkrieg_IOC_Invoke(EntIndexToEntRef(npc.index), closest);
					
		int iActivity = npc.LookupActivity("ACT_MP_RUN_PRIMARY");
		if(iActivity > 0) npc.StartActivity(iActivity);
	} 
	if(((Health/MaxHealth>0 && Health/MaxHealth<0.175) || (Health/MaxHealth<=0.2 && b_lowplayercount[npc.index])) && i_currentwave[npc.index]>=i_wave_life3[npc.index] && !b_final_push[npc.index])
	{	//If server count is above 8 this will actiavte on 17.5% hp, however since on low player counts blitz's hp is low enough for players with insane single target damage to just avoid this ability, so to prevent that this ability is activated on 24% hp.
		
		EmitSoundToAll("mvm/mvm_tank_horn.wav");
		
		b_final_push[npc.index] = true;	//Tells the npc that its begun.
		
		i_final_nr[npc.index]=1;	//logic stuff.
		
		fl_move_speed[npc.index] = 300.0;	//Sets npc's speed to a higher value, still should be lower than a player who is running away without looking at the npc
		
		if(IsValidEntity(npc.m_iWearable1))
			RemoveEntity(npc.m_iWearable1);
		npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_ubersaw/c_ubersaw.mdl");	//he becomes melee.
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		CPrintToChatAll("{crimson}Blitzkrieg{default}: {crimson}I AM A GOD");	//Ego boost 9000%
		
		b_Are_we_reloading[npc.index]=true;
		
		npc.m_flReloadIn = GetGameTime(npc.index);
		
		float charge=6.0;	//Charge time of blitzlight MUST be set here
		float timer=20.0;	//Duration of blitzlight MUST be set here
		fl_TheFinalCountdown2[npc.index] = GetGameTime(npc.index)+timer+charge+1.0;	//Duration of the whole thing. should be the same number as duration of blitzlight invoke
		BlitzLight_Invoke(npc.index, closest, timer, charge);	//timer is duration, charge is charge time. || Blitzlight invoke, thanks to spooks permission I ported the ability over for blitz
		b_BlitzLight[npc.index]=true;						//Blitzlight logic, blocks scaling, blocks other things.
		b_BlitzLight_used[npc.index]=true;					//Tells the npc that yes, blitzlight has been used, go ham.
		
		
		npc.m_flNextTeleport = GetGameTime(npc.index) + 10.0;	//This value gets change on reset.
		
		fl_LifelossReload[npc.index] = 1.0;				//Used to make sure npc is in melee.
		
		npc.m_flReloadIn = GetGameTime(npc.index) + (timer+charge+1.0);	//turns off melee logic when blitzlight ends.
		
		npc.m_flRangedArmor = 0.1;	//Sets ranged armour to 90%, however melee still does normal damage, so if somehow is mad enough as melee to duel blitz in this state, they are free to do so.
					
		int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE");
		if(iActivity > 0) npc.StartActivity(iActivity);
	}
	if(i_currentwave[npc.index]>=45 && !b_allies[npc.index] && (b_life2[npc.index] || b_life3[npc.index]))
	{	//This system is used to spawn minnions depending on wave and life. Also almost everything here is hard coded to waves meaning they won't on other waves.
		b_allies[npc.index]=true;
		float pos[3]; GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", pos);
		float ang[3]; GetEntPropVector(npc.index, Prop_Data, "m_angRotation", ang);
		if(i_currentwave[npc.index]==45)
		{
			CPrintToChatAll("{crimson}Blitzkrieg{default}: The brothers have joined the battle.");
		}
		int dahp = GetEntProp(npc.index, Prop_Data, "m_iMaxHealth");
		float maxhealth = 1.0*dahp;
		float heck;
		int spawn_index;
		heck= maxhealth;
		maxhealth=(heck/10)*zr_smallmapbalancemulti.FloatValue;
		spawn_index = Npc_Create(ALT_MEDIC_SUPPERIOR_MAGE, -1, pos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
		if(spawn_index > MaxClients)	//Currently always spawns.
		{
		
			SetEntProp(spawn_index, Prop_Data, "m_iHealth", maxhealth);
			SetEntProp(spawn_index, Prop_Data, "m_iMaxHealth", maxhealth);
		}
		if(i_currentwave[npc.index]==45)	//Only spwans if the wave is 45.
		{
			spawn_index = Npc_Create(ALT_COMBINE_DEUTSCH_RITTER, -1, pos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
			if(spawn_index > MaxClients)
			{
				SetEntProp(spawn_index, Prop_Data, "m_iHealth", maxhealth);
				SetEntProp(spawn_index, Prop_Data, "m_iMaxHealth", maxhealth);
			}
		}
		if(i_currentwave[npc.index]>=60)	//Only spawns if the wave is 60 or beyond.
		{
			CPrintToChatAll("{crimson}Blitzkrieg{default}: The brothers have been reborn.");
			maxhealth=(heck/5)*zr_smallmapbalancemulti.FloatValue;	//mid squishy
			spawn_index = Npc_Create(ALT_DONNERKRIEG, -1, pos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
			if(spawn_index > MaxClients)
			{
				CPrintToChatAll("{crimson}Blitzkrieg{default}: Ay, Donnerkrieg, how ya doin?");
				SetEntProp(spawn_index, Prop_Data, "m_iHealth", maxhealth);
				SetEntProp(spawn_index, Prop_Data, "m_iMaxHealth", maxhealth);
			}
			maxhealth=(heck/2)*zr_smallmapbalancemulti.FloatValue;	//the tankiest
			spawn_index = Npc_Create(ALT_SCHWERTKRIEG, -1, pos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
			if(spawn_index > MaxClients)
			{
				SetEntProp(spawn_index, Prop_Data, "m_iHealth", maxhealth);
				SetEntProp(spawn_index, Prop_Data, "m_iMaxHealth", maxhealth);
			}
		}
	}
	return Plugin_Changed;
}

public void Blitzkrieg_NPCDeath(int entity)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(entity);
	npc.PlayDeathSound();
	Music_Stop_All_Blitzkrieg(entity);
	SDKUnhook(npc.index, SDKHook_Think, Blitzkrieg_ClotThink);
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, Blitzkrieg_ClotDamaged);
//	Music_RoundEnd(entity);
	
	int closest = npc.m_iTarget;
	
	RaidBossActive = INVALID_ENT_REFERENCE;
	
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
	if(IsValidEntity(npc.m_iWearable4))
		RemoveEntity(npc.m_iWearable4);
	if(IsValidEntity(npc.m_iWearable5))
		RemoveEntity(npc.m_iWearable5);
		
	if(IsValidClient(closest))
	{
		switch(GetRandomInt(1, 3))
		{
			case 1:
			{
				CPrintToChatAll("{crimson}Blitzkrieg{default}: Noooo, this cannot be {yellow}%N {default} you won, {red}this time", closest);
			}
			case 2:
			{
				CPrintToChatAll("{crimson}Blitzkrieg{default}: It seems I have failed {yellow}%N {default} you were far supperior than me {red}this time", closest);
			}
			case 3:
			{
				CPrintToChatAll("{crimson}Blitzkrieg{default}: Until next time {yellow}%N {red} until next time...", closest);
			}
		}
	}
//	AcceptEntityInput(npc.index, "KillHierarchy");
//	npc.Anger = false;

	Citizen_MiniBossDeath(entity);
}
// Ent_Create style position from Doomsday Nuke

public void Blitzkrieg_IOC_Invoke(int ref, int enemy)	//Ion cannon from above
{
	int entity = EntRefToEntIndex(ref);
	if(IsValidEntity(entity))
	{
		static float distance=125.0; // /29 for duartion till boom
		static float IOCDist=250.0;
		static float IOCdamage=100.0;
		
		float vecTarget[3];
		vecTarget = WorldSpaceCenter(enemy);
		vecTarget[2] -= 54.0;
		
		Handle data = CreateDataPack();
		WritePackFloat(data, vecTarget[0]);
		WritePackFloat(data, vecTarget[1]);
		WritePackFloat(data, vecTarget[2]);
		WritePackCell(data, distance); // Distance
		WritePackFloat(data, 0.0); // nphi
		WritePackCell(data, IOCDist); // Range
		WritePackCell(data, IOCdamage); // Damge
		WritePackCell(data, ref);
		ResetPack(data);
		Blitzkrieg_IonAttack(data);
	}
}
public Action Blitzkrieg_DrawIon(Handle Timer, any data)
{
	Blitzkrieg_IonAttack(data);
		
	return (Plugin_Stop);
}
	
public void Blitzkrieg_DrawIonBeam(float startPosition[3], const int color[4])
{
	float position[3];
	position[0] = startPosition[0];
	position[1] = startPosition[1];
	position[2] = startPosition[2] + 3000.0;	
	
	TE_SetupBeamPoints(startPosition, position, gLaser1, 0, 0, 0, 0.15, 25.0, 25.0, 0, 1.0, color, 3 );
	TE_SendToAll();
	position[2] -= 1490.0;
	TE_SetupGlowSprite(startPosition, gGlow1, 1.0, 1.0, 255);
	TE_SendToAll();
}

	public void Blitzkrieg_IonAttack(Handle &data)
	{
		float startPosition[3];
		float position[3];
		startPosition[0] = ReadPackFloat(data);
		startPosition[1] = ReadPackFloat(data);
		startPosition[2] = ReadPackFloat(data);
		float Iondistance = ReadPackCell(data);
		float nphi = ReadPackFloat(data);
		int Ionrange = ReadPackCell(data);
		int Iondamage = ReadPackCell(data);
		int client = EntRefToEntIndex(ReadPackCell(data));
		
		if(!IsValidEntity(client))
		{
			return;
		}
		
		if (Iondistance > 0)
		{
			EmitSoundToAll("ambient/energy/weld1.wav", 0, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, startPosition);
			
			// Stage 1
			float s=Sine(nphi/360*6.28)*Iondistance;
			float c=Cosine(nphi/360*6.28)*Iondistance;
			
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[2] = startPosition[2];
			
			position[0] += s;
			position[1] += c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
	
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[0] -= s;
			position[1] -= c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
			
			// Stage 2
			s=Sine((nphi+45.0)/360*6.28)*Iondistance;
			c=Cosine((nphi+45.0)/360*6.28)*Iondistance;
			
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[0] += s;
			position[1] += c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
			
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[0] -= s;
			position[1] -= c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
			
			// Stage 3
			s=Sine((nphi+90.0)/360*6.28)*Iondistance;
			c=Cosine((nphi+90.0)/360*6.28)*Iondistance;
			
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[0] += s;
			position[1] += c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
			
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[0] -= s;
			position[1] -= c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
			
			// Stage 3
			s=Sine((nphi+135.0)/360*6.28)*Iondistance;
			c=Cosine((nphi+135.0)/360*6.28)*Iondistance;
			
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[0] += s;
			position[1] += c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
			
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[0] -= s;
			position[1] -= c;
			Blitzkrieg_DrawIonBeam(position, {145, 47, 47, 255});
	
			if (nphi >= 360)
				nphi = 0.0;
			else
				nphi += 5.0;
		}
		Iondistance -= 10;
		
		Handle nData = CreateDataPack();
		WritePackFloat(nData, startPosition[0]);
		WritePackFloat(nData, startPosition[1]);
		WritePackFloat(nData, startPosition[2]);
		WritePackCell(nData, Iondistance);
		WritePackFloat(nData, nphi);
		WritePackCell(nData, Ionrange);
		WritePackCell(nData, Iondamage);
		WritePackCell(nData, EntIndexToEntRef(client));
		ResetPack(nData);
		
		if (Iondistance > -30)
		CreateTimer(0.1, Blitzkrieg_DrawIon, nData, TIMER_FLAG_NO_MAPCHANGE|TIMER_DATA_HNDL_CLOSE);
		else	//Normal Ioc Damge on wave
		{
			int gama=ZR_GetWaveCount()+1;
			float alpha=1.0;
			if(gama==15)
			{
				alpha=1.0;
			}
			else if(gama==30)
			{
				alpha=1.75;
			}
			else if(gama==45)
			{
				alpha=2.25;
			}
			else if(gama==60)
			{
				alpha=2.75;
			}
			
			makeexplosion(client, client, startPosition, "", RoundToCeil((225*alpha)*zr_smallmapbalancemulti.FloatValue), 350);
				
			TE_SetupExplosion(startPosition, gExplosive1, 10.0, 1, 0, 0, 0);
			TE_SendToAll();
			position[0] = startPosition[0];
			position[1] = startPosition[1];
			position[2] += startPosition[2] + 900.0;
			startPosition[2] += -200;
			TE_SetupBeamPoints(startPosition, position, gLaser1, 0, 0, 0, 2.0, 30.0, 30.0, 0, 1.0, {145, 47, 47, 255}, 3);
			TE_SendToAll();
			TE_SetupBeamPoints(startPosition, position, gLaser1, 0, 0, 0, 2.0, 50.0, 50.0, 0, 1.0, {145, 47, 47, 255}, 3);
			TE_SendToAll();
			TE_SetupBeamPoints(startPosition, position, gLaser1, 0, 0, 0, 2.0, 80.0, 80.0, 0, 1.0, {145, 47, 47, 255}, 3);
			TE_SendToAll();
			TE_SetupBeamPoints(startPosition, position, gLaser1, 0, 0, 0, 2.0, 100.0, 100.0, 0, 1.0, {145, 47, 47, 255}, 3);
			TE_SendToAll();
	
			position[2] = startPosition[2] + 50.0;
			//new Float:fDirection[3] = {-90.0,0.0,0.0};
			//env_shooter(fDirection, 25.0, 0.1, fDirection, 800.0, 120.0, 120.0, position, "models/props_wasteland/rockgranite03b.mdl");
	
			//env_shake(startPosition, 120.0, 10000.0, 15.0, 250.0);
			
			// Sound
			EmitSoundToAll("ambient/explosions/explode_9.wav", 0, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, startPosition);
	
			// Blend
			//sendfademsg(0, 10, 200, FFADE_OUT, 255, 255, 255, 150);
			
			// Knockback
	/*		float vReturn[3];
			float vClientPosition[3];
			float dist;
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
				{	
					GetClientEyePosition(i, vClientPosition);
	
					dist = GetVectorDistance(vClientPosition, position, false);
					if (dist < Ionrange)
					{
						MakeVectorFromPoints(position, vClientPosition, vReturn);
						NormalizeVector(vReturn, vReturn);
						ScaleVector(vReturn, 10000.0 - dist*10);
	
						TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, vReturn);
					}
				}
			}
*/
		}
}

void Music_Stop_All_Blitzkrieg(int entity)
{
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#ui/gamestartup12.mp3");
}
void Music_Stop_All_Beat(int entity)
{
	StopSound(entity, SNDCHAN_AUTO, "#zombiesurvival/beats/defaultzombiev2/10.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#zombiesurvival/beats/defaultzombiev2/10.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#zombiesurvival/beats/defaultzombiev2/10.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#zombiesurvival/beats/defaultzombiev2/10.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#zombiesurvival/beats/defaultzombiev2/10.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#zombiesurvival/beats/defaultzombiev2/10.mp3");
	StopSound(entity, SNDCHAN_AUTO, "#zombiesurvival/beats/defaultzombiev2/10.mp3");
}



  /////////////////////
 ///BlitzLight Core///
/////////////////////

static float tickCountScaling[MAXENTITIES];
static float tickCountClient[MAXENTITIES];
public Action BlitzLight_TBB_Tick(int client)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(client);
	if(fl_BlitzLight_Throttle[npc.index] < GetGameTime(npc.index))
	{
		fl_BlitzLight_Throttle[npc.index]=GetGameTime(npc.index) + 0.04;
		if(!IsValidEntity(client) || b_BlitzLight_stop[npc.index])
		{
			tickCountClient[npc.index] = 0.0;
			tickCountScaling[npc.index] = 0.0;
			SDKUnhook(client, SDKHook_Think, BlitzLight_TBB_Tick);
			b_BlitzLight[npc.index] = false;
		}
		
		int entity = EntRefToEntIndex(npc.index);
		if(IsValidEntity(entity))
		{
			if (BlitzLight_Duration_notick[npc.index] > GetGameTime(npc.index))	//If current active time is more than charge, then its "charging"
			{
				BlitzLight_Beams(entity, true);
			}
			else
			{	//Range and damage scales on duration
				if(tickCountScaling[npc.index]<(BlitzLight_ChargeTime[npc.index]*66))
				{
					BlitzLight_DMG[npc.index]=BlitzLight_DMG_Base[npc.index]*(1.0+(tickCountScaling[npc.index]/(BlitzLight_ChargeTime[npc.index]*66)));				//damage scales on duration.
					BlitzLight_DMG_Radius[npc.index]=BlitzLight_Radius[npc.index]*(1.0+(tickCountScaling[npc.index]/(BlitzLight_ChargeTime[npc.index]*66))*2.5);
					tickCountScaling[npc.index]++;
				}
				BlitzLight_Beams(entity, false);
			}
		}
	}
	tickCountClient[npc.index]++;
	
	return Plugin_Continue;

}
public void BlitzLight_Invoke(int ref, int enemy, float timer, float charge)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(ref);
	int entity = EntRefToEntIndex(ref);
	if(IsValidEntity(entity))
	{
		float vecTarget[3];
		GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", vecTarget);
		
		float smallmap = zr_smallmapbalancemulti.FloatValue;	//Nerf's blitzlight on small maps. this is set in another plugin from this one
		BlitzLight_Duration[npc.index] = timer*smallmap;
		BlitzLight_ChargeTime[npc.index] = charge;
		BlitzLight_Scale1[npc.index] = 200.0*smallmap;	//Best to do the scales in sets of numbers.
		BlitzLight_Scale2[npc.index] = 400.0*smallmap;
		BlitzLight_Scale3[npc.index] = 600.0*smallmap;
		BlitzLight_DMG_Base[npc.index] = 40.0*smallmap;	//dmg is multiplied by duration, half duration is 1.5, near end of duration its almost 2x. it also does dmg 2 times a second.
		BlitzLight_Radius[npc.index] = 200.0*smallmap;	//Best to set radius as the same different of numbers when going up from scale 1, to 2. in this case scale goes up by 200 each time, so radius is 200.
		BlitzLight_Duration_notick[npc.index] = GetGameTime(npc.index) + charge;	//Charge time.
		
		float time=BlitzLight_Duration[npc.index]+charge;	//Another value in a temp timer.
		BlitzLight_Duration[npc.index]*=66.0;	//Converts the duration into ticks
		
		BlitzLight_Scale2_timer[npc.index]=GetGameTime(npc.index)+(timer/3)+charge;	//makes it so the 3 beam rings spawn in 3 seperate times.
		BlitzLight_Scale3_timer[npc.index]=GetGameTime(npc.index)+((timer/3)*2)+charge;
		
		EmitSoundToAll(BLITZLIGHT_ACTIVATE);
		
		CreateTimer(time, BlitzLight_TBB_Timer, ref, TIMER_FLAG_NO_MAPCHANGE);
		SDKHook(ref, SDKHook_Think, BlitzLight_TBB_Tick);
		
		//Most of the stuff after this point is mostly spook's code, just ported for zr, so I have very little idea how to best explain it.
	}
	
}
public Action BlitzLight_TBB_Timer(Handle timer, int client)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(client);
	if(!IsValidEntity(client))
		return Plugin_Continue;

	b_BlitzLight_stop[npc.index] = true;
	
	StopSound(client, SNDCHAN_STATIC, "weapons/physcannon/energy_sing_loop4.wav");
	StopSound(client, SNDCHAN_STATIC, "weapons/physcannon/energy_sing_loop4.wav");
	StopSound(client, SNDCHAN_STATIC, "weapons/physcannon/energy_sing_loop4.wav");
	EmitSoundToAll("weapons/physcannon/physcannon_drop.wav", client, SNDCHAN_STATIC, 80, _, 1.0);
	
	return Plugin_Continue;
}

void BlitzLight_Beams(int entity, bool charging = true)
{
	
	Blitzkrieg npc = view_as<Blitzkrieg>(entity);
	if (!IsValidEntity(entity) || !b_BlitzLight[npc.index])
		return;
		
	float UserLoc[3], UserAng[3];
	UserLoc = GetAbsOrigin(entity);
	
	UserAng[0] = 0.0;
	UserAng[1] = BlitzLight_Angle[npc.index];
	UserAng[2] = 0.0;
	
	if (charging)
	{
		BlitzLight_Angle[npc.index] += 2.5;
	}
	else
	{
		BlitzLight_Angle[npc.index] += 1.25;
	}
	
	if (BlitzLight_Angle[npc.index] >= 360.0)
	{
		BlitzLight_Angle[npc.index] = 0.0;
	}
	
	for (int i = 0; i < 3; i++)
	{
		float distance = 0.0;
		float angMult = 1.0;
		
		switch(i)
		{
			case 0:
			{
				distance = BlitzLight_Scale1[npc.index];
			}
			case 1:
			{
				if(BlitzLight_Scale2_timer[npc.index]<GetGameTime(npc.index))
				{
					distance = BlitzLight_Scale2[npc.index];
					angMult = -1.0;
				}
			}
			case 2:
			{
				if(BlitzLight_Scale3_timer[npc.index]<GetGameTime(npc.index))
				{
					distance = BlitzLight_Scale3[npc.index];
					angMult = 1.0;
				}
			}
		}
		
		for (int j = 0; j < 8; j++)
		{
			float tempAngles[3], endLoc[3], Direction[3];
			tempAngles[0] = 0.0;
			tempAngles[1] = angMult * (UserAng[1] + (float(j) * 45.0));
			tempAngles[2] = 0.0;
			
			GetAngleVectors(tempAngles, Direction, NULL_VECTOR, NULL_VECTOR);
			ScaleVector(Direction, distance);
			AddVectors(UserLoc, Direction, endLoc);
			
			if (charging)
			{
				BlitzLight_Spawn8(endLoc, BlitzLight_Radius[npc.index], entity);
			}
			else
			{
				BlitzLight_SpawnBeam(entity, false, endLoc);
			}
		}
	}
}

public void BlitzLight_Spawn8(float startLoc[3], float space, int entity)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(entity);
	float ticks = (tickCountClient[npc.index] / BlitzLight_Duration[npc.index]);
	for (int i = 0; i < 8; i++)
	{
		float tempAngles[3], endLoc[3], Direction[3];
		tempAngles[0] = 0.0;
		tempAngles[1] = float(i) * 45.0;
		tempAngles[2] = 0.0;
			
		GetAngleVectors(tempAngles, Direction, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(Direction, space);
		AddVectors(startLoc, Direction, endLoc);
		BlitzLight_SpawnBeam(entity, true, endLoc, ticks);
	}
	int color[4];
	color[0] = 0;
	color[1] = 180;
	color[2] = 60;
	color[3] = RoundFloat(255.0 * ticks);
	
	TE_SetupBeamRingPoint(startLoc, space * 2.0, space * 2.0, BlitzLight_Beam, BlitzLight_Beam, 0, 1, 0.1, 2.0, 0.1, color, 1, 0);
	TE_SendToAll();
}

void BlitzLight_SpawnBeam(int entity, bool charging, float beamLoc[3], float alphaMod = 1.0)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(entity);
	int color[4];
	color[3] = RoundFloat(255.0 * alphaMod);
	
	float skyLoc[3];
	skyLoc[0] = beamLoc[0];
	skyLoc[1] = beamLoc[1];
	skyLoc[2] = 9999.0;
	
	if (charging)
	{
		color[0] = 25;
		color[1] = 205;
		color[2] = 255;
		
		TE_SetupBeamPoints(skyLoc, beamLoc, BlitzLight_Beam, BlitzLight_Beam, 0, 1, 0.1, 2.0, 2.1, 1, 0.1, color, 1);
		TE_SendToAll();
	}
	else
	{
		if (!IsValidEntity(entity))
			return;
		
		color[0] = 145;
		color[1] = 47;
		color[2] = 47;
		
		TE_SetupBeamPoints(skyLoc, beamLoc, BlitzLight_Beam, BlitzLight_Beam, 0, 1, 0.1, 10.0, 10.1, 1, 0.1, color, 1);
		TE_SendToAll();
		TE_SetupBeamRingPoint(beamLoc, 0.0, BlitzLight_Radius[npc.index] * 2.0, BlitzLight_Beam, BlitzLight_Beam, 0, 1, 0.33, 2.0, 0.1, color, 1, 0);
		TE_SendToAll();
		
		BlitzLight_DealDamage(npc.index);
	}
}

static float fl_BlitzLight_dmg_throttle[MAXENTITIES];
public void BlitzLight_DealDamage(int entity)
{
	Blitzkrieg npc = view_as<Blitzkrieg>(entity);
	if (!IsValidEntity(entity))
			return;
	if(fl_BlitzLight_dmg_throttle[npc.index] < GetGameTime(npc.index))
	{
		float beamLoc[3];
		beamLoc = GetAbsOrigin(entity);
		fl_BlitzLight_dmg_throttle[npc.index] = GetGameTime() + 0.5;	//funny throttle due to me being dumb and not knowing to how do damage any other way.
		Explode_Logic_Custom(BlitzLight_DMG[npc.index], entity, entity, -1, beamLoc, BlitzLight_DMG_Radius[npc.index] , _ , _ , true);
		//CPrintToChatAll("dmg: %fl", BlitzLight_DMG[npc.index]);
	//	CPrintToChatAll("radius: %fl", BlitzLight_DMG_Radius[npc.index]);
		
	}
}