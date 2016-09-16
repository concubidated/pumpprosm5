local t = Def.ActorFrame {
	LoadActor( THEME:GetPathS("", "_swoosh") ) .. { StartTransitioningCommand=cmd(play); };
	Def.Actor {
		OnCommand=cmd(finishtweening;linear,0.9);
	};
};

return t;
