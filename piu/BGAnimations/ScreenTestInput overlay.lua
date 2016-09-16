local t = Def.ActorFrame {
	OnCommand=cmd(x,-852;decelerate,0.3;addx,852);
	OffCommand=cmd(accelerate,0.3;addx,852);

	Def.InputList {
		Font="Common normal";
		InitCommand=cmd(x,SCREEN_CENTER_X-300;y,SCREEN_CENTER_Y;zoom,0.7;halign,0;vertspacing,8);
	};
};

if GameMode() == "arcade" then
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X+150;y,SCREEN_CENTER_Y);

		LoadFont("_venacti 26px bold diffuse") .. {
			Text = "Sensors";
			InitCommand=cmd(y,-54;shadowlength,0;zoom,0.75);
		};

		LoadActor("ScreenArcadeDiags overlay/sensors");
	};
end;

t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	Text="Hold &START; to exit";
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-65);
}
return t;
