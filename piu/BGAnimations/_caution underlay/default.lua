local t = Def.ActorFrame {
	InitCommand=cmd(valign,1;setsize,SCREEN_WIDTH,138;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
	ActualOnCommand=cmd(zoomy,0.5;linear,0.25;zoomy,1);
	ActualOffCommand=cmd(sleep,0.1;linear,0.25;zoomy,0.5);
};

t[#t+1] = LoadActor( "horizon" ) .. {
	InitCommand=cmd();
	ActualOnCommand=cmd(diffusealpha,0;linear,0.25;diffusealpha,1);
	ActualOffCommand=cmd(sleep,0.1;linear,0.25;diffusealpha,0);
};

t[#t+1] = LoadFont( "_regra bold 30px" ) .. {
	InitCommand=cmd(y,-35;diffuse,color("#ff3939");zoomy,0.8;zoomx,.76;settext,"CAUTION!";shadowlength,2;);
	ActualOnCommand=cmd(diffusealpha,0;linear,0.25;diffusealpha,1);
	ActualOffCommand=cmd(sleep,0.1;linear,0.25;diffusealpha,0);
};

t[#t+1] = LoadFont( "_regra bold 30px" ) .. {
	InitCommand=cmd(y,-2;diffuse,color("#fd6b6b");zoom,0.55;settext,THEME:GetString("Caution", "Caution");shadowlength,1;);
	ActualOnCommand=cmd(diffusealpha,0;linear,0.25;diffusealpha,1);
	ActualOffCommand=cmd(sleep,0.1;linear,0.25;diffusealpha,0);
};

return t;
