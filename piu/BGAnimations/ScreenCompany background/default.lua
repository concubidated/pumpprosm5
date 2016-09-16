return Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,WideScale(0.9,1.0););
	LoadActor("rest") .. {
			InitCommand=cmd(x,80;y,-20;);
		OnCommand=cmd(diffusealpha,0;sleep,1.5;linear,1;diffusealpha,1),
	};
	LoadActor("letter a") .. {
			InitCommand=cmd();
		OnCommand=cmd(zoom,3;x,-120;y,0;sleep,1;decelerate,0.5;zoom,1;x,-180;y,-20;),
	};
	LoadActor("letter m") .. {
			InitCommand=cmd();
		OnCommand=cmd(zoom,3;x,120;y,0;sleep,1;decelerate,0.5;zoom,1;x,80;y,-20;),
	};
	LoadActor("swoosh") .. {
			InitCommand=cmd(x,-180;y,16;);
		OnCommand=cmd(cropright,1;sleep,2.5;linear,0.5;cropright,0;),
	};
};