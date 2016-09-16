
local function PlainBanner()
	local CurrentSong = GAMESTATE:GetCurrentSong();
	local CurrentCourse = GAMESTATE:GetCurrentCourse();
	local Current = GAMESTATE:IsCourseMode() and CurrentCourse or CurrentSong;
	local sBannerPath = Current:GetBannerPath() or THEME:GetPathG("Common","fallback banner");
	return Def.ActorFrame {
		Def.Banner {
			Texture=sBannerPath;
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(sleep,0.3;linear,.4;diffusealpha,0);
		};
		LoadActor("_banner frame over") .. { 
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(sleep,0.3;linear,.4;diffusealpha,0);
		};
	}
end

local function MakeUnlocks()
	local Unlocks = {
		DummyStopnGo = { DimVol = 0.0; DimTime = 3.5; };
		DummyToasty = { DimVol = 0.5; };
		Boulafacet = { DimVol = 0.0; DimTime = 4.5; };
		Crowdpleaser = { DimVol = 0.0; DimTime = 5; };
		DabbiDoo = { DimVol = 0.0; DimTime = 3.5; };
		PlayaDEmbossa = { DimVol = 0.0; DimTime = 2.5; };
		RUTNIO = { DimVol = 0.0; DimTime = 4; };
		SwingTheHouse = { DimVol = 0.0; DimTime = 3; };
		WeAreLoud = { DimVol = 0.0; DimTime = 2.5; };
	};
	local t = Def.ActorFrame {
		CodeMessageCommand=function(self, params)
			local Unlock = Unlocks[params.Name] or {}
			local UnlockRequirements = {
				-- When Boulafacet is unlocked, unlock Showdown too.
				Acronym={"Crowdpleaser","Haven"},
				Cat={"Haven","RUTNIO"},
				House={"PlayaDEmbossa"},
				Trinity={"DabbiDoo"},
				Warp12={"DabbiDoo"},
			};

			Trace( "Unlock code " .. params.Name );
			UNLOCKMAN:UnlockEntryID( params.Name );

			local NumUnlocks = UNLOCKMAN:GetNumUnlocks();
			for name, requirements in pairs(UnlockRequirements) do
				local u = UNLOCKMAN:GetUnlockEntryByID(name);
				assert(u, name)

				if u:IsLocked() then
					local AllRequirementsAreMet = true;
					for req in ivalues(requirements) do
						local u2 = UNLOCKMAN:GetUnlockEntryByID(req);
						assert(u2, req);

						local RequirementIsMet = not u2:IsLocked();
						Trace(string.format("-> \"%s\" requires \"%s\", met: %s", name, req, tostring(RequirementIsMet)));
						if not RequirementIsMet then
							AllRequirementsAreMet = false;
						end
					end

					if AllRequirementsAreMet then
						Trace("Also unlocking " .. name);
						UNLOCKMAN:UnlockEntryID(name);
					end
				end
			end

			UNLOCKMAN:PreferUnlockEntryID( params.Name );
			SOUND:DimMusic( Unlock.DimVol or 0.3, Unlock.DimTime or 2.0 );
			SOUND:PlayOnce( THEME:GetPathS("Unlock", params.Name) );
		end;
	}

	return t;
end

return Def.ActorFrame {
	OnCommand=cmd(finishtweening);
	Def.ActorFrame {
		PlainBanner() .. {
			InitCommand = cmd(x,SCREEN_CENTER_X;y,0);
		};
		OnCommand=cmd(y,SCREEN_TOP+130;);
	};

	MakeUnlocks();

	LoadActor( THEME:GetPathS("Common", "start") ) .. { OffCommand=cmd(play); };
};
