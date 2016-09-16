local t = Def.ActorFrame {
	LoadActor( THEME:GetPathB("ScreenOptionsSimple","overlay") );
--[[
Def.Quad {
	InitCommand=cmd(setsize,100,100;x,SCREEN_CENTER_X-200;y,SCREEN_CENTER_Y);--;bounce;effectperiod,0.5;effectmagnitude,0,175,0);
	XCommand=cmd(linear,1;addx,400;linear,1;addx,-400;queuecommand,"X");
	OnCommand=cmd(playcommand,"X");
};
]]
};

if GetSerialNumber then
	t[#t+1] = LoadFont("Common", "normal") .. {
		InitCommand=cmd(halign,1;valign,0;x,SCREEN_RIGHT-20;y,SCREEN_TOP+16;zoom,0.7;shadowlength,2;playcommand,"SetText";);
		SetTextCommand=function(self)
			local s = GetSerialNumber();
			local rev = GetRevision and GetRevision();
			self:settext( s .. " r" .. rev );
		end;
	};
end
return t;

