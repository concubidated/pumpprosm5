local function MakeText(idx, entry)
	if entry.stepsType == "StepsType_Pump_Double" and GameMode() == "multi" then
		return Def.Actor {}
	end

	return LoadFont("_venacti numbers 26px bold") .. {
		InitCommand=cmd(diffuse,entry.color;zoom,0.6;shadowlength,0);
		ShowCommand=cmd(diffusealpha,1);
		HideCommand=cmd(diffusealpha,0.2);
		BeginCommand=cmd(x,30*idx + ((idx>4) and 68 or 0));
		--OnCommand=cmd(diffusealpha,0;sleep,0.4+0.035*(idx + ((idx>4) and 2 or 0));linear,0.3;playcommand,"Refresh");
		OnCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.3;playcommand,"Refresh");
		RefreshCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			local steps;
			local playable = true;
			if song then 
				steps = song:GetOneSteps( entry.stepsType, entry.difficulty );
				if steps  and  not SongUtil.IsStepsPlayable( song, steps ) then
					playable = false;
				end
			end
			local s = "";
			if steps then 
				s = string.format( "%02d", steps:GetMeter() );
			end
			self:settext( s );
			self:playcommand( playable and "Show" or "Hide" );
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
		PlayerJoinedMessageCommand=cmd(playcommand,"Refresh";);
	};
end

local t = Def.ActorFrame { };

for idx, entry in ipairs(DifficultyAndStepsTypeInfo) do		-- 1, { difficulty = "Difficulty_Beginner";	stepsType = "StepsType_pump-single";	color = color("#e2e2e2"); }
	if entry.difficulty ~= "Difficulty_Edit" then
		t[#t+1] = MakeText(idx, entry);
	end
end

return t;
