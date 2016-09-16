function Sprite:LoadFromSongBackground(song)
	local Path = song:GetBackgroundPath()
	if not Path then
		Path = THEME:GetPathG("Common","fallback background")
	end

	Trace( song:GetSongDir() );
	local function UsingRateMod()
		local sMods = GAMESTATE:GetSongOptions("ModsLevel_Preferred");
		Trace( sMods );
		return string.find(sMods, "1.[123456]xMusic");
	end

	if song:GetSongDir() == "/Songs/Pump It Up Pro/Xuxa/" then
		if (GAMESTATE:GetStageSeed() % 20) == 0 or UsingRateMod() then
			Path = song:GetSongDir() .. "Xuxa-bg2.png"
		end
	end
	
	local st = GAMESTATE:GetCurrentStyle() and GAMESTATE:GetCurrentStyle():GetStyleType();
	local mpn = GAMESTATE:GetMasterPlayerNumber();
	local steps = mpn and GAMESTATE:GetCurrentSteps(mpn);
	local dc = steps and steps:GetDifficulty();
	if song:GetSongDir() == "/Songs/Pump It Up Pro 2/Pink Fuzzy Bunnies/" then	
		if st == "StyleType_OnePlayerTwoSides" and dc == "Difficulty_Hard" then
			Path = song:GetSongDir() .. "Pink Fuzzy Bunnies alt bg.png"
		end
	end

	self:LoadBackground( Path )
end

function Sprite:LoadFromCurrentSongBackground()
	local song = GAMESTATE:GetCurrentSong();
	if not song then
		local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
		local e = trail:GetEntries()
		if #e > 0 then
			song = e[1]:GetSong();
		end
	end

	if not song then return end

	self:LoadFromSongBackground(song);
end

