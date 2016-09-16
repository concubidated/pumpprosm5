local t = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
};

local num_multiplayer_difficulties = GAMESTATE:GetNumMultiplayerNoteFields();

for i = 0,num_multiplayer_difficulties-2 do
	local pos_x = GetPlayerDividerX(i);
	local a = LoadActor("divider") .. { InitCommand=cmd(x,pos_x-SCREEN_CENTER_X;croptop,0.14;); };
	t[#t+1] = a;
end;

t[#t+1] = LoadActor("frame") .. { InitCommand=cmd(y,-198;); };

for i = 0,num_multiplayer_difficulties-1 do
	local pos_x = GetPlayerX( i );
	local a = Def.ActorFrame { 
		InitCommand=function(self) self.i = i; local fn = cmd(x,pos_x-SCREEN_CENTER_X;y,-158;); fn(self); end;
		OnCommand=cmd(playcommand,"Refresh");
		DoneLoadingNextSongMessageCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
				local screen = SCREENMAN:GetTopScreen();
				if not screen.GetDummyPlayerInfo then return end;
				local pi = screen:GetDummyPlayerInfo( self.i );
				local steps = pi:GetStepsQueueWrapped( GAMESTATE:GetCourseSongIndex() );
				local difficulty = steps:GetDifficulty();
				local customDifficulty = StepsToCustomDifficulty( steps );
				local sDifficulty = CustomDifficultyToLocalizedString(customDifficulty) .. " - " .. steps:GetMeter();
				self:GetChild("Text"):settext(sDifficulty);
				local frame_color = CustomDifficultyToColor( customDifficulty );		
				self:GetChild("Pill"):diffuse(frame_color);
			end;
		LoadActor("difficulty pill diffuse") .. { 
			Name="Pill";
			InitCommand=cmd(;); 
		};
		LoadFont("common normal") .. { 
			Name="Text";
			InitCommand=cmd(shadowlength,0;diffuse,color("#000000");zoom,0.5;); 
		};
	};
	t[#t+1] = a;
end;





local pads = 32;
if WirelessLicensing then
	pads = WirelessLicensing.GetLicensedPads();
end
local PlayerPillFrame = Def.ActorFrame {
	InitCommand=cmd(y,50);
	OnCommand=cmd(playcommand,"Reposition";);
	MultiPlayerConnectedChangedMessageCommand=cmd(playcommand,"Reposition";);
	RepositionCommand=function(self,param)
		local numConnected = GetNumConnectedMultiPlayers();
		local joinedIndex = 0;
		for i = 1,pads do
			local child = self:GetChild(i);
			if IsMultiPlayerConnected(MultiPlayer[i]) then	
				ScreenGameplayMultiplayerItemPositionJoined( child, joinedIndex, numConnected );
				joinedIndex = joinedIndex + 1;
			else
				(cmd(linear,0.2;zoom,0;))(child);
			end
		end
	end;
};
for i = 1,pads do
	local mp = MultiPlayer[i];
	PlayerPillFrame[#PlayerPillFrame+1] = Def.ActorFrame { 
		Name=i;
		Def.ControllerStateDisplay { 
			InitCommand=cmd(LoadMultiPlayer,"ControllerStateDisplay",MultiPlayer[i];); 
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


t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,0;y,174;);
	Def.Quad {
		InitCommand=cmd(zoomtowidth,100;zoomtoheight,16;diffusetopedge,color("#00000000");diffusebottomedge,color("#00000077");valign,1);
	};
	Def.Quad {
		InitCommand=cmd(zoomtowidth,100;zoomtoheight,-16;diffusetopedge,color("#00000000");diffusebottomedge,color("#00000077");valign,1);
	};
	Def.ScoreDisplayAliveTime {
		InitCommand=cmd(zoom,0.7;);
		File = THEME:GetPathF("","_venacti 26px bold monospace numbers");
		MultiPlayer = "MultiPlayer_P1";
	};
};

if IsPlayingWorkout() then
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,174;);
		LoadFont("common normal") .. {
			InitCommand=cmd(halign,1;x,-80;;settext,"Goal Complete!";diffusealpha,0;shadowlength,2;);
			WorkoutGoalCompleteMessageCommand=cmd(zoom,2;linear,0.5;diffusealpha,1;zoom,0.7;diffuseshift;);
		};
		LoadFont("common normal") .. {
			InitCommand=cmd(halign,0;x,80;settext,"Hold &START; to skip a song";shadowlength,2;zoom,0.7;);
			WorkoutGoalCompleteMessageCommand=cmd(hidden,1);
		};
		LoadFont("common normal") .. {
			InitCommand=cmd(halign,0;x,80;settext,"Hold &START; to end";diffusealpha,0;shadowlength,2;);
			WorkoutGoalCompleteMessageCommand=cmd(linear,0.5;diffusealpha,1;zoom,0.7;);
		};
	};
end

return t;
