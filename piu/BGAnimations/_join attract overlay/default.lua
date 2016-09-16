return Def.ActorFrame { 
	InitCommand=cmd(x,SCREEN_CENTER_X);
	RefreshCommand=function(self) 
			-- Show "press start" if a player can join, or if a player is already joined.
			local enough_credits = GAMESTATE:EnoughCreditsToJoin() or GAMESTATE:GetNumSidesJoined() > 0;
			
			self:GetChild("CommonPressStart"):visible( enough_credits );
			self:GetChild("CommonInsertCoin"):visible( not enough_credits );
		end;
	BeginCommand=cmd(playcommand,"Refresh";);
	CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
	CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");

	LoadActor( "press start large" ) .. { 
		Name="CommonPressStart";
		InitCommand=cmd(y,SCREEN_BOTTOM-56;);
	};
	LoadActor( "insert coin large" ) .. { 
		Name="CommonInsertCoin";
		InitCommand=cmd(y,SCREEN_BOTTOM-56;);
	};
};
