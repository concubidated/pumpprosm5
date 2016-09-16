local t = Def.ActorFrame {
	OnCommand=cmd(x,-852;decelerate,0.3;addx,852);
	OffCommand=cmd(accelerate,0.3;addx,852);
}
	
t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	Text="Use Player 1 &MENULEFT;&MENURIGHT; to cycle cabinet lights\nUse Player 2 &MENULEFT;&MENURIGHT; to cycle pad lights\nHold &START; to exit";
	InitCommand=cmd(zoom,0.75;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-110);
}
return t;
