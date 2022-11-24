#pragma semicolon 1
#pragma newdecls required

//Do you think i have time to use the bathroom?
//If you need to sneeze, do it now
#define MAX_TARGETS_HIT_RIOT 10 //Dont hit more then 5.

//same as melee for now. but abit more fat
#define RIOT_MAX_RANGE 150
#define RIOT_MAX_BOUNDS 45.0

static int ShieldModel;
static int ViewmodelRef[MAXTF2PLAYERS] = {INVALID_ENT_REFERENCE, ...};
static int WearableRef[MAXTF2PLAYERS] = {INVALID_ENT_REFERENCE, ...};
static int RIOT_EnemiesHit[MAX_TARGETS_HIT_RIOT];
static float f_TimeSinceLastStunHit[MAXENTITIES];

#define SOUND_RIOTSHIELD_ACTIVATION "weapons/air_burster_explode1.wav"

void Weapon_RiotShield_Map_Precache()
{
	Zero(f_TimeSinceLastStunHit);
	PrecacheSound(SOUND_RIOTSHIELD_ACTIVATION);
	ShieldModel = PrecacheModel("models/player/items/sniper/knife_shield.mdl");
}

public void Weapon_RiotShield_M2(int client, int weapon, bool crit, int slot)
{
	Weapon_RiotShield_M2_Base(client, weapon, crit, slot, 0);
}

public void Weapon_RiotShield_M2_PaP(int client, int weapon, bool crit, int slot)
{
	Weapon_RiotShield_M2_Base(client, weapon, crit, slot, 1);
}

public void Weapon_RiotShield_M2_Base(int client, int weapon, bool crit, int slot, int pap)
{
	if (Ability_Check_Cooldown(client, slot) < 0.0)
	{

		static float hullMin[3]; hullMin = view_as<float>({-RIOT_MAX_BOUNDS, -RIOT_MAX_BOUNDS, -RIOT_MAX_BOUNDS});
		static float hullMax[3]; hullMax = view_as<float>({RIOT_MAX_BOUNDS, RIOT_MAX_BOUNDS, RIOT_MAX_BOUNDS});

		float fPos[3];
		float fAng[3];
		float endPoint[3];
		float fPosForward[3];
		GetClientEyeAngles(client, fAng);
		GetClientEyePosition(client, fPos);
		
		GetAngleVectors(fAng, fPosForward, NULL_VECTOR, NULL_VECTOR);
		
		endPoint[0] = fPos[0] + fPosForward[0] * RIOT_MAX_RANGE;
		endPoint[1] = fPos[1] + fPosForward[1] * RIOT_MAX_RANGE;
		endPoint[2] = fPos[2] + fPosForward[2] * RIOT_MAX_RANGE;

		bool find = false;
		
		for (int enemy_reset = 1; enemy_reset < MAX_TARGETS_HIT_RIOT; enemy_reset++)
		{
			RIOT_EnemiesHit[enemy_reset] = false;
		}

		Handle trace;

		b_LagCompNPC_No_Layers = true;
		StartLagCompensation_Base_Boss(client, false);
		trace = TR_TraceHullFilterEx(fPos, endPoint, hullMin, hullMax, 1073741824, Shield_TraceTargets, client);	// 1073741824 is CONTENTS_LADDER?
		CloseHandle(trace);
		FinishLagCompensation_Base_boss();

		for (int enemy_hit = 0; enemy_hit < MAX_TARGETS_HIT; enemy_hit++)
		{
			if (RIOT_EnemiesHit[enemy_hit])
			{
				if(IsValidEntity(RIOT_EnemiesHit[enemy_hit]))
				{
					find = true;
					float TimeSinceLastStunSubtract;
					TimeSinceLastStunSubtract = f_TimeSinceLastStunHit[RIOT_EnemiesHit[enemy_hit]] - GetGameTime();
					
					if(TimeSinceLastStunSubtract < 0.0)
					{
						TimeSinceLastStunSubtract = 0.0;
					}

					float Duration_ExtraDamage = 2.0;

					float Duration_Stun = 1.0;
					float Duration_Stun_Boss = 0.2;

					if(pap == 1)
					{
						Duration_ExtraDamage = 3.0;
						Duration_Stun = 1.5;
						Duration_Stun_Boss = 0.4;
					}

					f_TargetWasBlitzedByRiotShield[RIOT_EnemiesHit[enemy_hit]][weapon] = GetGameTime() + Duration_ExtraDamage;

					if(!b_thisNpcIsABoss[RIOT_EnemiesHit[enemy_hit]])
					{ 
						f_StunExtraGametimeDuration[RIOT_EnemiesHit[enemy_hit]] += (Duration_Stun - TimeSinceLastStunSubtract);
						fl_NextDelayTime[RIOT_EnemiesHit[enemy_hit]] = GetGameTime() + Duration_Stun - f_StunExtraGametimeDuration[RIOT_EnemiesHit[enemy_hit]];
						f_TankGrabbedStandStill[RIOT_EnemiesHit[enemy_hit]] = GetGameTime() + Duration_Stun - f_StunExtraGametimeDuration[RIOT_EnemiesHit[enemy_hit]];
						f_TimeSinceLastStunHit[RIOT_EnemiesHit[enemy_hit]] = GetGameTime() + Duration_Stun;
					}
					else
					{
						f_StunExtraGametimeDuration[RIOT_EnemiesHit[enemy_hit]] += (Duration_Stun_Boss - TimeSinceLastStunSubtract);
						fl_NextDelayTime[RIOT_EnemiesHit[enemy_hit]] = GetGameTime() + Duration_Stun_Boss - f_StunExtraGametimeDuration[RIOT_EnemiesHit[enemy_hit]];
						f_TankGrabbedStandStill[RIOT_EnemiesHit[enemy_hit]] = GetGameTime() + Duration_Stun_Boss - f_StunExtraGametimeDuration[RIOT_EnemiesHit[enemy_hit]];
						f_TimeSinceLastStunHit[RIOT_EnemiesHit[enemy_hit]] = GetGameTime() + Duration_Stun_Boss;
					}
					//PrintToChatAll("boom! %i",RIOT_EnemiesHit[enemy_hit]);
				}
			}
		}

		/*
		for(int entitycount; entitycount<i_MaxcountNpc; entitycount++)
		{
			int enemy = EntRefToEntIndex(i_ObjectsNpcs[entitycount]);
			if (IsValidEntity(enemy))
			{
                //Make sure that it only affects things that recently hurt you
          	 //  if(f_HowLongAgoDidIHurtThisClient[client][enemy] > GetGameTime() - 1.0)
		   	//Boom!
                {
                    GetEntPropVector(enemy, Prop_Data, "m_vecAbsOrigin", EnemyPos);
                    if (GetVectorDistance(ClientPos, EnemyPos, true) <= Pow(75.0, 2.0))// Are they even close enough?
                    {
                        find = true;
                    }
                }
			}
		}	
		*/

		if(find)
		{
			//Boom! Do effects and buff weapon!

			float Original_Atackspeed = 1.0;

			Address address = TF2Attrib_GetByDefIndex(weapon, 6);
			if(address != Address_Null)
				Original_Atackspeed = TF2Attrib_GetValue(address);
				
			TF2Attrib_SetByDefIndex(weapon, 6, Original_Atackspeed * 0.25); //Make them attack WAY faster.
			EmitSoundToAll(SOUND_RIOTSHIELD_ACTIVATION, client, SNDCHAN_STATIC, 80, _, 0.9);

			float ClientAng[3];
			float ClientPos[3];
			GetAttachment(client, "effect_hand_l", ClientPos, ClientAng);
				
			int particle = ParticleEffectAt(ClientPos, "mvm_loot_dustup2", 0.5);
					
			SetParent(client, particle, "effect_hand_l");
			TeleportEntity(particle, NULL_VECTOR,fAng,NULL_VECTOR);

			CreateTimer(3.0, RiotShieldAbilityEnd_M2, EntIndexToEntRef(weapon), TIMER_FLAG_NO_MAPCHANGE);

			if(pap == 1)
			{
				Ability_Apply_Cooldown(client, slot, 25.0);
			}
			else
			{
				Ability_Apply_Cooldown(client, slot, 35.0);
			}
		}
		else
		{
			//There was no-one to Kapow :(
			ClientCommand(client, "playgamesound items/medshotno1.wav");
		}
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

public void Weapon_RiotShield_Deploy(int client, int weapon)
{
	int entity = CreateEntityByName("prop_dynamic");
	if(entity != -1)
	{
		DispatchKeyValue(entity, "model", "models/player/items/sniper/knife_shield.mdl");
		DispatchKeyValue(entity, "disablereceiveshadows", "0");
		DispatchKeyValue(entity, "disableshadows", "1");
		
		SetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity", client);
		
		float pos[3], ang[3];
		GetClientAbsOrigin(client, pos);
		GetClientAbsAngles(client, ang);
		
		float offset = ang[1];
		if(offset > 90.0)
		{
			offset = 180.0 - offset;
		}
		else if(offset < -90.0)
		{
			offset = -180.0 - offset;
		}
		
		pos[0] -= 15.0 * offset / 90.0;
		pos[1] += 15.0 * (90.0 - fabs(ang[1])) / 90.0;
		pos[2] -= 72.5;
		ang[1] += 180.0;
		ang[2] = 1.5;
		
		TeleportEntity(entity, pos, ang, NULL_VECTOR);
		DispatchSpawn(entity);
		
		SetVariantString("!activator");
		AcceptEntityInput(entity, "SetParent", GetEntPropEnt(client, Prop_Send, "m_hViewModel"));
		
		SDKHook(entity, SDKHook_SetTransmit, FirstPersonTransmit);

		ViewmodelRef[client] = EntIndexToEntRef(entity);
		
		entity = CreateEntityByName("tf_wearable");
		if(entity != -1)
		{
			SetEntProp(entity, Prop_Send, "m_nModelIndex", ShieldModel);
			
			DispatchSpawn(entity);
			SetEntProp(entity, Prop_Send, "m_bValidatedAttachedEntity", true);
			
			WearableRef[client] = EntIndexToEntRef(entity);
			SDKCall_EquipWearable(client, entity);
			
			SetEntProp(entity, Prop_Send, "m_fEffects", 0);
			
			SetVariantString("!activator");
			AcceptEntityInput(entity, "SetParent", weapon);
			
			pos[0] = 0.0;
			pos[1] = 7.5;
			pos[2] = -60.0;
			ang[1] = 180.0;
			ang[2] = 1.5;
			TeleportEntity(entity, pos, ang, NULL_VECTOR);
		}
	}
}

public void Weapon_RiotShield_Holster(int client)
{
	int entity = EntRefToEntIndex(ViewmodelRef[client]);
	if(entity != INVALID_ENT_REFERENCE)
		RemoveEntity(entity);
	
	ViewmodelRef[client] = INVALID_ENT_REFERENCE;

	entity = EntRefToEntIndex(WearableRef[client]);
	if(entity != INVALID_ENT_REFERENCE)
		TF2_RemoveWearable(client, entity);
	
	WearableRef[client] = INVALID_ENT_REFERENCE;
	
}

public Action FirstPersonTransmit(int entity, int client)
{
	if(client > 0 && client <= MaxClients)
	{
		int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
		if(owner == client)
		{
			if(TF2_IsPlayerInCondition(client, TFCond_Taunting) || GetEntProp(client, Prop_Send, "m_nForceTauntCam"))
				return Plugin_Stop;
		}
		else if(GetEntPropEnt(client, Prop_Send, "m_hObserverTarget") != owner || GetEntProp(client, Prop_Send, "m_iObserverMode") != 4)
		{
			return Plugin_Stop;
		}
	}
	return Plugin_Continue;
}


public Action RiotShieldAbilityEnd_M2(Handle cut_timer, int ref)
{
	int weapon = EntRefToEntIndex(ref);
	if (IsValidEntity(weapon))
	{
		float Original_Atackspeed;

		Address address = TF2Attrib_GetByDefIndex(weapon, 6);
		if(address != Address_Null)
			Original_Atackspeed = TF2Attrib_GetValue(address);

		TF2Attrib_SetByDefIndex(weapon, 6, Original_Atackspeed / 0.25);
	}
	return Plugin_Handled;
}


static bool Shield_TraceTargets(int entity, int contentsMask, int client)
{
	static char classname[64];
	if (IsValidEntity(entity))
	{
		if(0 < entity)
		{
			GetEntityClassname(entity, classname, sizeof(classname));
			
			if (((!StrContains(classname, "base_boss", true) && !b_NpcHasDied[entity]) || !StrContains(classname, "func_breakable", true)) && (GetEntProp(entity, Prop_Send, "m_iTeamNum") != GetEntProp(client, Prop_Send, "m_iTeamNum")))
			{
				for(int i=1; i <= (MAX_TARGETS_HIT_RIOT -1 ); i++)
				{
					if(!RIOT_EnemiesHit[i])
					{
						RIOT_EnemiesHit[i] = entity;
						break;
					}
				}
			}
			
		}
	}
	return false;
}