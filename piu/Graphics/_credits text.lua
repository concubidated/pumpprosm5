function CreditsText( pn )
	function update(self)
		local str = GetCreditsMessage(pn);
		self:settext(str);
	end

	local text = LoadFont("_venacti 22px bold") .. {
		InitCommand=cmd(
			shadowlength,1;halign,pn == PLAYER_1 and 1 or 0;zoom,0.45;
			diffuse,color("#ffffff");
			strokecolor,color("#000000");
			shadowlength,0;
			playcommand,"RefreshCreditTextMessage";
		);
		RefreshCreditTextMessageCommand=update;
		CoinInsertedMessageCommand=update;
		PlayerJoinedMessageCommand=update;
	};
	return text;
end

local t = Def.ActorFrame {
};

t[#t+1] = CreditsText( PLAYER_1 ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X-214;y,SCREEN_BOTTOM-14);
};
t[#t+1] = CreditsText( PLAYER_2 ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X+214;y,SCREEN_BOTTOM-14);
};
return t;

