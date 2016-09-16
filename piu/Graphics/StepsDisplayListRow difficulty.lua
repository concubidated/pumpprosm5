return LoadFont( "_venacti 26px bold diffuse" ) .. {
	Text="XXXX";
	SetCommand=function(self,param)
			local customDifficulty = GetCustomDifficulty( param.StepsType, param.Difficulty, nil );
			local s = CustomDifficultyToLocalizedString( customDifficulty );
			s = string.upper(s);	-- TODO: string.upper doesn't work correctly for French
			self:settext( s );
			local c = CustomDifficultyToColor( customDifficulty );
			self:diffuse( c );
		end;
}
