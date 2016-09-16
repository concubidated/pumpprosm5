local Alignment = {
	Progressive=nil,
	Gauntlet=nil,

	Easy=24*1 + 3,
	Normal=24*2 + 3,
	Hard=24*3 + 3,
	Crazy=24*4 + 3,
	HalfDouble=24*5 + 43,
	Routine=24*6 + 93,
	Freestyle=24*6 + 93,
	Nightmare=24*7 + 93,
}

local function MakeText(idx)
	local customDifficulty = THEME:GetMetric("CustomDifficulty", idx .. "String");
	if not Alignment[customDifficulty] then
		return
	end

	local c = CustomDifficultyToColor(customDifficulty);
	local st = THEME:GetMetric("CustomDifficulty", idx .. "StepsType");
	local dc = THEME:GetMetric("CustomDifficulty", idx .. "Difficulty");
	if not st or not dc then
		return Def.Actor {}
	end

	-- 6px from pad to first number, 12px from last number to pad
	local XPos = Alignment[customDifficulty];

	return LoadFont("_venacti numbers 26px bold") .. {
		InitCommand=cmd(diffuse,c;zoom,0.55;shadowlength,0);
		ShowCommand=cmd(diffusealpha,1);
		HideCommand=cmd(diffusealpha,0.0);
		BeginCommand=cmd(x,XPos);
		OnCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			local steps;
			local playable = true;
			if song then 
				steps = song:GetOneSteps( st, dc );
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

-- FIXME
for i=1,10 do
	local text = MakeText(i);
	if text then
		t[#t+1] = text;
	end
end
	
return t;
