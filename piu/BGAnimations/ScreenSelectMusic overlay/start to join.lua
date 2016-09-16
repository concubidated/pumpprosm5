return Def.ActorFrame { 
	InitCommand=cmd();
	LoadFont("_venacti 26px bold glow") .. { 
		InitCommand=cmd(y,-36;shadowlength,0;diffuseshift;effectcolor1,color("#444444FF");effectcolor2,color("#FFFFFFFF");effecttiming,2.25,0,0.25,0;);
		Text="PRESS";
	};
	LoadFont("_venacti 26px bold diffuse") .. { 
		InitCommand=cmd(y,-36;shadowlength,0;diffuseshift;effectcolor1,color("#000000FF");effectcolor2,color("#000000FF");effecttiming,2.25,0,0.25,0;);
		Text="PRESS";
	};
	LoadActor( THEME:GetPathG("Common", "start button") ) .. { 
		InitCommand=cmd(y,0;diffuseshift;effectcolor1,color("#444444FF");effectcolor2,color("#FFFFFFFF");effecttiming,2.25,0,0.25,0;);
	};
	LoadFont("_venacti 26px bold glow") .. { 
		InitCommand=cmd(y,36;shadowlength,0;diffuseshift;effectcolor1,color("#444444FF");effectcolor2,color("#FFFFFFFF");effecttiming,2.25,0,0.25,0;);
		Text="TO JOIN";
	};
	LoadFont("_venacti 26px bold diffuse") .. { 
		InitCommand=cmd(y,36;shadowlength,0;diffuseshift;effectcolor1,color("#000000FF");effectcolor2,color("#000000FF");effecttiming,2.25,0,0.25,0;);
		Text="TO JOIN";
	};
}
