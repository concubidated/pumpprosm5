return Def.ActorFrame { 
	InitCommand=cmd();
	
	LoadFont("_venacti 26px bold glow") .. { 
		Text="INSERT COIN";
		InitCommand=cmd(diffuseshift;effectcolor1,color("#CCCCCC99");effectcolor2,color("#22222299");effectperiod,3;y,-1;shadowlength,0;zoom,1.00);
	};
	LoadFont("_venacti 26px bold diffuse") .. { 
		Text="INSERT COIN";
		InitCommand=cmd(diffuseshift;effectcolor1,color("#CCCCCC99");effectcolor2,color("#22222299");effectperiod,3;y,-1;shadowlength,0;zoom,1.00);
	};
}
