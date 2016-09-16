local t = Def.Quad {
	InitCommand=cmd(diffuse,color("#000000");stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM);
	SetCommand=function(self)
		FadeState = color("#000000");
	end;
	StartTransitioningCommand=cmd(playcommand,"Set";diffusealpha,0;linear,0.3;diffusealpha,1);
};
return t;
