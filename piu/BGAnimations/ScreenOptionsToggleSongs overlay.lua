local t = Def.ActorFrame {
	OnCommand=cmd(x,-852;decelerate,0.3;addx,852);
	OffCommand=cmd(accelerate,0.3;addx,852);
}
	
t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	Text="Use &MENULEFT;&MENURIGHT; to enable/disable, press &START; to scroll down, press &SELECT; to skip to exit.";
	InitCommand=cmd(zoom,0.5;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-63);
}
return t;
