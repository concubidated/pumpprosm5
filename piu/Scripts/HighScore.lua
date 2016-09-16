RankingToFillInMarker = { [PLAYER_1]="#P1#", [PLAYER_2]="#P2#" };

function GetHighScoreAndName(profile, Selection, SelectionItem)
	local HighScoreList = profile:GetHighScoreList(Selection, SelectionItem);
	local HighScores = HighScoreList:GetHighScores();
	if #HighScores > 0 then
		local HighScorePercent = HighScores[1]:GetPercentDP();
		local HighScoreName = HighScores[1]:GetName();
		if HighScoreName == "" then
			HighScoreName = "????";
		end
		return HighScorePercent, HighScoreName;
	else
		return 0, "PUMP";
	end
end

