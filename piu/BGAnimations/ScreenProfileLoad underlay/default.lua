local t = Def.ActorFrame { };

t[#t+1] = LoadActor( "../ScreenSelectMusic overlay/bottomslide" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	BeginCommand=cmd(visible,GAMESTATE:Env()["BottomSlideIsVisible"]  == "1");
};
t[#t+1] = LoadActor( "../ScreenSelectMusic overlay/bottomlaser" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	BeginCommand=cmd(visible,GAMESTATE:Env()["BottomSlideIsVisible"]  == "1");
};

t[#t+1] = LoadActor( THEME:GetPathB("","_shared underlay") );

t[#t+1] = Def.Quad {
	InitCommand=cmd(FullScreen;diffuse,color("#000000"));
	OnCommand=function(self)
		(cmd(diffusealpha,0;linear,0.15;diffusealpha,1))(self);
	end;
	OffCommand=function(self)
		(cmd(diffusealpha,1;linear,0.2;diffusealpha,0))(self);
	end;
};

t[#t+1] = LoadActor( "statusbar" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;addx,-SCREEN_WIDTH*1.5;); 
	OnCommand=cmd(decelerate,0.3;x,SCREEN_CENTER_X);
	OffCommand=cmd(accelerate,0.3;addx,SCREEN_WIDTH*1.5);
};

t[#t+1] = Def.Actor {
	BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToLoad() then
			self:sleep(0.3);
		end;
		self:queuecommand("Load");
	end;
	LoadCommand=function()
		SCREENMAN:GetTopScreen():Continue();
	end;
};

return t;
