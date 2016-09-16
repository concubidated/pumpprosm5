local t = Def.ActorFrame {
	BeginCommand=function(self)
		MESSAGEMAN:Broadcast("BackgroundNormal");
	end;
	OnCommand=cmd(finishtweening);

};

t[#t+1] = Def.Quad {
	InitCommand=cmd(diffuse,color("#000000");stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM);
	OnCommand=cmd(diffusealpha,1;sleep,0.0;linear,0.3;diffusealpha,0);
};

t[#t+1] = LoadActor(THEME:GetPathG("", "_cleared")) .. {
	InitCommand=cmd(playcommand,"SetOff");
	OnCommand=function(self)
		if GetTransitioningFrom() == "Cleared" then
			self:playcommand("SetOn");
			self:playcommand("TweenOff");
			SetTransitioningFrom(nil);
		end
	end;
};
t[#t+1] = LoadActor(THEME:GetPathG("", "_failed")) .. {
	InitCommand=cmd(playcommand,"SetOff");
	OnCommand=function(self)
		if GetTransitioningFrom() == "Failed" then
			self:playcommand("SetOn");
			self:playcommand("TweenOff");
			SetTransitioningFrom(nil);
		end
	end;
};

return t;
