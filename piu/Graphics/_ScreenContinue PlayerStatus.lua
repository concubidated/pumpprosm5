local t = Def.ActorFrame {
};

t[#t+1] = LoadActor("going") .. {
		InitCommand=cmd(diffusealpha,0);
		UnhideCommand=cmd(linear,.3;diffusealpha,1);
		HideCommand=cmd(diffusealpha,0);
		SetCommand=function(self,param)
			if param.Status == "KeepGoing" then
				self:playcommand("Unhide");
			else
				self:playcommand("Hide");
			end
		end;
}


t[#t+1] = LoadActor("join/check fill") .. {
		InitCommand=cmd(stoptweening;diffusealpha,0);
		UnhideCommand=cmd(stoptweening;diffusealpha,1;zoom,1.5;bounceend,0.2;zoom,1);
		HideCommand=cmd(stoptweening;diffusealpha,0);
		SetCommand=function(self,param)
			if param.Status == "Ready" then
				self:playcommand("Unhide");
			else
				self:playcommand("Hide");
			end
		end;
}
t[#t+1] = LoadActor("join/check outline") .. {
		InitCommand=cmd(stoptweening;diffusealpha,0);
		UnhideCommand=cmd(stoptweening;diffusealpha,1;zoom,1.5;bounceend,0.2;zoom,1);
		HideCommand=cmd(stoptweening;diffusealpha,0);
		SetCommand=function(self,param)
			if param.Status == "Ready" then
				self:playcommand("Unhide");
			else
				self:playcommand("Hide");
			end
		end;
}

t[#t+1] = LoadActor("join/check ready") .. {
		InitCommand=cmd(stoptweening;diffusealpha,0);
		UnhideCommand=cmd(stoptweening;zoom,0.5;sleep,0.1;bounceend,0.1;zoom,1;diffusealpha,1);
		HideCommand=cmd(stoptweening;diffusealpha,0);
		SetCommand=function(self,param)
			if param.Status == "Ready" then
				self:playcommand("Unhide");
			else
				self:playcommand("Hide");
			end
		end;
}




return t;