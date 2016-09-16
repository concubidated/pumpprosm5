return Def.ActorFrame {
	LoadFont("_venacti 26px bold diffuse") .. {
                InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-70;zoom,0.75;playcommand,"SetText");
		SetTextCommand=function(self)
			local serial = GetSerialNumber and GetSerialNumber() or "(unknown)";
			self:settext( "This machine's serial number is " .. serial .. "." );
		end;

	};
};

