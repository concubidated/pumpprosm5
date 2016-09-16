local Width = ...

return Def.ActorFrame {
	LoadActor( THEME:GetPathB('','_frame 3x1'), 'small red', Width ) .. {
		GainFocusCommand=cmd(hidden,1);
		LoseFocusCommand=cmd(hidden,0);
	};
	LoadActor( THEME:GetPathB('','_frame 3x1'), 'small green', Width-2 ) .. {
		GainFocusCommand=cmd(hidden,0);
		LoseFocusCommand=cmd(hidden,1);
	};
	Def.ActorFrame {
		ScreenGainFocusCommand=cmd(hidden,0);
		ScreenLoseFocusCommand=cmd(hidden,1);
		LoadActor( THEME:GetPathB('','_frame 3x1'), 'small glow', Width-24 ) .. {
			InitCommand=cmd(playcommandonchildren,'Setup');
			SetupCommand=cmd(blend,"BlendMode_Add";diffuseshift);
			GainFocusCommand=cmd(hidden,0);
			LoseFocusCommand=cmd(hidden,1);
		};
	};	
}