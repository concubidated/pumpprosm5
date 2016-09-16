local t = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y*3/2;zoom,4);
	OnCommand=cmd(zoom,0;decelerate,0.5;zoom,15);

	LoadActor("circle") ..
	{
		InitCommand=cmd(diffuse,color("#000000"));
	}
};

return t;

