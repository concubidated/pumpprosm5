local c = {};
local player = Var "Player";

local t = Def.ActorFrame {
	Def.ActorFrame {
		Name="JudgmentFrame";
		LoadActor( THEME:GetPathG("","_judgments") ) .. {
			Name="Judgment";
			InitCommand=cmd(pause;y,0;visible,false);
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
	};
};

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

t.OnCommand = function(self)
	local player = self:GetParent();
--	player:SetActorWithJudgmentPosition( c.JudgmentFrame );
end;

t.JudgmentMessageCommand=function(self, param)
	if param.Player ~= player then return end;
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

	local glowColor = color("#FFFFFF00");
	if param.TapNoteScore == "TapNoteScore_W1" then
		glowColor = color("#FFFFFF99");
	end

	(cmd(
		stoptweening;zoomy,1;zoomx,1;diffusealpha,1;glow,glowColor;cropleft,0;cropright,0;
		linear,0.2;glow,color("#FFFFFF00");sleep,0.4;
		linear,0.3;diffusealpha,0;zoomy,0.5;cropleft,0.5;cropright,0.5;))(c.Judgment);
--	JudgeCmds[param.TapNoteScore](c.Judgment);

	c.JudgmentFrame:stoptweening();
	local RestZoom = 0.75;
	local CurrentZoom = c.JudgmentFrame:GetZoomX();
	local DestZoom = 1;
	local PercentToRest = scale( CurrentZoom, RestZoom, DestZoom, 1, 0 );
	local Time = 0.035;

	c.JudgmentFrame:linear(Time * PercentToRest);
	c.JudgmentFrame:zoom(DestZoom);
	c.JudgmentFrame:linear(Time);
	c.JudgmentFrame:zoom(RestZoom);
end;

return t;
