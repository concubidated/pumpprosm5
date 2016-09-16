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
t[#t+1] = LoadActor( "../ScreenEnding1 underlay/top.png" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0;);
	OnCommand=cmd(addy,-90;decelerate,.5;addy,90);
	OffCommand=cmd(accelerate,.3;addy,-90);
};
t[#t+1] = LoadActor( "../ScreenEnding1 underlay/toplaser" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0;);
	OnCommand=cmd(diffusealpha,0;sleep,.7;linear,.3;diffusealpha,1);
	OffCommand=cmd(accelerate,.3;addy,-90);
};

t[#t+1] = LoadActor( "../_shared underlay/top shadow" ) .. {
	InitCommand=cmd(valign,0;x,SCREEN_CENTER_X;y,SCREEN_TOP);
	OnCommand=cmd();
	OffCommand=cmd();
};

t[#t+1] = LoadActor( "../_shared underlay/top frame" );

t[#t+1] = LoadActor("../_shared underlay/time text") .. { 
	InitCommand=cmd(x,SCREEN_CENTER_X+206;y,SCREEN_TOP+14;) 
};

t[#t+1] = Def.ActorProxy {
	BeginCommand=function(self) local banner = SCREENMAN:GetTopScreen():GetChild("Timer"); self:SetTarget(banner); end;
	InitCommand=cmd(x,SCREEN_CENTER_X+160;y,SCREEN_TOP+14);
};

t[#t+1] = LoadActor( "../ScreenEnding1 underlay/bottom.png" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OnCommand=cmd(addy,90;decelerate,.5;addy,-90);
	OffCommand=cmd(accelerate,.3;addy,90);
};
t[#t+1] = LoadActor( "../ScreenEnding1 underlay/bottomlaser" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OnCommand=cmd(diffusealpha,0;sleep,.7;linear,.3;diffusealpha,1);
	OffCommand=cmd(accelerate,.3;addy,90);
};
t[#t+1] = LoadActor( "../_shared underlay/bottom" ) .. {
	InitCommand=cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
	OnCommand=cmd();
	OffCommand=cmd();
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
	OnCommand=cmd(diffusealpha,0;zoomx,0.5;zoomy,0.8;sleep,0.3;linear,0.3;diffusealpha,1;zoomx,.8);
	OffCommand=cmd(linear,0.3;diffusealpha,0;zoomx,0.5;zoomy,0.7);
};

t[#t+1] = MakeHelpDisplay();
return t;
