local t = Def.ActorFrame {
};
local DifficultyText = LoadFont("_venacti 26px bold diffuse");
local PillColor = LoadActor("pill color part");
local PillOverlay = LoadActor("pill overlay part");
t[#t+1] = LoadActor("difficulty frame") .. {
	InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+66);
};
local CustomDifficulties = {};	-- TODO: pull from the Screen's metrics
if Var("LoadingScreen") == "ScreenHighScores" then
	CustomDifficulties = {
		"Hard",
		"Crazy",
		"HalfDouble",
		"Freestyle",
		"Nightmare",
	};
elseif Var("LoadingScreen") == "ScreenHighScoresCourses" then
	CustomDifficulties = {
		"Progressive",
	};
elseif Var("LoadingScreen") == "ScreenHighScoresGauntlet" then
	CustomDifficulties = {
		"Gauntlet",
	};
end

for idx, customDifficulty in ipairs(CustomDifficulties) do
	local offsetFromCenter = idx-(#CustomDifficulties+1)/2;
	local x = SCREEN_CENTER_X+scale(offsetFromCenter,-2,2,-200,200);
	t[#t+1] = PillColor .. {
		InitCommand=cmd(x,x;y,64;diffuse,GameCustomDifficultyColors[customDifficulty];);
	};
	t[#t+1] = PillOverlay .. {
		InitCommand=cmd(x,x;y,64;);
	};
	t[#t+1] = DifficultyText .. {
		-- TODO: string.upper doesn't work correctly for French
		Text = string.upper( CustomDifficultyToLocalizedString(customDifficulty) );
		InitCommand=cmd(x,x-1;y,63;
			diffuse,color("#000000");shadowlength,0;strokecolor,color("#BBBBBBFF");zoom,0.49);
	};
end

t[#t+1] = LoadActor("top") .. {
	InitCommand = cmd(valign,0;x,SCREEN_CENTER_X;y,SCREEN_TOP);
};
t[#t+1] = LoadActor("bottom") .. {
	InitCommand = cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
};
t[#t+1] = LoadActor("../_shared underlay/top frame");
t[#t+1] = LoadActor("../_shared underlay/top shadow") .. { 
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0) 
};
t[#t+1] = LoadActor("../_shared underlay/bottom") .. { 
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1) 
};
t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	InitCommand=cmd(shadowlength,0;zoom,.8;x,SCREEN_CENTER_X;y,SCREEN_TOP+12;diffuse,color("#802626");settext,ScreenString("HeaderText"));
};

t[#t+1] = LoadActor(THEME:GetPathG("", "_credits text"));

t[#t+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_1;
	InitCommand=cmd(x,SCREEN_CENTER_X-170;y,SCREEN_BOTTOM-12);
};

t[#t+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_2;
	InitCommand=cmd(x,SCREEN_CENTER_X+170;y,SCREEN_BOTTOM-12);
};

t[#t+1] = LoadActor( THEME:GetPathB("","_join attract overlay") );

return t;
