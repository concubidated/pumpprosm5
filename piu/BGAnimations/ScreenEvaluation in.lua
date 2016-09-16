local t = Def.ActorFrame {
--	LoadActor( THEME:GetPathS('', '_swoosh') ) .. { StartTransitioningCommand=cmd(play); };
	Def.Actor { OnCommand=cmd(stoptweening;sleep,1.0); };

	Def.ActorFrame {
		Condition="GAMESTATE:GetPlayMode() ~= PLAY_MODE_BATTLE and GAMESTATE:GetPlayMode() ~= PLAY_MODE_RAVE";
		--[[
		LoadActor("./ScreenGameplay failed/failed.png") .. {
			Condition="STATSMAN:GetCurStageStats():AllFailed()";
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
			OnCommand=cmd(diffusealpha,0.4;linear,0.2;diffusealpha,0);
		};
		LoadActor("./ScreenGameplay failed/cleared.png") .. {
			Condition="not STATSMAN:GetCurStageStats():AllFailed()";
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
			OnCommand=cmd(diffusealpha,1;linear,0.2;diffusealpha,0);
		};
		]]
	};
};

return t;
