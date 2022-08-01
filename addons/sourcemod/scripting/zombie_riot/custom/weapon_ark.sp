//no idea how those work but they are needed from what i see
static float Damage_Projectile[MAXENTITIES]={0.0, ...};
static int Projectile_To_Client[MAXENTITIES]={0, ...};
static int Projectile_To_Particle[MAXENTITIES]={0, ...};
static int Projectile_To_Weapon[MAXENTITIES]={0, ...};
static float RMR_HomingPerSecond[MAXENTITIES];
static int RMR_CurrentHomingTarget[MAXENTITIES];
static bool RMR_CanRetarget[MAXENTITIES]={true, ...};
static bool RMR_HasTargeted[MAXENTITIES];
static int RMR_RocketOwner[MAXENTITIES];
static float RWI_HomeAngle[MAXENTITIES];
static float RWI_LockOnAngle[MAXENTITIES];
static float RMR_RocketVelocity[MAXENTITIES];
static int weapon_id[MAXPLAYERS+1]={0, ...};
static float Original_Atackspeed[MAXPLAYERS+1]={0.0, ...};
static int Ark_Hits[MAXPLAYERS+1]={0, ...};

#define ENERGY_BALL_MODEL	"models/weapons/w_models/w_drg_ball.mdl"
#define SOUND_WAND_SHOT_AUTOAIM 	"weapons/man_melter_fire.wav"
#define SOUND_WAND_SHOT_AUTOAIM_ABILITY	"weapons/man_melter_fire_crit.wav"
#define SOUND_AUTOAIM_IMPACT 		"misc/halloween/spell_lightning_ball_impact.wav"

#define ENERGY_BALL_MODEL	"models/weapons/w_models/w_drg_ball.mdl"
#define SOUND_WAND_SHOT 	"weapons/capper_shoot.wav"
#define SOUND_ZAP "misc/halloween/spell_lightning_ball_impact.wav"


//This shitshow of a weapon is basicly the combination of bad wand/homing wand along with some abilities and a sword

void Ark_autoaim_Map_Precache()
{
	PrecacheSound(SOUND_WAND_SHOT_AUTOAIM);
	PrecacheSound(SOUND_WAND_SHOT_AUTOAIM_ABILITY);
	PrecacheSound(SOUND_AUTOAIM_IMPACT);
	PrecacheModel(ENERGY_BALL_MODEL);
	PrecacheSound(SOUND_WAND_SHOT);
	PrecacheSound(SOUND_ZAP);
}

public void Ark_empower_ability(int client, int weapon, bool crit, int slot) // the main ability used to recover the unique mana needed to for the weapon to fire projectiles
{
	if (Ability_Check_Cooldown(client, slot) < 0.0)
	{
		Ability_Apply_Cooldown(client, slot, 15.0);
		ClientCommand(client, "playgamesound weapons/samurai/tf_katana_draw_02.wav");


		weapon_id[client] = weapon;

		Ark_Hits[client] = 6;
				
		Original_Atackspeed[client] = 1.0;
				
		Address address = TF2Attrib_GetByDefIndex(weapon, 6);
		if(address != Address_Null)
			Original_Atackspeed[client] = TF2Attrib_GetValue(address);
		
		TF2Attrib_SetByDefIndex(weapon, 6, Original_Atackspeed[client] * 0.75);
				
		CreateTimer(3.0, Reset_Ark_Attackspeed, client, TIMER_FLAG_NO_MAPCHANGE);

		//PrintToChatAll("test empower");

	}
	else
	{
		float Ability_CD = Ability_Check_Cooldown(client, slot);
		
		if(Ability_CD <= 0.0)
			Ability_CD = 0.0;
			
		ClientCommand(client, "playgamesound items/medshotno1.wav");
		SetHudTextParams(-1.0, 0.90, 3.01, 34, 139, 34, 255);
		SetGlobalTransTarget(client);
		ShowSyncHudText(client,  SyncHud_Notifaction, "%t", "Ability has cooldown", Ability_CD);
	}
}

public void Ark_attack0(int client, int weapon, bool crit, int slot) // stats for the base version of the weapon
{       
	//PrintToChatAll("test attack");
}
public void Ark_attack1(int client, int weapon, bool crit, int slot) //first pap version
{
	
	if(Ark_Hits[client] >= 1)
	{

		Ark_Hits[client] -= 1;

		float damage = 50.0;
		Address address = TF2Attrib_GetByDefIndex(weapon, 2);
		if(address != Address_Null)
			damage *= TF2Attrib_GetValue(address);
			
		float speed = 2500.0;
		address = TF2Attrib_GetByDefIndex(weapon, 103);
		if(address != Address_Null)
			speed *= TF2Attrib_GetValue(address);
	
		address = TF2Attrib_GetByDefIndex(weapon, 104);
		if(address != Address_Null)
			speed *= TF2Attrib_GetValue(address);
	
		address = TF2Attrib_GetByDefIndex(weapon, 475);
		if(address != Address_Null)
			speed *= TF2Attrib_GetValue(address);
	
	
		float time = 1000.0/speed;
		address = TF2Attrib_GetByDefIndex(weapon, 101);
		if(address != Address_Null)
			time *= TF2Attrib_GetValue(address);
	
		address = TF2Attrib_GetByDefIndex(weapon, 102);
		if(address != Address_Null)
			time *= TF2Attrib_GetValue(address);
		
		int iRot = CreateEntityByName("func_door_rotating");
		if(iRot == -1) return;
	
		float fPos[3];
		GetClientEyePosition(client, fPos);
	
		DispatchKeyValueVector(iRot, "origin", fPos);
		DispatchKeyValue(iRot, "distance", "99999");
		DispatchKeyValueFloat(iRot, "speed", speed);
		DispatchKeyValue(iRot, "spawnflags", "12288"); // passable|silent
		DispatchSpawn(iRot);
		SetEntityCollisionGroup(iRot, 27);
	
		SetVariantString("!activator");
		AcceptEntityInput(iRot, "Open");
		EmitSoundToAll(SOUND_WAND_SHOT, client, _, 65, _, 0.45);
	//	CreateTimer(0.1, Timer_HatThrow_Woosh, EntIndexToEntRef(iRot), TIMER_REPEAT);
		Wand_Launch1(client, iRot, speed, time, damage, weapon);		
	}
}

public void Ark_attack2(int client, int weapon, bool crit, int slot) //second pap version
{

	if(Ark_Hits[client] >= 1)
	{

		Ark_Hits[client] -= 1;

		float damage = 10.0;
		Address address = TF2Attrib_GetByDefIndex(weapon, 2);
		if(address != Address_Null)
			damage *= TF2Attrib_GetValue(address);
			
		float speed = 1100.0;
		address = TF2Attrib_GetByDefIndex(weapon, 103);
		if(address != Address_Null)
			speed *= TF2Attrib_GetValue(address);
	
		address = TF2Attrib_GetByDefIndex(weapon, 104);
		if(address != Address_Null)
			speed *= TF2Attrib_GetValue(address);
	
		address = TF2Attrib_GetByDefIndex(weapon, 475);
		if(address != Address_Null)
			speed *= TF2Attrib_GetValue(address);
	
	
		float time = 500.0/speed;
		address = TF2Attrib_GetByDefIndex(weapon, 101);
		if(address != Address_Null)
			time *= TF2Attrib_GetValue(address);
	
		address = TF2Attrib_GetByDefIndex(weapon, 102);
		if(address != Address_Null)
			time *= TF2Attrib_GetValue(address);
		
		for (new i = 1; i <= 4; i++)
		{
			int iRot = CreateEntityByName("func_door_rotating");
			if(iRot == -1) return;
		
			float fPos[3];
			GetClientEyePosition(client, fPos);
		
			DispatchKeyValueVector(iRot, "origin", fPos);
			DispatchKeyValue(iRot, "distance", "99999");
			DispatchKeyValueFloat(iRot, "speed", speed);
			DispatchKeyValue(iRot, "spawnflags", "12288"); // passable|silent
			DispatchSpawn(iRot);
			SetEntityCollisionGroup(iRot, 27);
		
			SetVariantString("!activator");
			AcceptEntityInput(iRot, "Open");
		//	CreateTimer(0.1, Timer_HatThrow_Woosh, EntIndexToEntRef(iRot), TIMER_REPEAT);
			Wand_Launch2(client, iRot, speed, time, damage, weapon);
		}
		int iRot = CreateEntityByName("func_door_rotating");
		if(iRot == -1) return;
	
		float fPos[3];
		GetClientEyePosition(client, fPos);
	
		DispatchKeyValueVector(iRot, "origin", fPos);
		DispatchKeyValue(iRot, "distance", "99999");
		DispatchKeyValueFloat(iRot, "speed", speed);
		DispatchKeyValue(iRot, "spawnflags", "12288"); // passable|silent
		DispatchSpawn(iRot);
		SetEntityCollisionGroup(iRot, 27);
	
		SetVariantString("!activator");
		AcceptEntityInput(iRot, "Open");
		
		damage = damage * 5;
		
		Wand_Launch1(client, iRot, speed, time, damage, weapon);
	}
}

static void Wand_Launch2(int client, int iRot, float speed, float time, float damage, int weapon) //the projectile from homing wand
{
	float fAng[3], fPos[3];
	GetClientEyeAngles(client, fAng);
	GetClientEyePosition(client, fPos);

	int iCarrier = CreateEntityByName("prop_physics_override");
	if(iCarrier == -1) return;

	float fVel[3], fBuf[3];
	GetAngleVectors(fAng, fBuf, NULL_VECTOR, NULL_VECTOR);
	fVel[0] = fBuf[0]*speed;
	fVel[1] = fBuf[1]*speed;
	fVel[2] = fBuf[2]*speed;

	SetEntPropEnt(iCarrier, Prop_Send, "m_hOwnerEntity", client);
	DispatchKeyValue(iCarrier, "model", ENERGY_BALL_MODEL);
	DispatchKeyValue(iCarrier, "modelscale", "0");
	DispatchSpawn(iCarrier);

	TeleportEntity(iCarrier, fPos, NULL_VECTOR, fVel);
	SetEntityMoveType(iCarrier, MOVETYPE_FLY);
	
	
	SetEntProp(iCarrier, Prop_Send, "m_iTeamNum", GetClientTeam(client));
	SetEntProp(iRot, Prop_Send, "m_iTeamNum", GetClientTeam(client));
	RequestFrame(See_Projectile_Team, EntIndexToEntRef(iCarrier));
	RequestFrame(See_Projectile_Team, EntIndexToEntRef(iRot));
	
	SetVariantString("!activator");
	AcceptEntityInput(iRot, "SetParent", iCarrier, iRot, 0);
	SetEntityCollisionGroup(iCarrier, 27);
	
	Projectile_To_Client[iCarrier] = client;
	Damage_Projectile[iCarrier] = damage;
	Projectile_To_Weapon[iCarrier] = weapon;
	float position[3];
	
	GetEntPropVector(iCarrier, Prop_Data, "m_vecAbsOrigin", position);
	
	int particle = 0;
	
	switch(GetClientTeam(client))
	{
		case 2:
			particle = ParticleEffectAt(position, "unusual_tesla_flash", 5.0);

		default:
			particle = ParticleEffectAt(position, "unusual_tesla_flash", 5.0);
	}
		
	float Angles[3];
	GetClientEyeAngles(client, Angles);
	
	Angles[0] += GetRandomFloat(-5.0, 5.0);
	
	Angles[1] += GetRandomFloat(-5.0, 5.0);
	
	Angles[2] += GetRandomFloat(-5.0, 5.0);
	
	TeleportEntity(particle, NULL_VECTOR, Angles, NULL_VECTOR);
	TeleportEntity(iCarrier, NULL_VECTOR, Angles, NULL_VECTOR);
	TeleportEntity(iRot, NULL_VECTOR, Angles, NULL_VECTOR);
	SetParent(iCarrier, particle);	
	
	CreateTimer(0.1, Ark_Homing_Repeat_Timer, EntIndexToEntRef(iCarrier), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
 //	RMR_NextDeviationAt[iCarrier] = GetGameTime() + 0.4;
	RMR_HomingPerSecond[iCarrier] = 150.0;
	RMR_RocketOwner[iCarrier] = client;
	RMR_HasTargeted[iCarrier] = false;
	RWI_HomeAngle[iCarrier] = 180.0;
	RWI_LockOnAngle[iCarrier] = 180.0;
	RMR_RocketVelocity[iCarrier] = speed;
	RMR_CurrentHomingTarget[iCarrier] = -1;
	
	SetEntityRenderMode(iCarrier, RENDER_TRANSCOLOR);
	SetEntityRenderColor(iCarrier, 0, 0, 0, 0);
		
		
	
	Projectile_To_Particle[iCarrier] = EntIndexToEntRef(particle);
	
	DataPack pack;
	CreateDataTimer(time, Timer_RemoveEntity_CustomProjectile, pack, TIMER_FLAG_NO_MAPCHANGE);
	pack.WriteCell(EntIndexToEntRef(iCarrier));
	pack.WriteCell(EntIndexToEntRef(particle));
	pack.WriteCell(EntIndexToEntRef(iRot));
	
	
	SDKHook(iCarrier, SDKHook_StartTouch, Event_Ark_OnHatTouch);
	
		
	
}

static void Wand_Launch1(int client, int iRot, float speed, float time, float damage, int weapon) //the projectile from bad wand
{
	float fAng[3], fPos[3];
	GetClientEyeAngles(client, fAng);
	GetClientEyePosition(client, fPos);

	int iCarrier = CreateEntityByName("prop_physics_override");
	if(iCarrier == -1) return;

	float fVel[3], fBuf[3];
	GetAngleVectors(fAng, fBuf, NULL_VECTOR, NULL_VECTOR);
	fVel[0] = fBuf[0]*speed;
	fVel[1] = fBuf[1]*speed;
	fVel[2] = fBuf[2]*speed;

	SetEntPropEnt(iCarrier, Prop_Send, "m_hOwnerEntity", client);
	DispatchKeyValue(iCarrier, "model", ENERGY_BALL_MODEL);
	DispatchKeyValue(iCarrier, "modelscale", "0");
	DispatchSpawn(iCarrier);

	TeleportEntity(iCarrier, fPos, NULL_VECTOR, fVel);
	SetEntityMoveType(iCarrier, MOVETYPE_FLY);
	
	SetEntProp(iCarrier, Prop_Send, "m_iTeamNum", GetClientTeam(client));
	SetEntProp(iRot, Prop_Send, "m_iTeamNum", GetClientTeam(client));
	RequestFrame(See_Projectile_Team, EntIndexToEntRef(iCarrier));
	RequestFrame(See_Projectile_Team, EntIndexToEntRef(iRot));
	
	SetVariantString("!activator");
	AcceptEntityInput(iRot, "SetParent", iCarrier, iRot, 0);
	SetEntityCollisionGroup(iCarrier, 27);
	
	Projectile_To_Client[iCarrier] = client;
	Damage_Projectile[iCarrier] = damage;
	
	float position[3];
	
	GetEntPropVector(iCarrier, Prop_Data, "m_vecAbsOrigin", position);
	
	int particle = 0;
	
	
	switch(GetClientTeam(client))
	{
		case 2:
			particle = ParticleEffectAt(position, "drg_cow_rockettrail_normal", 5.0);
	
		default:
			particle = ParticleEffectAt(position, "drg_cow_rockettrail_normal_blue", 5.0);
	}
	
	float Angles[3];
	GetClientEyeAngles(client, Angles);
	TeleportEntity(particle, NULL_VECTOR, Angles, NULL_VECTOR);
	TeleportEntity(iCarrier, NULL_VECTOR, Angles, NULL_VECTOR);
	TeleportEntity(iRot, NULL_VECTOR, Angles, NULL_VECTOR);	
	SetParent(iCarrier, particle);	
	
	Projectile_To_Particle[iCarrier] = EntIndexToEntRef(particle);
	
	SetEntityRenderMode(iCarrier, RENDER_TRANSCOLOR);
	SetEntityRenderColor(iCarrier, 255, 255, 255, 0);
	
	DataPack pack;
	CreateDataTimer(time, Timer_RemoveEntity_CustomProjectile, pack, TIMER_FLAG_NO_MAPCHANGE);
	pack.WriteCell(EntIndexToEntRef(iCarrier));
	pack.WriteCell(EntIndexToEntRef(particle));
	pack.WriteCell(EntIndexToEntRef(iRot));
		
	SDKHook(iCarrier, SDKHook_StartTouch, Event_Ark_OnHatTouch);
}

//Sarysapub1 code but fixed and altered to make it work for our base bosses
#define TARGET_Z_OFFSET 40.0
public Action Ark_Homing_Repeat_Timer(Handle timer, int ref)
{
	int entity = EntRefToEntIndex(ref);
	if(IsValidEntity(entity))
	{
		float deltaTime = 0.1;
					
		if(!IsValidClient(RMR_RocketOwner[entity]))
		{
			RemoveEntity(entity);
			return Plugin_Stop;
		}
		
		// get the angles and mess with them first
		static float rocketAngle[3];
		GetEntPropVector(entity, Prop_Send, "m_angRotation", rocketAngle);
					
		// missile homing
		if (RMR_HomingPerSecond[entity] > 0.0)
		{
			static float targetOrigin[3];
			static float rocketOrigin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", rocketOrigin);
			static float tmpAngles[3];
			static float tmpOrigin[3];
			targetOrigin[2] += TARGET_Z_OFFSET; // target their midsection
			// first, check if the current target is not out of homing range or dead
			if (RMR_CurrentHomingTarget[entity] != -1)
			{
				int target = EntRefToEntIndex(RMR_CurrentHomingTarget[entity]);
					
				if (!RW_IsValidHomingTarget(target, RMR_RocketOwner[entity]))
				{
					RMR_CurrentHomingTarget[entity] = -1;
				}
				else
				{
					GetEntPropVector(target, Prop_Send, "m_vecOrigin", targetOrigin);
					targetOrigin[2] += TARGET_Z_OFFSET; // target their midsection	
								
					// first do a ray trace. if that fails, target lost.
					GetRayAngles(rocketOrigin, targetOrigin, tmpAngles);
					Handle trace = TR_TraceRayFilterEx(rocketOrigin, tmpAngles, (CONTENTS_SOLID | CONTENTS_WINDOW | CONTENTS_GRATE), RayType_Infinite, TraceWallsOnly);
					TR_GetEndPosition(tmpOrigin, trace);
					CloseHandle(trace);
					if (GetVectorDistance(rocketOrigin, targetOrigin, true) > GetVectorDistance(rocketOrigin, tmpOrigin, true))
					{
						RMR_CurrentHomingTarget[entity] = -1;
					}
					else
					{
						// check the angles to ensure the rocket can still "see" the player, which is just a lazy check of pitch and yaw
						// though it's almost always going to be yaw that fails first
						if (!AngleWithinTolerance(rocketAngle, tmpAngles, RWI_HomeAngle[entity]))
						{
							RMR_CurrentHomingTarget[entity] = -1;
							}
					}
				}
			}
				
			// see it homing can be (re)started
			if (RMR_CurrentHomingTarget[entity] == -1 && !(!RMR_CanRetarget[entity] && RMR_HasTargeted[entity]))
			{
				float nearestValidDistance = 9999.0 * 9999.0;
				float testDist = 0.0;
				int nearestValidTarget = -1;
						
				// find the closest target within tolerance
				for(int entitycount_2; entitycount_2<i_MaxcountNpc; entitycount_2++)
				{
					int entity_npc = EntRefToEntIndex(i_ObjectsNpcs[entitycount_2]);
					if (!RW_IsValidHomingTarget(entity_npc, RMR_RocketOwner[entity]))
						continue;
					
					GetEntPropVector(entity_npc, Prop_Send, "m_vecOrigin", targetOrigin);
					targetOrigin[2] += TARGET_Z_OFFSET;
						
					testDist = GetVectorDistance(rocketOrigin, targetOrigin, true);
								
					// least distance so far?
					if (testDist < nearestValidDistance)
					{
						GetRayAngles(rocketOrigin, targetOrigin, tmpAngles);
						Handle trace = TR_TraceRayFilterEx(rocketOrigin, tmpAngles, (CONTENTS_SOLID | CONTENTS_WINDOW | CONTENTS_GRATE), RayType_Infinite, TraceWallsOnly);
						TR_GetEndPosition(tmpOrigin, trace);
						CloseHandle(trace);
										
						// wall test passed?
						if (testDist < GetVectorDistance(rocketOrigin, tmpOrigin, true))
						{
							// angle tolerance passed?
							if (AngleWithinTolerance(rocketAngle, tmpAngles, RWI_LockOnAngle[entity]))
							{
								nearestValidTarget = entity_npc;
								nearestValidDistance = testDist;
							}
							}
					}
				}
							
				// if we've locked on, reflect this
				if (nearestValidTarget != -1)
				{
						RMR_CurrentHomingTarget[entity] = EntIndexToEntRef(nearestValidTarget);
						RMR_HasTargeted[entity] = true;
				}
			}
						
			// now home! tmpAngles is already what we want it to be.
			if (RMR_CurrentHomingTarget[entity] != -1)
			{
					float maxAngleDeviation = deltaTime * RMR_HomingPerSecond[entity];
				
					for (int i = 0; i < 2; i++)
					{
					if (fabs(rocketAngle[i] - tmpAngles[i]) <= RWI_HomeAngle[entity])
						{
						if (rocketAngle[i] - tmpAngles[i] < 0.0)
							rocketAngle[i] += fmin(maxAngleDeviation, tmpAngles[i] - rocketAngle[i]);
						else
							rocketAngle[i] -= fmin(maxAngleDeviation, rocketAngle[i] - tmpAngles[i]);
					}
					else // it wrapped around
					{
						float tmpRocketAngle = rocketAngle[i];
						
						if (rocketAngle[i] - tmpAngles[i] < 0.0)
							tmpRocketAngle += 360.0;
						else
							tmpRocketAngle -= 360.0;
							
						if (tmpRocketAngle - tmpAngles[i] < 0.0)
							rocketAngle[i] += fmin(maxAngleDeviation, tmpAngles[i] - tmpRocketAngle);
						else
							rocketAngle[i] -= fmin(maxAngleDeviation, tmpRocketAngle - tmpAngles[i]);
					}
								
					rocketAngle[i] = fixAngle(rocketAngle[i]);
				}
			}
		
		}
		// now use the old velocity and tweak it to match the int angles
		float vecVelocity[3];
		GetAngleVectors(rocketAngle, vecVelocity, NULL_VECTOR, NULL_VECTOR);
		vecVelocity[0] *= RMR_RocketVelocity[entity];
		vecVelocity[1] *= RMR_RocketVelocity[entity];
		vecVelocity[2] *= RMR_RocketVelocity[entity];
		// apply both changes
		TeleportEntity(entity, NULL_VECTOR, rocketAngle, vecVelocity);
	}
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}	

public Action Event_Ark_OnHatTouch(int entity, int other)// code responsible for doing damage to the enemy
{
	int target = Target_Hit_Wand_Detection(entity, other);
	if (target > 0)	
	{
		//Code to do damage position and ragdolls
		static float angles[3];
		GetEntPropVector(entity, Prop_Send, "m_angRotation", angles);
		float vecForward[3];
		GetAngleVectors(angles, vecForward, NULL_VECTOR, NULL_VECTOR);
		static float Entity_Position[3];
		Entity_Position = WorldSpaceCenter(target);
		//Code to do damage position and ragdolls
		
		SDKHooks_TakeDamage(other, Projectile_To_Client[entity], Projectile_To_Client[entity], Damage_Projectile[entity], DMG_CLUB, -1, CalculateDamageForce(vecForward, 10000.0), Entity_Position);	// 2048 is DMG_NOGIB?
		int particle = EntRefToEntIndex(Projectile_To_Particle[entity]);
		if(IsValidEntity(particle) && particle != 0)
		{
			RemoveEntity(particle);
		}
		RemoveEntity(entity);
	}
	else if(target == 0)
	{
		int particle = EntRefToEntIndex(Projectile_To_Particle[entity]);
		if(IsValidEntity(particle) && particle != 0)
		{
			RemoveEntity(particle);
		}
		RemoveEntity(entity);
	}
	return Plugin_Handled;
}

public Action Reset_Ark_Attackspeed(Handle cut_timer, int client)//code that resets the bonus attack speed from the empower ability
{
	if (IsValidClient(client))
	{
		int weapon = GetPlayerWeaponSlot(client, 2);
		if(weapon == weapon_id[client])
		{
			TF2Attrib_SetByDefIndex(weapon, 6, Original_Atackspeed[client]);
		}
	}
	return Plugin_Handled;
}


//stuff that gets activated upon taking damage
float Player_OnTakeDamage_Ark(int victim, float &damage)
{
	if (Ability_Check_Cooldown(victim, 2) >= 14.0 && Ability_Check_Cooldown(victim, 2) < 16.0)
	{
		//PrintToChatAll("parry worked");
		
		Ark_Hits[victim] = 12;
		ClientCommand(victim, "playgamesound weapons/samurai/tf_katana_impact_object_02.wav");
		return damage * 0.1;
	}
	else 
	{
		 //PrintToChatAll("parry failed");
		return damage;
	}
}