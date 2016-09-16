local function PlayerArea( pn )
	local iLeftAtStart = GAMESTATE:GetNumStagesLeft(pn);

	local t = LoadActor( THEME:GetPathG(Var "LoadingScreen","PlayerStatus " .. pn) ) .. {
		Name=pn;
		RefreshCommand=function(self)
			local enabled = GAMESTATE:IsPlayerEnabled(pn);
			local credits = math.floor( GAMESTATE:GetCoins() / PREFSMAN:GetPreference("CoinsPerCredit") );

			local status = "";
			if not enabled then
				if credits >= 2  or  (credits >= 1 and pn=="PlayerNumber_P1") then
					status = "PressStart";
				else
					status = "InsertCoins";
				end
			elseif iLeftAtStart > 0 then
				status = "KeepGoing";
			else
				status = "Ready";
			end
			self:playcommand("Set",{Status=status});
		end;
	};
	return t;
end

local t = Def.ActorFrame {
	InitCommand=cmd(playcommand,"Refresh";);
	OnCommand=function(self)
		MESSAGEMAN:Broadcast("BackgroundBig");
	end;
	RefreshCommand=function(self) 			
			for p in ivalues(PlayerNumber) do
				self:GetChild(p):playcommand( "Refresh" );
			end
		end;
	PlayerJoinedMessageCommand=cmd(playcommand,"Refresh");
	PlayerUnjoinedMessageCommand=cmd(playcommand,"Refresh");
	CurrentStyleChangedMessageCommand=cmd(playcommand,"Refresh");
	CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
	CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");
};

t[#t+1] = Def.Actor {
	-- Mark the bottom frame as hidden.  This probably isn't the cleanest
	-- place to do this, but we do this here because it's done similarly
	-- in other screens and they should all be cleaned up together, so
	-- just stay consistent for now.
	OffCommand=function(self)
		GAMESTATE:Env().BottomSlideIsVisible = 0;
	end;
};

local function MakeHex(FadeAt, x, y)
	local t = Def.ActorFrame {
	};

	local OuterFrame = Def.ActorFrame {
		OnCommand=cmd(stoptweening;x,0;y,0;sleep,FadeAt/25;decelerate,0.15;x,x);
	};
	t[#t] = OuterFrame;
	local InnerFrame = Def.ActorFrame {
		OnCommand=cmd(stoptweening;x,0;y,0;sleep,FadeAt/25;accelerate,0.15;y,y);
	};
	OuterFrame[#OuterFrame] = InnerFrame;

	InnerFrame[#InnerFrame+1] = LoadActor( "_hex" ) .. {
		InitCommand=cmd(diffusealpha,0);
		OnCommand=cmd(diffusealpha,0);
		OffCommand=cmd(stoptweening;accelerate,.2;diffusealpha,0;);
		MenuTimerSecondsChangedMessageCommand=function(self)
			local rotation = math.random(-3000,3000)/100

			local fTime = math.ceil(SCREENMAN:GetTopScreen():GetChild("Timer"):GetSeconds());
			if fTime == FadeAt then
				(cmd(stoptweening;accelerate,1;diffusealpha,0;zoom,0.7;rotationz,rotation))(self);
			elseif fTime > FadeAt then
				(cmd(stoptweening;zoom,1;decelerate,.2;rotationz,0;diffusealpha,1))(self);
			end;
		end;
	};

	InnerFrame[#InnerFrame+1] = LoadActor( "_flash" ) .. {
		InitCommand=cmd(diffusealpha,0);
		OnCommand=cmd();
		OffCommand=cmd(stoptweening;accelerate,.2;diffusealpha,0;);
		MenuTimerSecondsChangedMessageCommand=function(self)
			local fTime = math.ceil(SCREENMAN:GetTopScreen():GetChild("Timer"):GetSeconds());
			if fTime == FadeAt then
				(cmd(stoptweening;diffusealpha,0))(self);
			elseif fTime > FadeAt then
				-- After the final player joins, we'll receive this message immediately
				-- followed by OffCommand.  The 0.001 delay prevents the diffusealpha,1
				-- from taking effect before OffCommand's stoptweening can cancel it.  This
				-- keeps us from flashing every hex due to the second join resetting the
				-- timer.
				(cmd(stoptweening;linear,0.001;diffusealpha,1;decelerate,1;diffusealpha,0))(self);
			end;
		end;
	};

	return t;
end

local HexPositions = {
	{ 0, 0 },
	{ 0, 100 },
	{ 0, -100 },
	{ -86, 50 },
	{ 86, -50 },
	{ -86, -50 },
	{ 86, 50 },
	{ -86, 150 },
	{ 86, 150 },
	{ -172, -100 },
	{ 172, 100 },
	{ -172, 100 },
	{ 172, -100 },
	{ -172, 0 },
	{ 172, 0 },
};
for i, pos in ipairs(HexPositions) do
	t[#t+1] = MakeHex(i, pos[1], pos[2]) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
	};
end


t[#t+1] = LoadActor( THEME:GetPathB("","_caution underlay") ) .. {
	OnCommand=cmd(playcommand,"ActualOn");
	OffCommand=function(self)
		if GetScreenContinueNextScreen() ~= "ScreenSelectPlayMode" then
			self:playcommand("ActualOff");
		end;
	end;

};

t[#t+1] = LoadActor( THEME:GetPathB("","_shared underlay") );
t[#t+1] = LoadActor( THEME:GetPathB("","_join menu overlay") );

t[#t+1] = PlayerArea( "PlayerNumber_P1" ) .. {
	InitCommand=cmd(x,WideScale(SCREEN_CENTER_X-180,SCREEN_CENTER_X-250);y,SCREEN_CENTER_Y;);
};
t[#t+1] = PlayerArea( "PlayerNumber_P2" ) .. {
	InitCommand=cmd(x,WideScale(SCREEN_CENTER_X+180,SCREEN_CENTER_X+250);y,SCREEN_CENTER_Y;);
};

t[#t+1] = LoadActor( THEME:GetPathS(Var "LoadingScreen", "hurry timer") ) .. {
	HurryTimerMessageCommand=cmd(play);
};
t[#t+1] = LoadActor( THEME:GetPathS(Var "LoadingScreen", "out keep going") ) .. {
	Precache=false;
	OffCommand=function(self) 
		if GAMESTATE:GetNumPlayersEnabled() ~= 0 then
			self:play();
		end
	end;
};
-- played by SSM, which is always preloaded here
--[[t[#t+1] = LoadActor( THEME:GetPathS("", "_player joined") ) .. {
	Precache=false;
	PlayerJoinedMessageCommand=cmd(play);
}; ]]

return t;
