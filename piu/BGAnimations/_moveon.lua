local t = Def.ActorFrame {
	LoadActor( THEME:GetPathS("", "_swoosh normal") ) .. {
		StartTransitioningCommand=cmd(play);
	};
	LoadFont("_venacti 26px wheel") .. { InitCommand=cmd(settext,"Loading..."); OnCommand=cmd(sleep,0.5); };
};
return t;
