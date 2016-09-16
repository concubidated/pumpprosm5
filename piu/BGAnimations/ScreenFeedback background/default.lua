return Def.ActorFrame {
	LoadFont("_regra bold 30px") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-150;settext,"Send us your feedback!";diffuse,color("#4bbcfd"););
		OnCommand=cmd();
	};
	LoadFont("_regra bold 30px") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-105;settext,"This version is approximately 85% complete.";diffuse,color("#4bbcfd"););
		OnCommand=cmd();
	};
	LoadActor("logo") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X-125;y,SCREEN_CENTER_Y+0;);
		OnCommand=cmd();
	};
	LoadFont("_venacti 26px bold diffuse") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+100;settext,"piupro.com";zoomx,2;zoomy,1.7;);
		OnCommand=cmd();
	};
	LoadFont("_venacti 26px bold glow") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+100;settext,"piupro.com";zoomx,2;zoomy,1.7;blend,"BlendMode_Add";diffuseshift;effectcolor1,color("#826b47");effectcolor2,color("#ff9f09"););
		OnCommand=cmd();
	};
	LoadActor("facebook") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X+125;y,SCREEN_CENTER_Y+0;);
		OnCommand=cmd();
	};
};
