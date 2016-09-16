return Def.ActorFrame { 
	InitCommand=cmd();
	LoadFont("_venacti 26px bold glow") .. { 
		InitCommand=cmd(diffuseshift;effectcolor1,color("#CCCCCC99");effectcolor2,color("#22222299");effectperiod,3;shadowlength,0;y,-4;zoom,1.5;vertspacing,-6;);
		Text="INSERT\nCOIN";
	};
	LoadFont("_venacti 26px bold diffuse") .. { 
		InitCommand=cmd(diffuseshift;effectcolor1,color("#CCCCCC99");effectcolor2,color("#22222299");effectperiod,3;shadowlength,0;y,-4;zoom,1.5;vertspacing,-6;);
		Text="INSERT\nCOIN";
	};
}
