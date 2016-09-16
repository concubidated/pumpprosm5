return Def.ActorFrame {
	OnCommand=cmd(sleep,1;queuecommand,"Explode";sleep,2;queuecommand,"Hide");
	HideCommand=cmd(hidden,1);
	
	LoadActor("nameflash") .. {
	InitCommand=cmd(blend,"BlendMode_Add";x,-54;y,-46;diffusealpha,0;);
	ExplodeCommand=cmd(diffusealpha,1;decelerate,.8;zoom,1.2;diffusealpha,0;);
	};
	
	LoadActor("titleflash") .. {
	InitCommand=cmd(blend,"BlendMode_Add";x,-54;y,-46;diffusealpha,0;);
	ExplodeCommand=cmd(diffusealpha,1;decelerate,.8;zoom,1.2;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,124;y,-122;diffusealpha,0;zoom,0;sleep,0.24;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,30;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,208;y,-122;diffusealpha,0;zoom,0;sleep,0.44;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-20;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,82;y,-98;diffusealpha,0;zoom,0;sleep,0.00;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,15;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,166;y,-98;diffusealpha,0;zoom,0;sleep,0.20;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-17;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,250;y,-98;diffusealpha,0;zoom,0;sleep,0.16;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-3;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,124;y,-74;diffusealpha,0;zoom,0;sleep,0.34;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,20;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,208;y,-74;diffusealpha,0;zoom,0;sleep,0.26;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-27;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,82;y,-50;diffusealpha,0;zoom,0;sleep,0.38;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,24;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,166;y,-50;diffusealpha,0;zoom,0;sleep,0.48;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-16;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,250;y,-50;diffusealpha,0;zoom,0;sleep,0.30;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,24;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,124;y,-26;diffusealpha,0;zoom,0;sleep,0.22;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-8;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,208;y,-26;diffusealpha,0;zoom,0;sleep,0.08;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-20;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,82;y,-2;diffusealpha,0;zoom,0;sleep,0.32;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,5;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,166;y,-2;diffusealpha,0;zoom,0;sleep,0.40;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,17;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,250;y,-2;diffusealpha,0;zoom,0;sleep,0.10;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-16;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,124;y,22;diffusealpha,0;zoom,0;sleep,0.28;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,25;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,208;y,22;diffusealpha,0;zoom,0;sleep,0.36;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-18;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,82;y,46;diffusealpha,0;zoom,0;sleep,0.46;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,23;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,166;y,46;diffusealpha,0;zoom,0;sleep,0.02;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-15;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,250;y,46;diffusealpha,0;zoom,0;sleep,0.18;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-24;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,124;y,70;diffusealpha,0;zoom,0;sleep,0.12;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-13.37;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,208;y,70;diffusealpha,0;zoom,0;sleep,0.50;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,4;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,82;y,94;diffusealpha,0;zoom,0;sleep,0.04;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,-27;diffusealpha,0;);
	};
	LoadActor("hex") .. {
	InitCommand=cmd(x,166;y,94;diffusealpha,0;zoom,0;sleep,0.14;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,13;diffusealpha,0;);
	};
	
	LoadActor("hex") .. {
	InitCommand=cmd(x,124;y,118;diffusealpha,0;zoom,0;sleep,0.42;decelerate,.5;diffusealpha,1;zoom,.5;);
	ExplodeCommand=cmd(decelerate,.55;zoom,.75;rotationz,15;diffusealpha,0;);
	};
}
	