local c = {};
local multiPlayer = ...;

local t = Def.ActorFrame {
	Def.ActorFrame {
		Name="JudgmentFrame";
		LoadActor("_judgments") .. {
			Name="Judgment";
			InitCommand=cmd(pause;visible,false);
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
	};
};
--[[
local JudgeCmds = {
	TapNoteScore_W1 = THEME:GetMetric( "Judgment", "JudgmentW1Command" );
	TapNoteScore_W2 = THEME:GetMetric( "Judgment", "JudgmentW2Command" );
	TapNoteScore_W3 = THEME:GetMetric( "Judgment", "JudgmentW3Command" );
	TapNoteScore_W4 = THEME:GetMetric( "Judgment", "JudgmentW4Command" );
	TapNoteScore_W5 = THEME:GetMetric( "Judgment", "JudgmentW5Command" );
	TapNoteScore_Miss = THEME:GetMetric( "Judgment", "JudgmentMissCommand" );
};
]]

local TNSFrames = {
	TapNoteScore_W1 = 0;
	TapNoteScore_W2 = 1;
	TapNoteScore_W3 = 2;
	TapNoteScore_W4 = 3;
	TapNoteScore_W5 = 4;
	TapNoteScore_Miss = 5;
	TapNoteScore_CheckpointHit = 0;
	TapNoteScore_CheckpointMiss = 5;
};

t.InitCommand = function(self)
	c.JudgmentFrame = self:GetChild("JudgmentFrame");
	c.Judgment = c.JudgmentFrame:GetChild("Judgment");
end;

t.JudgmentMessageCommand=function(self, param)
	if param.MultiPlayer ~= multiPlayer then return end;
	if not param.TapNoteScore then return end;
	if param.HoldNoteScore then return end;

	local iNumStates = c.Judgment:GetNumStates();
	local iFrame = TNSFrames[param.TapNoteScore];
	if iNumStates == 12 then
		iFrame = iFrame * 2;
		if not param.Early then
			iFrame = iFrame + 1;
		end
	end

	c.Judgment:visible( true );
	c.Judgment:setstate( iFrame );
	(cmd(
		stoptweening;zoomy,1;zoomx,1;diffusealpha,1;
		sleep,0.5;
		linear,0.3;zoomy,0;diffusealpha,0;zoomx,2.0))(c.Judgment);
--	JudgeCmds[param.TapNoteScore](c.Judgment);

	c.JudgmentFrame:stoptweening();
	local RestZoom = 0.75;
	local CurrentZoom = c.JudgmentFrame:GetZoomX();
	local DestZoom = 1;
	local PercentToRest = scale( CurrentZoom, RestZoom, DestZoom, 1, 0 );
	local Time = 0.05;

	c.JudgmentFrame:linear(Time * PercentToRest);
	c.JudgmentFrame:zoom(DestZoom);
	c.JudgmentFrame:linear(Time);
	c.JudgmentFrame:zoom(RestZoom);
end;

return t;
