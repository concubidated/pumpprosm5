return LoadActor(THEME:GetPathG("ScrollBar", "parts 1x3")) .. {
	InitCommand=cmd(pause;setstate,0);
}
