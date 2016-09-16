local t = Def.ActorFrame {
};

			
t[#t+1] = LoadActor( THEME:GetPathB("", "_wipe radial/circle") ) .. {
	InitCommand=cmd(zoom,0;diffuse,color("#000000");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y*3/2;);
	OnCommand=cmd(hibernate,0.5;decelerate,0.5;zoom,15)
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(FullScreen;diffuse,color("#000000"));
	OnCommand=cmd(diffusealpha,1);
	
};

t[#t+1] = Def.Sprite {
	BeginCommand=cmd();
	RefreshCommand=cmd(LoadFromCurrentSongBackground;scale_or_crop_background);
	StartTransitioningCommand=cmd(playcommand,"Refresh";
		finishtweening;diffusealpha,.5;
	--	cropbottom,1;
	--	sleep,.75;
		diffusealpha,1;
	--	linear,0.5;
	--	cropbottom,-0.15;

		);
};
--[[
t[#t+1] = LoadActor( "explosion" ) .. {
		OffCommand=cmd(play);
	};
]]
t[#t+1] = LoadActor("_gold flash") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		OnCommand=cmd(diffusealpha,0;
	--		fadetop,0.05;fadebottom,0.05;
	--		croptop,-0.25;cropbottom,1;
--			sleep,.75;
	--		linear,0.25;
			diffusealpha,1;
			linear,0.35;
	--		croptop,1;cropbottom,-0.25;
			diffusealpha,0;
			);
	};

t[#t+1] = Def.ActorFrame {
	BeginCommand=cmd(visible,not GAMESTATE:IsCourseMode());
	LoadActor( "../ScreenStage overlay/banner gems" ) .. {
		OffCommand=cmd(playcommand,"TweenOn");
	};
};

return t;
