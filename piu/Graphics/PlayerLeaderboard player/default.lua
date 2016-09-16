local mp = Var "MultiPlayer";

return Def.ActorFrame {
	LoadActor("frame") .. {
		InitCommand=cmd(diffuse,MultiPlayerColor(mp);diffusealpha,0.7;);
	};
	LoadFont("common normal") .. {
		InitCommand=cmd(settext,MultiPlayerToLocalizedString(mp);zoom,0.5;x,-23;y,-5;shadowlength,1;;);
	};
}
