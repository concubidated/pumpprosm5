local t = Def.ActorFrame {
};

Trace("ScreenEnterName overlay");
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
