local f = Def.ActorFrame {
	LoadActor( THEME:GetPathB("ScreenGameplay","overlay") );
	LoadActor("bar") .. { 
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-140;diffuseshift;effectcolor1,color("#FFFFFF");effectcolor2,color("#FFFFFFCC");effectperiod,8;);
	};
	LoadActor("demotext") .. { 
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-140;effectoffset,1.25;diffuseblink;effectcolor1,color("#DDDDDDCC");effectcolor2,color("#FFFFFFFF");effectperiod,2;effectclock,"bgm";);
	};
	LoadActor( THEME:GetPathB("","_join attract overlay") );
};

return f;
