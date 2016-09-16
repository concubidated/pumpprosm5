local width = ...;
return Def.ActorFrame {
	LoadActor("highlight") .. {
		InitCommand=cmd(x,-60;y,2;diffusealpha,0.7;blend,"BlendMode_Add";zoomtowidth,width;);
	};
};
