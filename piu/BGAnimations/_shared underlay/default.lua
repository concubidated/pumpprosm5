local screen = Var("LoadingScreen");

local function MakeStageCreditIcons(pn)
	local Icon = LoadActor("stage credit icon") .. { InitCommand=cmd(pause) };

	local Total = PREFSMAN:GetPreference("SongsPerPlay");

	-- With three stages, prefer to show the icons across 20 pixels.  With more,
	-- stretch it to up to 28.
	local Width = scale_clamp(Total, 3, 5, 20, 28);
	if Total == 2 then Width = 15; end -- special case; 1 doesn't matter (always centered)
	local t = Def.ActorFrame {
		OnCommand=function(self)
			if screen == "ScreenContinue" then
				self:addy(-90);
				self:decelerate(.5);
				self:addy(90);
			end;
		end; 
	};

	for i = 1,Total do
		local SubtractCurrentlySelectedSong = false;
		local function Lit()
			if not GAMESTATE:IsHumanPlayer(pn) then return false; end;
			local StagesLeft = GAMESTATE:GetNumStagesLeft(pn);
			if SubtractCurrentlySelectedSong then
				StagesLeft = StagesLeft - GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse();
			end

			local IconsToLight = Total - StagesLeft;
			return i <= IconsToLight;
		end;
		local XPos = 0;
		if Total > 1 then
			XPos = scale(i, 1, Total, -Width/2, Width/2);
		end
		t[#t+1] = Icon .. {
			InitCommand = cmd(x,XPos);
			BeginCommand=cmd(playcommand,"Refresh");
			OnCommand=function(self)
				self:y(.5*i);
				if screen == "ScreenContinue" then
					self:playcommand("TweenOn");
				end;
			end;
			--NormalOnCommand=cmd(y,.5*i);
			TweenOnCommand=cmd(y,.5*i;diffusealpha,0;zoom,0;sleep,.4+0.1*(i-1);linear,0.3;zoom,1;diffusealpha,1);
			PlayerJoinedMessageCommand=cmd(playcommand,"Refresh");
			PlayerUnjoinedMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=cmd(setstate,Lit() and 0 or 1);
			SongChosenMessageCommand=function(self)
				-- The player just picked a song in ScreenSelectMusic.  Show the
				-- stage as used right when it's picked.
				local WasLit = Lit();
				SubtractCurrentlySelectedSong = true;
				self:playcommand("Refresh");

				if (not WasLit) and Lit() then
					self:stoptweening();
					self:glow(color("#FFFFFFFF"));
					self:zoom(2.0);
					self:linear(0.5);
					self:glow(color("#FFFFFF00"));
					self:zoom(1.0);
				end
			end;
		};
	end
	return t;
end;



local function MakeHelpDisplay()
	local X = ScreenMetric("HelpX");
	local Y = ScreenMetric("HelpY");
	local On = ScreenMetric("HelpOnCommand");
	local Off = ScreenMetric("HelpOffCommand");

	local sHelpText = THEME:GetMetric(Var "LoadingScreen","HelpText");
	local t = Def.HelpDisplay {
		File = THEME:GetPathF("HelpDisplay", "text");

		BeginCommand=function(self)
			local s = sHelpText;
			if type(s) == "function" then s = s() end

			self:SetTipsColonSeparated(s);
		end;

		SetHelpTextCommand=function(self, params)
			self:settips( { params.Text } );
		end;
		OnCommand=function(self)
			self:x( X );
			self:y( Y );
			On(self);
		end;
		OffCommand=Off;
	};
	return t;
end

local t = Def.ActorFrame {
};


t[#t+1] = Def.ActorFrame {
	Name="Top Inner Frame";
	HideCommand=cmd(accelerate,.5;addy,-90);

	LoadActor( "slidetop" ) .. {
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP);
			self:addy(-90);
			self:valign(0);
			if screen == "ScreenContinue" then
				self:decelerate(.5);
				self:y(SCREEN_TOP);
			else
				self:y(SCREEN_TOP);
			end;
		end; 
		
	};

	LoadActor( "laser" ) .. {
		InitCommand=function(self)
				self:x(SCREEN_CENTER_X);
				self:y(SCREEN_TOP);
				self:addy(-90);
				self:valign(0);
			if screen == "ScreenContinue" then
				self:decelerate(.5);
				self:y(SCREEN_TOP);
			else
				self:y(SCREEN_TOP);
			end;
		end; 
	};

};
t[#t+1] = LoadActor("top shadow") .. { 
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0) 
};

-- Tricky: stage tokens are part of the inner frame, but are drawn after the outer
-- frame's shadow so they're not obscured.
t[#t+1] = Def.ActorFrame {
	Name="Stage Tokens";
	HideCommand=cmd(accelerate,.5;addy,-90);
	MakeStageCreditIcons(PLAYER_1) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X-299;y,SCREEN_TOP+33);
	};
 	MakeStageCreditIcons(PLAYER_2) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X+300;y,SCREEN_TOP+33;zoomx,-1);
	};
};
t[#t+1] = LoadActor("top frame");

t[#t+1] = LoadActor("time text") .. { 
	InitCommand=cmd(x,SCREEN_CENTER_X+206;y,SCREEN_TOP+14;) 
};

t[#t+1] = Def.ActorProxy {
	BeginCommand=function(self) local banner = SCREENMAN:GetTopScreen():GetChild("Timer"); self:SetTarget(banner); end;
	InitCommand=cmd(x,SCREEN_CENTER_X+160;y,SCREEN_TOP+14);
};

t[#t+1] = LoadActor("bottom") .. { 
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1) 
};
t[#t+1] = LoadActor(THEME:GetPathG("", "_credits text"));
t[#t+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_1;
	InitCommand=cmd(x,SCREEN_CENTER_X-170;y,SCREEN_BOTTOM-12);
};

t[#t+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_2;
	InitCommand=cmd(x,SCREEN_CENTER_X+170;y,SCREEN_BOTTOM-12);
};

t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	InitCommand=cmd(shadowlength,0;zoom,.8;x,SCREEN_CENTER_X;y,SCREEN_TOP+12;diffuse,color("#802626");settext,ScreenString("HeaderText"));
};

t[#t+1] = MakeHelpDisplay();




local function MakeTimerVis()
	local t = Def.ActorFrame {
		LoadActor("timer backing");
		InitCommand=cmd(x,SCREEN_CENTER_X-160;y,14;pause);
	};
	local flash = LoadActor("timer flash");
	for x=0,5 do
		t[#t+1] = flash .. {
			OnCommand=cmd(pause;setstate,x;diffusealpha,0;sleep,x/6;queuecommand,"Flash";hurrytweening,1);
			FlashCommand=cmd(diffusealpha,1;linear,1;diffusealpha,0;queuecommand,"Flash");
			SettleCommand=cmd();
			
		};
	end
	return t;
end;
-- t[#t+1] = MakeTimerVis();

return t;
