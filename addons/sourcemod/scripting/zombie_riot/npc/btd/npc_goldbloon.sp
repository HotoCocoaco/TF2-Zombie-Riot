#pragma semicolon 1

static const char SoundHit[][] =
{
	"zombie_riot/btd/hitgolden01.wav",
	"zombie_riot/btd/hitgolden02.wav",
	"zombie_riot/btd/hitgolden03.wav",
	"zombie_riot/btd/hitgolden04.wav"
};

static const char SoundLead[][] =
{
	"zombie_riot/btd/hitmetal01.wav",
	"zombie_riot/btd/hitmetal02.wav",
	"zombie_riot/btd/hitmetal03.wav",
	"zombie_riot/btd/hitmetal04.wav"
};

static const char SoundPurple[][] =
{
	"zombie_riot/btd/hitpurple01.wav",
	"zombie_riot/btd/hitpurple02.wav",
	"zombie_riot/btd/hitpurple03.wav",
	"zombie_riot/btd/hitpurple04.wav"
};

static int LastGoldBloon;
static int Sprite[MAXENTITIES];

static int SpriteNumber()
{
	switch(LastGoldBloon)
	{
		case 0, 1, 2, 3:	// Normal
			return 0;
		
		case 4, 5:	// Lead
			return 1;
		
		case 6:	// Fortified
			return 2;
		
		case 7:	// Purple
			return 3;
		
		default:	// Zebra
			return 4;
	}
}

methodmap GoldBloon < CClotBody
{
	property int m_iSprite
	{
		public get()
		{
			return EntRefToEntIndex(Sprite[this.index]);
		}
		public set(int value)
		{
			Sprite[this.index] = EntIndexToEntRef(value);
		}
	}
	public void PlayLeadSound()
	{
		int sound = GetRandomInt(0, sizeof(SoundLead) - 1);
		EmitSoundToAll(SoundLead[sound], this.index, SNDCHAN_VOICE, 80, _, 1.0);
	}
	public void PlayPurpleSound()
	{
		int sound = GetRandomInt(0, sizeof(SoundPurple) - 1);
		EmitSoundToAll(SoundPurple[sound], this.index, SNDCHAN_VOICE, 80, _, 1.0);
	}
	public void PlayHitSound()
	{
		int sound = GetRandomInt(0, sizeof(SoundHit) - 1);
		EmitSoundToAll(SoundHit[sound], this.index, SNDCHAN_AUTO, 80, _, 1.0);
		EmitSoundToAll(SoundHit[sound], this.index, SNDCHAN_AUTO, 80, _, 1.0);
	}
	public void PlayDeathSound()
	{
		EmitSoundToAll("zombie_riot/btd/popgolden.wav", this.index, SNDCHAN_AUTO, 80, _, 1.0);
		EmitSoundToAll("zombie_riot/btd/popgolden.wav", this.index, SNDCHAN_AUTO, 80, _, 1.0);
	}
	public GoldBloon(int client, float vecPos[3], float vecAng[3], bool ally, const char[] data)
	{
		int range = CurrentRound / 10;
		
		if(data[0])
		{
			range = StringToInt(data);
		}
		else
		{
			if(CurrentRound > 89 || CurrentRound < 20 || range == LastGoldBloon || CountPlayersOnRed() < (range - 1))
				return view_as<GoldBloon>(INVALID_ENT_REFERENCE);
		}
		
		LastGoldBloon = range;
		
		char buffer[128];
		if(range < 6)
		{
			IntToString(4 + (range * 2), buffer, sizeof(buffer));
		}
		else
		{
			IntToString(9 + (range * 2), buffer, sizeof(buffer));
		}
		
		GoldBloon npc = view_as<GoldBloon>(CClotBody(vecPos, vecAng, "models/zombie_riot/btd/bloons_hitbox.mdl", "1.0", buffer, ally, false, false, true));
		
		i_NpcInternalId[npc.index] = BTD_GOLDBLOON;
		
		npc.m_iBleedType = SpriteNumber() ? BLEEDTYPE_METAL : BLEEDTYPE_RUBBER;
		npc.m_iStepNoiseType = NOTHING;	
		npc.m_iNpcStepVariation = NOTHING;	
		npc.m_bDissapearOnDeath = true;
		npc.m_flNextRangedAttack = 0.0;
		npc.m_bCamo = (range == 3 || range > 4);
		
		//npc.DispatchParticleEffect(npc.index, "utaunt_glitter_parent_gold");
		
		int sprite = CreateEntityByName("env_sprite");
		if(sprite != -1)
		{
			FormatEx(buffer, sizeof(buffer), "zombie_riot/btd/goldbloon_%d.vmt", SpriteNumber());
			
			DispatchKeyValue(sprite, "model", buffer);
			DispatchKeyValueFloat(sprite, "scale", 0.25);
			DispatchKeyValue(sprite, "rendermode", "7");
			
			if(npc.m_bCamo && range < 16)
			{
				IntToString(15 + (range * 15), buffer, sizeof(buffer));
				DispatchKeyValue(sprite, "renderamt", buffer);
			}
			
			DispatchSpawn(sprite);
			ActivateEntity(sprite);
			
			SetEntPropEnt(sprite, Prop_Send, "m_hOwnerEntity", npc.index);
			AcceptEntityInput(sprite, "ShowSprite");
			
			float pos[3];
			GetEntPropVector(npc.index, Prop_Send, "m_vecOrigin", pos);
			pos[2] += 40.0;
			TeleportEntity(sprite, pos, NULL_VECTOR, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(sprite, "SetParent", npc.index, sprite);
			
			npc.m_iSprite = sprite;
		}
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, GoldBloon_ClotDamaged);
		SDKHook(npc.index, SDKHook_Think, GoldBloon_ClotThink);
		
		SetEntityRenderMode(npc.index, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.index, 255, 255, 255, 0);
		
		npc.StartPathing();
		
		return npc;
	}
}

public void GoldBloon_ClotThink(int iNPC)
{
	GoldBloon npc = view_as<GoldBloon>(iNPC);
	
	float gameTime = GetGameTime();
	if(npc.m_flNextDelayTime > gameTime)
		return;
	
	npc.m_flNextDelayTime = gameTime + 0.04;
	npc.Update();	
	
	if(npc.m_flNextThinkTime > gameTime)
		return;
	
	npc.m_flNextThinkTime = gameTime + 0.1;
	
	if(npc.m_iTarget < 1 || !IsValidEnemy(npc.index, npc.m_iTarget))
	{
		if(npc.m_iTarget > 0)
		{
			int alive;
			int total;
			for(int client=1; client<=MaxClients; client++)
			{
				if(IsClientInGame(client) && GetClientTeam(client)==2 && !IsFakeClient(client) && TeutonType[client] != TEUTON_WAITING)
				{
					total++;
					if(IsPlayerAlive(client) && TeutonType[client] == TEUTON_NONE && dieingstate[client] == 0)
						alive++;
				}
			}
			
			if(alive < total / 2)
			{
				SDKHooks_TakeDamage(npc.index, 0, 0, 9999999.9, DMG_SLASH);
				return;
			}
		}
		
		npc.m_iTarget = GetClosestTarget(npc.index);
	}
	
	if(npc.m_iTarget > 0)
	{
		float vecTarget[3]; vecTarget = WorldSpaceCenter(npc.m_iTarget);
		float flDistanceToTarget = GetVectorDistance(vecTarget, WorldSpaceCenter(npc.index), true);
		
		//Predict their pos.
		if(flDistanceToTarget < npc.GetLeadRadius())
		{
			PF_SetGoalVector(npc.index, PredictSubjectPosition(npc, npc.m_iTarget));
		}
		else
		{
			PF_SetGoalEntity(npc.index, npc.m_iTarget);
		}
		
		npc.StartPathing();
		
		//Target close enough to hit
		if(flDistanceToTarget < 10000)
		{
			if(npc.m_flNextMeleeAttack < gameTime)
			{
				npc.m_flNextMeleeAttack = gameTime + 0.35;
				
				Handle swingTrace;
				if(npc.DoAimbotTrace(swingTrace, npc.m_iTarget))
				{
					int target = TR_GetEntityIndex(swingTrace);
					if(target > 0)
					{
						float vecHit[3];
						TR_GetEndPosition(vecHit, swingTrace);
						
						SDKHooks_TakeDamage(target, npc.index, npc.index, float(LastGoldBloon) * float(CountPlayersOnRed()), DMG_SLASH, -1, _, vecHit);
						
						delete swingTrace;
					}
				}
			}
		}		
	}
	else
	{
		SDKHooks_TakeDamage(npc.index, 0, 0, 9999999.9, DMG_SLASH);
	}
}

public Action GoldBloon_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if(damage < (9 + (LastGoldBloon * 2)))
		return Plugin_Handled;
	
	GoldBloon npc = view_as<GoldBloon>(victim);
	
	if(attacker < 1)
	{
		npc.m_iCreditsOnKill = 0;
		b_NpcForcepowerupspawn[victim] = 0;
		return Plugin_Continue;
	}
	
	float gameTime = GetGameTime();
	if(npc.m_flNextRangedAttack > gameTime)
		return Plugin_Handled;
	
	bool hot;
	bool cold;
	bool magic;
	bool pierce;
	
	if((damagetype & DMG_SLASH) || Building_DoesPierce(attacker))
	{
		pierce = true;
	}
	else
	{
		if((damagetype & DMG_BLAST) && f_IsThisExplosiveHitscan[attacker] != GetGameTime())
		{
			hot = true;
			pierce = true;
		}
		
		if(i_HexCustomDamageTypes[victim] & ZR_DAMAGE_ICE)
		{
			cold = true;
		}
		
		if(damagetype & DMG_PLASMA)
		{
			magic = true;
			pierce = true;
		}
		else if((damagetype & DMG_SHOCK) || (i_HexCustomDamageTypes[victim] & ZR_DAMAGE_LASER_NO_BLAST))
		{
			magic = true;
		}
	}
	
	if(LastGoldBloon > 7)
	{
		if(hot || cold)
			return Plugin_Handled;
	}
	
	if(LastGoldBloon > 6)
	{
		if(magic)
		{
			npc.PlayPurpleSound();
			return Plugin_Handled;
		}
	}
	
	if(LastGoldBloon > 3)
	{
		if(!pierce)
		{
			npc.PlayLeadSound();
			return Plugin_Handled;
		}
	}
	
	int health = GetEntProp(victim, Prop_Data, "m_iHealth");
	if(health < 1)
	{
		attacker = 0;
		inflictor = 0;
		damagetype |= DMG_NEVERGIB;
		npc.PlayDeathSound();
		return Plugin_Changed;
	}
	
	npc.PlayHitSound();
	
	int target = (GetURandomInt() % 2) ? GetClosestAlly(npc.index) : 0;
	if(target < 1)
	{
		target = GetClosestTarget(npc.index, true, _, npc.m_bCamo, true, npc.m_iTarget);
		if(target > 0)
		{
			npc.m_iTarget = target;
		}
		else
		{
			target = attacker;
		}
	}
	
	npc.m_flNextRangedAttack = gameTime + 1.0;
	PluginBot_Jump(npc.index, WorldSpaceCenter(target));
	
	SetEntProp(victim, Prop_Data, "m_iHealth", health - 1);
	return Plugin_Handled;
}

public void GoldBloon_NPCDeath(int entity)
{
	GoldBloon npc = view_as<GoldBloon>(entity);
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, GoldBloon_ClotDamaged);
	SDKUnhook(npc.index, SDKHook_Think, GoldBloon_ClotThink);
	
	int sprite = npc.m_iSprite;
	if(sprite > MaxClients && IsValidEntity(sprite))
	{
		AcceptEntityInput(sprite, "HideSprite");
		RemoveEntity(sprite);
	}
}