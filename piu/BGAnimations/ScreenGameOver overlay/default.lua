return Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(diffuse,color("#000000");stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM);
		OnCommand=cmd(diffusealpha,0;linear,1;diffusealpha,1);
	};
	LoadActor("bg") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		OnCommand=cmd(diffusealpha,0;sleep,.8;decelerate,0.15;diffusealpha,1;sleep,3;queuecommand,"Save";sleep,3);
		SaveCommand=function(self)
			GAMESTATE:SaveLocalData();
		end;
	};
	LoadActor("game") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-55;);
		OnCommand=cmd(diffusealpha,0;sleep,.8;diffusealpha,1;);
	};
	LoadActor("over") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+55;);
		OnCommand=cmd(diffusealpha,0;sleep,.8;diffusealpha,1;);
	};
	LoadActor("_gameglow") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-55;);
		OnCommand=cmd(diffusealpha,.5;cropright,1;sleep,0.2;linear,0.15;cropright,0;sleep,.3;accelerate,.15;diffusealpha,1;decelerate,.5;diffusealpha,0;);
	};
	LoadActor("_overglow") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+55;);
		OnCommand=cmd(diffusealpha,.5;cropleft,1;sleep,.5;linear,0.15;cropleft,0;accelerate,.15;diffusealpha,1;decelerate,.5;diffusealpha,0;);
	};
	LoadActor("woosh") .. {
		InitCommand=cmd(zoomx,-1;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-55;);
		OnCommand=cmd(addx,-1000;sleep,.05;linear,.5;addx,2000);
	};
	LoadActor("woosh") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+55;);
		OnCommand=cmd(addx,1000;sleep,.35;linear,.5;addx,-2000);
	};
	LoadActor("hexes");
	Def.Quad {
		InitCommand=cmd(diffuse,color("#FFFFFF");stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM);
		OnCommand=cmd(diffusealpha,0;sleep,.5;accelerate,.3;diffusealpha,1;decelerate,.3;diffusealpha,0);
	};
}
