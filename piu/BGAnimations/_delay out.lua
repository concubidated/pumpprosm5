local fSeconds = ScreenMetric("OutDelay");
return Def.Actor
{
	SetCommand=function(self)
		FadeState = nil;
	end;
	OnCommand=cmd(sleep,fSeconds;playcommand,"Set");
};
