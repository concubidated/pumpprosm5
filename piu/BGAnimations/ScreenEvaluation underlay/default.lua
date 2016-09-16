local function IsPlayerShown(pn)
	if not IsRoutine() then return GAMESTATE:IsHumanPlayer(pn); end
	return pn == GAMESTATE:GetMasterPlayerNumber();
end

local function GetFilteredMods(ModsArray)
	local ModsToIgnore = {
		Overhead=true,
		Distant=true,
		Hallway=true,
		Space=true,
		Incoming=true,
	};
	local FilteredMods = {};
	for m in ivalues(ModsArray) do
		local ignore = false;

		-- Ignore speed mods.
		if m:match("^(%d+x)$") or m:match("^(%d+(%.%d*)x)$") then ignore = true; end

		if ModsToIgnore[m] then ignore = true; end
		if not ignore then
			FilteredMods[#FilteredMods+1] = m;
		end
	end
	return FilteredMods
end

local WithoutMods;

local function SetTextFromModsArray(text, FilteredMods)
	for i=1,#FilteredMods do
		FilteredMods[i] = LocalizeOptionItem(FilteredMods[i], "OptionNamesEvaluation");
	end

	-- Fit as many as we can into the space available.  If it doesn't
	-- fit, keep removing items until it does.
	local NumRemoved = 0;
	while true do
		Trace("Filtered mods: " .. JoinTable(FilteredMods));
		local ModsText = JoinTable(FilteredMods, ", ");
		text:settext(ModsText);

		Trace(text:GetHeight());
		-- Don't remove exactly one mod, since it looks goofy to say "1 more".
		-- Allow it if we don't have any more to remove (doesn't normally happen).
		if text:GetHeight() < 80 and (NumRemoved ~= 1 or #FilteredMods < 2) then
			return;
		end

		FilteredMods[#FilteredMods] = nil
		if NumRemoved > 0 then
			FilteredMods[#FilteredMods] = nil -- remove the "%i more" from last time
		end
		NumRemoved = NumRemoved + 1
		FilteredMods[#FilteredMods+1] = string.format("%i more", NumRemoved);

		if #FilteredMods == 1 then
			Warn("Removed all mods and still didn't have enough space");
			break;
		end
	end
	return;
end

local function LoadJudgments()
	local LabelFont = LoadFont("", "_zosma 20px bold shadow") .. {
		InitCommand=cmd(shadowlength,0);
	};
	local TextFont = LoadFont("", "_venacti 26px bold monospace numbers") .. {
		InitCommand=cmd(shadowlength,0;zoomx,0.7;zoomy,0.75);
	};

	local text = {
		"SUPERB",
		"PERFECT",
		"GREAT",
		"GOOD",
		"MISS",
		"COMBO",
	};
	local pos = {
		38*0,
		37*1,
		37*2,
		37*3,
		37*4,
		37*4+46,
	};
	local JudgmentLines = 
	{
		"TapNoteScore_W1",
		"TapNoteScore_W2",
		"TapNoteScore_W3",
		"TapNoteScore_W4",
		"TapNoteScore_Miss",
	};
	local maxpos = pos[#pos];
	local t = Def.ActorFrame {
	};
	

	for pn in ivalues(PlayerNumber) do
		local flip = (pn == PLAYER_1) and 1 or -1;
		local color = (pn == PLAYER_1) and color("#ffffff") or color("#ffffff");
		local horiz = (pn == PLAYER_1) and 1 or 0;
		local c;
		local Values;
		local BigValues;
		local fTime = 0;
		local function Update(self, DeltaTime)
			fTime = fTime + DeltaTime;
			if not IsPlayerShown(pn) then return end
			for j in pairs(c) do
				local sFormat = c[j].Format;
				local iValue = math.floor( c[j]:getaux() + 0.001 );
				local s = string.format(sFormat, iValue);
				c[j]:settext(s);
			end;
		end
		local JudgmentFrame = Def.ActorFrame {
			InitCommand = function(self)
				self:SetUpdateFunction(Update);
				c = self:GetChildren();
			end;
			BeginCommand=function(self)
				Values = {};
				BigValues = false;

				if not IsPlayerShown(pn) then
					return;
				end

				for i = 1,#text do
					Values[i] = 0;

					local PlayerStats = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(pn);
					if i < #text then
						Values[i] = PlayerStats:GetTapNoteScores(JudgmentLines[i]);
--[[						if JudgmentLines[i] == "TapNoteScore_W1" then
							Values[i] = Values[i] + PlayerStats:GetTapNoteScores("TapNoteScore_CheckpointHit");
						elseif JudgmentLines[i] == "TapNoteScore_Miss" then
							Values[i] = Values[i] + PlayerStats:GetTapNoteScores("TapNoteScore_CheckpointMiss");
						end
]]
--Values[i] = math.floor(math.random()*1000);
						if Values[i] > 999 then
							BigValues = true;
						end;
					else
						Values[i] = PlayerStats:MaxCombo();
					end
				end
			end;
		};
		t[#t+1] = JudgmentFrame;

		for i = 1,#text do
			local p = (pos[i]/maxpos);
			JudgmentFrame[#JudgmentFrame+1] = TextFont .. {
				Name=i < #text and JudgmentLines[i] or "Combo";
				InitCommand=cmd(diffuse,color;
					halign,horiz;
					shadowlength,0;
					y,pos[i]);

				SetXCommand=function(self)
					self:x(-94*flip);
				
					if BigValues then
						self:addx(6*flip);
					end;
				end;
				BeginCommand=function(self)
					self.Value = Values[i] or 0;
					if not GAMESTATE:IsHumanPlayer(pn) then
						self:visible(false);
						return;
					end
					self:visible(true);

					local s;
					if i < #text and not BigValues then
						self.Format = "%03i";
					else
						self.Format = "%04i";
					end
					self:playcommand("SetX");
				end;
				OnCommand=cmd(finishtweening;playcommand,"SetX";diffusealpha,0;aux,self.Value;sleep,1.0 + p*.6;linear,0.3;diffusealpha,1;linear,0.3;aux,self.Value);
				OffCommand=cmd(stoptweening;sleep,p*.15;linear,0.3;addx,100*flip;sleep,0;diffusealpha,0);
			};
		end
	end
	return t;
end

local function CenterFrame()
	local f = Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X);

		LoadActor( "_center panel" ) .. {
			InitCommand=cmd(y,SCREEN_BOTTOM-40;valign,1);
			OnCommand = cmd(
				finishtweening;
				diffusealpha,1;zoomx,1;
				fadetop,0.15;fadebottom,0.15;
				cropbottom,0.5;croptop,0.5;

				sleep,0.6;

				decelerate,0.3;croptop,0;cropbottom,0;
				decelerate,0.1;fadetop,0;fadebottom,0;
			);
			OffCommand = cmd(stoptweening;sleep,0.3;decelerate,0.5;zoomx,0.5;diffusealpha,0);
		};

		LoadJudgments() .. {
			InitCommand=cmd(y,SCREEN_CENTER_Y-25);
		};

		LoadActor("_center frames") .. {
			InitCommand = cmd(valign,1);
			OnCommand=cmd(finishtweening;diffusealpha,1;y,SCREEN_BOTTOM;croptop,1;fadetop,.15;sleep,.3;decelerate,.3;croptop,0;decelerate,.1;fadetop,0);
			OffCommand=cmd(sleep,.0;sleep,.6;
				accelerate,0.3;
				addy,200;
				diffusealpha,0;
			);
		};
	};

	return f;
end


local GradeFrames = {
	Grade_Tier01 = 0, -- SS
	Grade_Tier02 = 1, -- S
	Grade_Tier03 = 2, -- A
	Grade_Tier04 = 3, -- B
	Grade_Tier05 = 4, -- C
	Grade_Tier06 = 5, -- D
	Grade_Failed = 6, -- F
};

function MakeGradeRecordFrame(pn)
	local flip = (pn == PLAYER_1) and 1 or -1;
	local pcolor = (pn == PLAYER_1) and color("#fff000") or color("#4de251");

	local c;
	local PlayerStats;
	local CurrentSteps;
	local CurrentTrail;
	local Current;

	local function MakeSmallStats(pn)
		local f = Def.ActorFrame {
			BeginCommand=function(self)
				if not PlayerStats then return end

				local MineText = self:GetChild("MineText");
				local MineIcon = self:GetChild("MineIcon");

				local MinesAvoided = PlayerStats:GetRadarActual():GetValue("RadarCategory_Mines");
				local TotalMines = PlayerStats:GetRadarPossible():GetValue("RadarCategory_Mines");
				-- This doesn't fit in 4:3.
				-- MineText:settext(string.format("%i/%i", MinesAvoided, TotalMines));
				MineText:settext(string.format("%i", TotalMines - MinesAvoided));

				local HoldsText = self:GetChild("HoldsText");
				local HoldsIcon = self:GetChild("HoldsIcon");
				local HoldNotesTotal = PlayerStats:GetRadarPossible():GetValue("RadarCategory_Holds");
				local HoldNotesHeld = PlayerStats:GetRadarActual():GetValue("RadarCategory_Holds");
				-- HoldsText:settext(string.format("%i/%i", HoldNotesHeld, HoldNotesTotal));
				HoldsText:settext(string.format("%i", HoldNotesHeld));

				HoldsIcon:x(HoldsText:GetX()-HoldsText:GetWidth()+4);
				MineText:x(MineIcon:GetX()+MineIcon:GetWidth());
			end;
		};

		f[#f+1] = LoadActor("_icon hold") .. {
			Name="HoldsIcon";
			InitCommand=cmd(halign,1;ztest,true);
			BeginCommand=function(self)
				if not Current then return end
				self:diffuse( StepsOrTrailToColor(Current) );
			end;
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(sleep,.3;diffusealpha,0);
		};

		f[#f+1] = LoadFont("", "_venacti 15px bold") .. {
			Name="HoldsText";
			InitCommand=cmd(halign,0;shadowlength,0;x,-3;halign,1;ztest,true);
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(sleep,.3;diffusealpha,0);
		};

		f[#f+1] = LoadActor("_icon mine") .. {
			Name="MineIcon";
			InitCommand=cmd(x,3;halign,0;ztest,true);
			BeginCommand=function(self)
				if not Current then return end
				self:diffuse( StepsOrTrailToColor(Current) );
			end;
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(sleep,.3;diffusealpha,0);
		};
		f[#f+1] = LoadFont("", "_venacti 15px bold") .. {
			Name="MineText";
			InitCommand=cmd(halign,0;shadowlength,0;ztest,true);
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(sleep,.3;diffusealpha,0);
		};
		return f;
	end

	local f = Def.ActorFrame {
		InitCommand = function(self)
			c = self:GetChildren();
		end;

		BeginCommand=function(self)
			if not GAMESTATE:IsHumanPlayer(pn) then
				Stats = nil;
				PlayerStats = nil;
				CurrentSteps = nil;
				CurrentTrail = nil;
				Current = nil;
				self:visible(false);
				return;
			end
			local Stats = STATSMAN:GetPlayedStageStats(1);
			PlayerStats = Stats:GetPlayerStageStats(pn);
			CurrentSteps = GAMESTATE:GetCurrentSteps(pn);
			CurrentTrail = GAMESTATE:GetCurrentTrail(pn);
			Current = GAMESTATE:IsCourseMode() and CurrentTrail or CurrentSteps;
			Trace( tostring(CurrentSteps) );
			Trace( tostring(CurrentTrail) );
			self:visible(true);
		end;

		OnCommand=function(self)
			self:visible(IsPlayerShown(pn));
		end;
	};

	f[#f+1] = Def.ActorFrame {
		LoadActor( "_difficulty frame color part" ) .. {
			InitCommand = cmd(
				zoomx,flip;
				pause;
				y,SCREEN_CENTER_Y-137;
				x,-7 * flip;
				fadetop,0.15;
				croptop,-0.15;
			);
			BeginCommand=function(self)
				if not Current then return end
				self:diffuse( StepsOrTrailToColor(Current) );
			end;
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(linear,0.3;diffusealpha,0);
		};
		LoadActor( "_difficulty frame overlay part" ) .. {
			InitCommand = cmd(
				zoomx,flip;
				pause;
				y,SCREEN_CENTER_Y-137;
				x,-7 * flip;
				fadetop,0.15;
				croptop,-0.15;
			);
			OnCommand=cmd(finishtweening;diffusealpha,1);
			OffCommand=cmd(linear,0.3;diffusealpha,0);
		};

		LoadActor( "_grade frame" ) ..  {
			InitCommand = cmd(y,SCREEN_CENTER_Y;zoomx,flip);
			OnCommand=cmd(diffusealpha,1);
			OffCommand=cmd(sleep,0.3;linear,0.3;diffusealpha,0);
		};
	};

	local stats = Def.ActorFrame {
		-- These parts are nudged inwards in 4:3.
		InitCommand=cmd(x,round(WideScale(18, 0) * flip,0));


		SetModsCommand=function(self, params)
			if params.PlayerNumber ~= pn then return end

			local ModsText = self:GetChild("Mods");
			SetTextFromModsArray(ModsText, params.Mods);

			WithoutMods = not params.EitherPlayerHasMods;
		end;
	};

	f[#f+1] = stats;

	stats[#stats+1] = LoadActor( "_grades 1x7" ) .. {
		InitCommand = cmd(
			y,SCREEN_CENTER_Y-36;
			setstate,0;
			pause;
		);
		BeginCommand=function(self)
			if not PlayerStats then return end
			local frame = GradeFrames[PlayerStats:GetGrade()];
			self:y(SCREEN_CENTER_Y-36 + (WithoutMods and 15 or 0));
			self:setstate(frame or 6);
		end;
		OnCommand=cmd(finishtweening;zoom,1;diffusealpha,0;linear,0.3;diffusealpha,1;);
		OffCommand=function(self)
			if not PlayerStats then return end
			local frame = GradeFrames[PlayerStats:GetGrade()] or 6;
			if frame <= 3 then		-- S, SS, A, B
				(cmd(accelerate,0.2;zoom,1.25;decelerate,0.5;zoom,1.5;diffusealpha,0))(self);
			else				-- C, D, F
				(cmd(decelerate,0.3;diffusealpha,0))(self);
			end
		end;
	};
	-- pulse effect
	stats[#stats+1] = LoadActor( "_grades 1x7" ) .. {
		InitCommand = cmd(
			y,SCREEN_CENTER_Y-36;
			setstate,0;
			pause;
		);
		BeginCommand=function(self)
			if not PlayerStats then return end
			local frame = GradeFrames[PlayerStats:GetGrade()];
			self:y(SCREEN_CENTER_Y-36 + (WithoutMods and 15 or 0));
			self:setstate(frame or 6);
		end;
		OnCommand=cmd(finishtweening;diffusealpha,1;queuecommand,"Pulse");
		PulseCommand=cmd(zoom,1;sleep,1;diffusealpha,.5;decelerate,1;zoom,1.3;diffusealpha,0;queuecommand,"Pulse");
		OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};

	stats[#stats+1] = LoadFont("", "_venacti 26px bold diffuse") .. {
		Name="Difficulty";
		InitCommand = cmd(
			y,SCREEN_CENTER_Y-120;
			shadowlength,0;
			zoom,1;
			diffuse,color("#00000");
			maxwidth,WideScale(136,175);
		);
		BeginCommand=function(self)
			if not Current then return end
			local s;

			local m = Current:GetMeter();
			s = tostring(m)

			-- XXX: workaround
--			if lua.CheckType("Trail", Current) then
			if GAMESTATE:GetPlayMode() == 'PlayMode_Nonstop' then
				s = s .. " PROGRESSIVE";
			elseif GAMESTATE:GetPlayMode() == 'PlayMode_Oni' then
				s = s .. " GAUNTLET";
			else
				s = s .. " " .. Current:GetDescription();
			end

			self:settext(s);
		end;
		OnCommand=cmd(finishtweening;diffusealpha,1);
		OffCommand=cmd(linear,0.15;diffusealpha,0);
	};

	stats[#stats+1] = Def.Quad {
		Name="StatsMaskTop";
		InitCommand=cmd(
			diffuse,color("#FF0000");
			setsize,WideScale(130,170),50;
			valign,1;
			blend,"BlendMode_NoEffect";zwrite,true;
		);
		OnCommand=cmd(y,SCREEN_CENTER_Y+40 + (WithoutMods and 35 or 0));
		OffCommand=cmd(accelerate,.3;addy,50);
	};
	
	stats[#stats+1] = MakeSmallStats(pn) .. {
		InitCommand=cmd();
		OnCommand=cmd(y,SCREEN_CENTER_Y+65 + (WithoutMods and 35 or 0));
	};

	-- Lines:
	stats[#stats+1] = Def.Quad {
		InitCommand=cmd(setsize,WideScale(130,170),1;diffuse,color("#FFFFFF"));
		OnCommand=cmd(finishtweening;y,SCREEN_CENTER_Y+40 + (WithoutMods and 35 or 0);diffusealpha,1;zoomx,1);
		OffCommand=cmd(accelerate,.3;addy,50;linear,0.15;zoomx,0;diffusealpha,0);
	};
	stats[#stats+1] = Def.Quad {
		InitCommand=cmd(setsize,WideScale(130,170),1;diffuse,color("#FFFFFF");y,SCREEN_CENTER_Y+90);
		OnCommand=cmd(finishtweening;diffusealpha,1;visible,not WithoutMods);
		OffCommand=cmd(sleep,.3;diffusealpha,0);
	};

	stats[#stats+1] = Def.ActorFrame {
		Name="HighScores";

		InitCommand = cmd(rotationz,20*flip);
		OnCommand=cmd(y,SCREEN_CENTER_Y-50 + (WithoutMods and 15 or 0));
		BeginCommand=function(self)
			local children = self:GetChildren();
			if not PlayerStats then return end
			local bMachineOn = ( PlayerStats:GetMachineHighScoreIndex() == 0 );
			local bPersonalOn = ( PlayerStats:GetPersonalHighScoreIndex() == 0 );
			children.RecordMachine:visible(bMachineOn);
			children.RecordPersonal:visible(bPersonalOn);
			children.RecordMachine:y(0);
			children.RecordPersonal:y(0);
			if bMachineOn and bPersonalOn then
				children.RecordMachine:addy(-12);
				children.RecordPersonal:addy(12);
			end
		end;

		OffCommand=function(self)
			local children = self:GetChildren();
			if children.RecordMachine:GetVisible() and children.RecordPersonal:GetVisible() then
				children.RecordPersonal:sleep(0.1);
			end
			children.RecordMachine:playcommand("DoOff");
			children.RecordPersonal:playcommand("DoOff");
		end;

		LoadFont("", "_venacti 22px bold") .. {
			Name="RecordMachine";
			InitCommand = cmd(
				shadowlength,2;
				settext,THEME:GetString(Var "LoadingScreen", "New Record!");
			);
			OnCommand=cmd(finishtweening;zoom,0.65;diffusealpha,1);
			DoOffCommand=cmd(sleep,0.15*0;linear,0.3;zoom,0.65*1.25;diffusealpha,0);
		};

		LoadFont("", "_venacti 22px bold") .. {
			Name="RecordPersonal";
			InitCommand = cmd(
				shadowlength,2;
				settext,THEME:GetString(Var "LoadingScreen", "Personal Best!");
			);
			OnCommand=cmd(finishtweening;zoom,0.65;diffusealpha,1);
			DoOffCommand=cmd(sleep,0.15*0;linear,0.3;zoom,0.65*1.25;diffusealpha,0);
		};
	};
	
	stats[#stats+1] = LoadFont("", "_zosma bold silver 25px") .. {
		Name="PercentScore";
		InitCommand = cmd(
			shadowlength,0;
			diffuse,pcolor;
		);
		BeginCommand = function(self)
			if not PlayerStats then return end
			local fScore = FormatPercentScore( PlayerStats:GetPercentDancePoints() );
			self:y(SCREEN_CENTER_Y+14 + (WithoutMods and 28 or 0));
			self:settext(fScore);
		end;
		OnCommand=cmd(finishtweening;diffusealpha,1);
		OffCommand=cmd(linear,0.3;diffusealpha,0);
	};

	stats[#stats+1] = LoadFont("_venacti 26px bold diffuse") ..  {
		Name="Mods";
		InitCommand=cmd(zoom,0.5;wrapwidthpixels,290;shadowlength,2);
		OnCommand=cmd(finishtweening;diffusealpha,1;y,SCREEN_CENTER_Y+112);
		OffCommand=cmd(linear,0.3;diffusealpha,0);
	};

	return f;
end


local t = Def.ActorFrame {

	BeginCommand=function(self)
		local PlayerMods = {};
		local EitherPlayerHasMods = false;
		local SongMods = GAMESTATE:GetSongOptionsArray("ModsLevel_Preferred");

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local PlayerState = GAMESTATE:GetPlayerState(pn);
			local Mods = PlayerState:GetPlayerOptionsArray("ModsLevel_Preferred");
			-- Mods = { "Drunk", "Dizzy", "Confusion", "Mini", "Tiny", "Flip", "Invert", "Tornado", "Tipsy", "Bumpy", "Beat", "Hidden", "HiddenOffset", "Sudden", "SuddenOffset", "Stealth", "Blink" };
			-- Mods = { "Accelerando", "Blind", "Confusion", "Mini", "Tiny", "Flip", "Invert", "Tornado", "Tipsy", "Bumpy", "Beat", "Hidden", "HiddenOffset", "Sudden", "SuddenOffset", "Stealth", "Blink" };
			Mods = GetFilteredMods(Mods);
			for m in ivalues(SongMods) do Trace("appending " .. m); Mods[#Mods+1] = m end

			PlayerMods[pn] = Mods;
			if #Mods ~= 0 then
				EitherPlayerHasMods = true;
			end;
		end;

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			self:playcommand("SetMods", { PlayerNumber=pn, Mods=PlayerMods[pn], EitherPlayerHasMods=EitherPlayerHasMods});
		end
	end;

};
t[#t+1] = CenterFrame() .. { OnCommand=cmd(hibernate,0.0); };
t[#t+1] = MakeGradeRecordFrame(PLAYER_1) .. { InitCommand = cmd(x,SCREEN_CENTER_X-260); OnCommand=cmd(hibernate,0.0); };
t[#t+1] = MakeGradeRecordFrame(PLAYER_2) .. { InitCommand = cmd(x,SCREEN_CENTER_X+260); OnCommand=cmd(hibernate,0.0); };

t[#t+1] = LoadActor( "../ScreenSelectMusic underlay/frame top inner" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;valign,0;);
	OnCommand=cmd(finishtweening;y,SCREEN_TOP);
	OffCommand=function(self)
	--	if GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() <= 0 then
			self:accelerate(.5)
			self:addy(-190)
	--	end;
	end;	
};
t[#t+1] = LoadActor( THEME:GetPathB("", "_shared Evaluation underlay") );
t[#t+1] = LoadActor( "../ScreenSelectMusic overlay/bottomslide" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OffCommand=function(self)
		if GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() <= 0 then
			self:accelerate(.5)
			self:addy(90)
		else
			GAMESTATE:Env()["BottomSlideIsVisible"] = "1";
		end;
	end;	
};
t[#t+1] = LoadActor( "../ScreenSelectMusic overlay/bottomlaser" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OffCommand=function(self)
		if GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() <= 0 then
			self:accelerate(.5)
			self:addy(90)
		end;
	end;	
};
t[#t+1]= LoadActor( THEME:GetPathB("", "_shared underlay") ) .. {
	OffCommand=function(self)
		if GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() <= 0 then
			self:playcommand("Hide")
		end;
	end;	
};
return t;
