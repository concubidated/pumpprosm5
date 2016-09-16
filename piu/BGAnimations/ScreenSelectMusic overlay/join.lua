function PlayerArea( pn )
	return Def.ActorFrame { 
		Name=pn;
		LoadActor("start to join") .. { 
			Name="PressStart";
			InitCommand=cmd();
		};
		LoadActor("insert coin") .. { 
			Name="InsertCoin";
			InitCommand=cmd();
		};
	};
end

return Def.ActorFrame { 
	InitCommand=cmd(x,SCREEN_CENTER_X;playcommand,"Refresh";);
	RefreshCommand=function(self) 
			local any_joined = GAMESTATE:GetNumSidesJoined() > 0;
			local enough_credits = GAMESTATE:EnoughCreditsToJoin();
			
			for p in ivalues(PlayerNumber) do
				local enabled = GAMESTATE:IsPlayerEnabled(p);
				self:GetChild(p):GetChild("PressStart"):visible( not enabled and enough_credits );
				self:GetChild(p):GetChild("InsertCoin"):visible( not enabled and not enough_credits );
			end
		end;
	PlayerJoinedMessageCommand=cmd(playcommand,"Refresh");
	CurrentStyleChangedMessageCommand=cmd(playcommand,"Refresh");
	CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
	CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");

	PlayerArea( "PlayerNumber_P1" ) .. {
		InitCommand=cmd(x,StepsPaneScale(-230,-250);y,SCREEN_CENTER_Y;);
	};
	PlayerArea( "PlayerNumber_P2" ) .. {
		InitCommand=cmd(x,StepsPaneScale(230,250);y,SCREEN_CENTER_Y;);
	};
};
