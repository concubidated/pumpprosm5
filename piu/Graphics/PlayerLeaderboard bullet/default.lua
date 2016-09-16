return Def.ActorFrame {
	LoadActor("frame") .. {
		InitCommand=cmd(y,24;diffusealpha,0.7;);
	};
	LoadFont("common normal") .. {
		InitCommand=cmd(y,24;settext,string.upper(FormatNumberAndSuffix((Var "Index")+1));shadowlength,0;zoom,0.5;);
	};
};