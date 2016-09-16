local function PlayerArea( pn )
	if GAMESTATE:GetMultiplayer() then return Def.Actor{} end

	local t = Def.ActorFrame { };
	t[#t+1] = LoadActor("frame") .. { 
		Name="Frame";
		InitCommand=cmd(visible,false);
		TweenOnCommand=cmd(diffusealpha,0;linear,0.3;diffusealpha,1);
		TweenOffCommand=cmd(diffusealpha,1;linear,0.3;diffusealpha,0);
	};
	t[#t+1] = LoadActor("start to join") .. { 
		Name="PressStart";
		InitCommand=cmd(visible,false);
		TweenOnCommand=cmd(runcommandsonleaves,cmd(diffusealpha,0;linear,0.3;diffusealpha,1));
		TweenOffCommand=cmd(runcommandsonleaves,cmd(diffusealpha,1;linear,0.3;diffusealpha,0));
	};
	t[#t+1] = LoadActor("insert coin") .. { 
		Name="InsertCoin";
		InitCommand=cmd(visible,false);
		TweenOnCommand=cmd(runcommandsonleaves,cmd(diffusealpha,0;linear,0.3;diffusealpha,1));
		TweenOffCommand=cmd(runcommandsonleaves,cmd(diffusealpha,1;linear,0.3;diffusealpha,0));
	};
	local Joined = Def.ActorFrame { 
		Name="Joined";
		TweenOnCommand=cmd(runcommandsonleaves,cmd(diffusealpha,0;linear,0.3;diffusealpha,1));
		TweenOffCommand=cmd(runcommandsonleaves,cmd(diffusealpha,1;linear,0.3;diffusealpha,0));
	};
	t[#t+1] = Joined;
	local ShowJoined = ScreenMetric("JoinOverlayShowJoinedText")
	if ShowJoined then
		Joined[#Joined+1] = LoadFont("_venacti 26px bold diffuse") .. { 
			Text=ScreenString("JoinOverlayJoinedText");
			InitCommand=cmd(halign,0;x,-25;y,-1;shadowlength,0;zoom,1.00);
		};
		Joined[#Joined+1] = LoadActor( THEME:GetPathG("Common", "start button") ) .. { 
			InitCommand=cmd(x,-55;y,0;diffuseshift;effectcolor1,color("#444444FF");effectcolor2,color("#FFFFFFFF");effecttiming,2.25,0,0.25,0;zoom,0.80);
		};
	end

	local last_visible = nil;
	t.RefreshCommand=function(self) 
		local any_joined = GAMESTATE:GetNumSidesJoined() > 0;
		local enough_credits = GAMESTATE:EnoughCreditsToJoin();
		
		Trace( "Refresh" );
		local enabled = GAMESTATE:IsPlayerEnabled(pn);
		local visible = nil;
		if enabled then
			visible = "Joined";
		elseif enough_credits then
			visible = "PressStart";
		else
			visible = "InsertCoin";
		end;

		if visible == last_visible then
			return;
		end
		last_visible = visible;
		self:GetChild("Frame"):visible( visible == "PressStart" or visible == "InsertCoin" or (ShowJoined and visible == "Joined") );
		self:GetChild("PressStart"):visible( visible == "PressStart" );
		self:GetChild("InsertCoin"):visible( visible == "InsertCoin" );
		self:GetChild("Joined"):visible( visible == "Joined" );
	end;

	return t;
end

local t = Def.ActorFrame { 
	InitCommand=cmd(x,SCREEN_CENTER_X);
	BeginCommand=cmd(playcommand,"Refresh";finishtweening);
	OnCommand=cmd(playcommand,"TweenOn");
	OffCommand=cmd(playcommand,"TweenOff");
	PlayerJoinedMessageCommand=cmd(playcommand,"Refresh");
	PlayerUnjoinedMessageCommand=cmd(playcommand,"Refresh");
	CurrentStyleChangedMessageCommand=cmd(playcommand,"Refresh");
	CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
	CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");
};

local X = ScreenMetric("JoinOverlayX");
local Y = ScreenMetric("JoinOverlayY");

t[#t+1] = PlayerArea( "PlayerNumber_P1" ) .. {
	InitCommand=cmd(x,-X;y,Y);
};
t[#t+1] = PlayerArea( "PlayerNumber_P2" ) .. {
	InitCommand=cmd(x,X;y,Y);
};

return t;
