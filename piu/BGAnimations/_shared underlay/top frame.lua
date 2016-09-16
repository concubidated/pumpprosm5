return Def.ActorFrame {
	LoadActor("_top frame") .. {
		InitCommand=cmd(valign,0;x,SCREEN_CENTER_X;y,SCREEN_TOP);
	};
	LoadActor("_bolt") .. {
		InitCommand=cmd(x,SCREEN_LEFT+WideScale(14,14);y,SCREEN_TOP+WideScale(14,10));
	};
	LoadActor("_bolt") .. {
		InitCommand=cmd(x,SCREEN_RIGHT-WideScale(14,14);y,SCREEN_TOP+WideScale(14,10));
	};
};
