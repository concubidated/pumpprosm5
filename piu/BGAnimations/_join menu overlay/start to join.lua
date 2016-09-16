return Def.ActorFrame { 
	InitCommand=cmd();
		LoadActor( THEME:GetPathG("Common", "start button") ) .. { 
		InitCommand=cmd(x,-52;y,-2;diffuseshift;effectcolor1,color("#444444FF");effectcolor2,color("#FFFFFFFF");effecttiming,2.25,0,0.25,0;zoom,0.65);
	};
	LoadFont("_venacti 26px bold diffuse") .. { 
		Text="JOIN IN";
		InitCommand=cmd(halign,0;x,-16;y,-1;shadowlength,0;zoom,1.00);
	};
}
