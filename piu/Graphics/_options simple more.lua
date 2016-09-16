local Text = ...;
return Def.ActorFrame {
	LoadActor("ScreenOptionsSimple bullet") .. {
		InitCommand=cmd(playcommand,"LoseFocus";finishtweening);
		ExitSelectedP1Command=cmd(playcommand,"GainFocus");
		ExitUnselectedP1Command=cmd(playcommand,"LoseFocus");
	};
	LoadFont("common normal") .. {
		InitCommand=cmd(settext,Text;shadowlength,0;zoom,0.65;x,70;playcommand,"ExitUnselectedP1");
		ExitSelectedP1Command=cmd(diffuse,color("1,1,1,1"));
		ExitUnselectedP1Command=cmd(diffuse,color("0.6,0.6,0.6,1"));
	};
};