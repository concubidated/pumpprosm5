local t = Def.ActorFrame {
	InitCommand=cmd(runcommandsonleaves,cmd(ztest,true));

};
t[#t+1] = LoadActor("frame") .. {
};

t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	InitCommand=cmd(diffuse,color("#fff600");x,-234;y,-23;shadowlength,1;halign,0;zoom,0.65);
	SetCommand=function(self, params)
		if params.Song then
			self:settext( params.Song:GetDisplayFullTitle() );
		elseif params.Course then
			self:settext( params.Course:GetDisplayFullTitle() );
		end
	end;
};

local TypesToShow;
local bSingle;
if THEME:GetMetric(Var "LoadingScreen", "HighScoresType") == "HighScoresType_AllSteps" then
	bSingle = false;
	TypesToShow =
	{
		"Difficulty_Medium,StepsType_Pump_Single",
		"Difficulty_Hard,StepsType_Pump_Single",
		"Difficulty_Medium,StepsType_Pump_Halfdouble",
		"Difficulty_Medium,StepsType_Pump_Double",
		"Difficulty_Hard,StepsType_Pump_Double",
	};
else
	bSingle = true;
	TypesToShow =
	{
		"n/a",
		"n/a",
		"Doubles",
		"n/a",
		"n/a",
	};
end

local c;
local Scores = Def.ActorFrame {
	InitCommand = function(self)
		c = self:GetChildren();
	end;
};
t[#t+1] = Scores;

for idx, t in ipairs(TypesToShow) do
	Scores[#Scores+1] = LoadFont("_venacti 26px bold diffuse") .. {
		Name = t .. ",Name";
		InitCommand=cmd(x,scale(idx,1,4,102*-2,96*1);y,0;shadowlength,0;zoom,0.6);
	};

	Scores[#Scores+1] = LoadFont("_venacti 26px bold diffuse") .. {
		Name = t .. ",Score";
		InitCommand=cmd(x,scale(idx,1,4,102*-2,96*1);y,18;shadowlength,0;zoom,0.6);
	};
end

local sNoScoreName = THEME:GetString(Var "LoadingScreen", "NoScoreName");
Scores.SetCommand=function(self, params)
	local pProfile = PROFILEMAN:GetMachineProfile();

	for name, child in pairs(c) do
		child:visible(false);
	end
	local Current = params.Song or params.Course;
	if not Current then
		return
	end

	for idx, CurrentItem in pairs(params.Entries) do
		if CurrentItem then
			local hsl = pProfile:GetHighScoreList(Current, CurrentItem);
			local hs = hsl and hsl:GetHighScores();
			--[[Trace( tostring(CurrentItem:GetStepsType()) .. ", " ..
				tostring(CurrentItem:GetDifficulty()) .. ": " ..
				tostring(hsl) .. ", " ..
				tostring(#hs) );]]
			local sNameType = CurrentItem:GetDifficulty() .. "," .. CurrentItem:GetStepsType() .. ",Name";
			local sScoreType = CurrentItem:GetDifficulty() .. "," .. CurrentItem:GetStepsType() .. ",Score";
			if bSingle then
				sNameType = "Doubles,Name";
				sScoreType = "Doubles,Score";
			end
			assert( c[sNameType], sNameType );
			assert( c[sScoreType], sScoreType );

			c[sNameType]:visible( true );
			c[sScoreType]:visible( true );
			if hs and #hs > 0 then
				c[sNameType]:settext( hs[1]:GetName() );
				c[sScoreType]:settext( FormatPercentScore( hs[1]:GetPercentDP() ) );
			else
				c[sNameType]:settext( sNoScoreName );
				c[sScoreType]:settext( FormatPercentScore( 0 ) );
			end
		end;
	end
end;

return t;
