return Def.ActorFrame {
	LoadActor( "../Graphics/ScreenOptions page/page" ) .. {
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+10);
	};
};
