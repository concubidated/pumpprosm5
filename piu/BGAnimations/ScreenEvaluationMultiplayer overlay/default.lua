local t = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
};



local pads = 32;
if WirelessLicensing then
	pads = WirelessLicensing.GetLicensedPads();
end
local PlayerPillFrame = Def.ActorFrame {
	Name="PlayerPillFrame";
	InitCommand=cmd(x,-50;y,52);
	OnCommand=cmd(playcommand,"Reposition";);
	MultiPlayerConnectedChangedMessageCommand=cmd(playcommand,"Reposition";);
	RepositionCommand=function(self,param)
		local numConnected = GetNumConnectedMultiPlayers();
		local joinedIndex = 0;
		for i = 1,pads do
			local child = self:GetChild(i);
			if IsMultiPlayerConnected(MultiPlayer[i]) then	
				ScreenEvaluationMultiplayerItemPositionJoined( child, joinedIndex, numConnected );
				joinedIndex = joinedIndex + 1;
			else
				(cmd(stoptweening;linear,0.2;zoom,0;))(child);
			end
		end
	end;
};
for i = 1,pads do
	local mp = MultiPlayer[i];
	PlayerPillFrame[#PlayerPillFrame+1] = Def.ActorFrame { 
		Name=i;
		Def.ControllerStateDisplay { 
			InitCommand=cmd(LoadMultiPlayer,"ControllerStateDisplayEval",MultiPlayer[i];); 
			Name="CSD#"..i;
		};
		LoadActor("MultiPlayer Judgment",mp) .. {
			InitCommand=function(self,param)
				self.MultiPlayer = mp;
				self:playcommand("SetColor");
			end;
			MultiPlayerConnectedChangedMessageCommand=function(self,param)
				if param.MultiPlayer ~= self.MultiPlayer then return; end
				self:visible( IsMultiPlayerConnected(self.MultiPlayer) );
			end;
		};
	};
end
t[#t+1] = PlayerPillFrame;




t[#t+1] = Def.PlayerLeaderboard {
	InitCommand=cmd(Load,"PlayerLeaderboard";x,0;y,-204;);
};


return t;
