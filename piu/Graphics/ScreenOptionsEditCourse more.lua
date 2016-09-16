return Def.ActorFrame {
	LoadFont( "_venacti 26px bold diffuse" ) .. {
		InitCommand=cmd(shadowlength,2;zoom,0.7;playcommand,"ExitUnselectedP1";settext,THEME:GetString('_options more','Done');diffuse,color("#FFFFFF"));
		ExitSelectedP1Command=cmd(diffuseshift;effectcolor1,0.1,0.2,0.1,1;effectcolor2,0.6,1,0.6,1);
		ExitUnselectedP1Command=cmd(stopeffect);
	};
};
