local t = Def.ActorFrame {
	LoadActor("frame") .. {
		InitCommand=cmd(x,320;diffusealpha,0.7;blend,"BlendMode_Add");
	};
}

return t;
