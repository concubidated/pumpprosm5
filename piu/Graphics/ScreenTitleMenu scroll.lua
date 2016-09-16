return Def.ActorFrame {
	LoadFont("_venacti Bold 24px") .. {
		Text=THEME:GetString( "ScreenTitleMenu", Var("GameCommand"):GetText() );
		OnCommand=cmd(shadowlength,4;strokecolor,color("#00000077"););
		GainFocusCommand=cmd(stoptweening;diffuseshift;effectperiod,0.5;effectcolor1,1,1,0.5,1;effectcolor2,0.5,0.5,0.25,1);
		LoseFocusCommand=cmd(stoptweening;stopeffect;linear,0.3;zoom,1.0);
		EnabledCommand=cmd();
		DisabledCommand=cmd(diffuse,color("#808080"));
	};
};
