local t = Def.ActorFrame {

	Def.Quad {
		InitCommand=cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+194;diffuse,color("#000000"));
		OnCommand=cmd(draworder,-600;zoomtowidth,282;zoomtoheight,240;diffusealpha,0;sleep,0.25;linear,0.3;diffusealpha,1);
	},
	
	LoadActor("frame top inner") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0);
		OnCommand=cmd(addy,-190;decelerate,.5;addy,190);
		
	},
};

return t
