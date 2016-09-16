return Def.ActorFrame {
	LoadActor("hex") .. {
	InitCommand=cmd(diffusealpha,0;zoom,0;decelerate,.2;diffusealpha,1;zoom,1;sleep,.5;decelerate,.32;diffusealpha,0;zoom,1.3;rotationz,3);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,184;diffusealpha,0;zoom,0;sleep,.3;decelerate,.2;diffusealpha,1;zoom,1;sleep,.2;decelerate,.24;diffusealpha,0;zoom,1.3;rotationz,9;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,-184;diffusealpha,0;zoom,0;sleep,.15;decelerate,.2;diffusealpha,1;zoom,1;sleep,.35;decelerate,.48;diffusealpha,0;zoom,1.3;rotationz,-8);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(y,-106;diffusealpha,0;zoom,0;sleep,.4;decelerate,.2;diffusealpha,1;zoom,1;sleep,.1;decelerate,.28;diffusealpha,0;zoom,1.3;rotationz,-14.5);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(y,106;diffusealpha,0;zoom,0;sleep,.2;decelerate,.2;diffusealpha,1;zoom,1;sleep,.3;decelerate,.34;diffusealpha,0;zoom,1.3;rotationz,12);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,90;y,56;diffusealpha,0;zoom,0;sleep,.25;decelerate,.2;diffusealpha,1;zoom,1;sleep,.25;decelerate,.3;diffusealpha,0;zoom,1.3;rotationz,6);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,90;y,-56;diffusealpha,0;zoom,0;sleep,.05;decelerate,.2;diffusealpha,1;zoom,1;sleep,.45;decelerate,.365;diffusealpha,0;zoom,1.3;rotationz,-15);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,-90;y,56;diffusealpha,0;zoom,0;sleep,.35;decelerate,.2;diffusealpha,1;zoom,1;sleep,.15;decelerate,.48;diffusealpha,0;zoom,1.3;rotationz,-3);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,-90;y,-56;diffusealpha,0;zoom,0;sleep,.1;decelerate,.2;diffusealpha,1;zoom,1;sleep,.4;decelerate,.51;diffusealpha,0;zoom,1.3;rotationz,8);
	};
}
	