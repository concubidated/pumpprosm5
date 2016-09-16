return Def.ActorFrame {
	LoadActor("bg") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
	};
	LoadActor("../ScreenLogo background/186_JB_HD_purple") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.25;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomtowidth,SCREEN_WIDTH*2;zoomtoheight,SCREEN_HEIGHT*2);
	};
}
	