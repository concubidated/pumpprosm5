local mp = Var "MultiPlayer";
local showScore = ...;

local t = Def.ActorFrame {
	InitCommand=cmd(playcommand,"Disconnected");
	LoadActor("frame") .. { 
		InitCommand=cmd(x,0;diffuse,MultiPlayerColor(mp););
	};
	LoadFont("common normal") .. { 
		InitCommand=cmd(x,-14;y,-7;settext,string.gsub(MultiPlayerToString(mp),"P","");shadowlength,1;zoom,0.5;diffuse,color("#FFFFFF"););
	};
	LoadActor("pad") .. { InitCommand=cmd(x,7;diffuse,color("#00000077");); };
	LoadActor("id") .. { 
		InitCommand=cmd(x,-19;y,8;playcommand,"Refresh";finishtweening;);
		MultiPlayerLoggedInChangedMessageCommand=function(self,param)
			if param.MultiPlayer ~= mp then return; end
			self:playcommand("Refresh");
		end;
		RefreshCommand=function(self)
			local logged_in = IsMultiPlayerLoggedIn(mp);
			if logged_in  and  self:GetZoom() ~= 1 then
				(cmd(stoptweening;zoom,2;diffusealpha,0;glow,color("#FFFFFF");linear,0.2;zoom,1;diffusealpha,1;glow,color("#FFFFFF00");))(self);
			elseif not logged_in  and  self:GetZoom() ~= 1.9 then
				(cmd(stoptweening;glow,color("#FFFFFF");linear,0.2;zoom,1.9;diffusealpha,0;glow,color("#FFFFFF00");))(self);
			end;
		end;
	};
};

if showScore then
	local mpss = STATSMAN:GetCurStageStats():GetMultiPlayerStageStats(mp);

	local sPercentScore;
	local course = GAMESTATE:GetCurrentCourse();
	local isEndless = course ~= nil and course:IsEndless();
	if isEndless then
		sPercentScore = mpss:GetActualDancePoints()
	else
		local percent = math.max( 0, mpss:GetPercentDancePoints() );
		if percent >= 1 then
			sPercentScore = "100%"
		else
			sPercentScore = string.format("%.2f%%",percent*100);
		end
	end


	t[#t+1] = LoadFont("common normal") .. { 
		InitCommand=cmd(x,82;y,-1;settext,sPercentScore;shadowlength,1;zoom,0.8;); 
		ConnectedCommand=cmd(visible,true;);
		UnpluggedCommand=cmd(visible,false;);
		NoInputHandlerCommand=cmd(visible,false;);
	};

	if not isEndless then
		t[#t+1] = Def.GradeDisplay { 
			InitCommand=cmd(x,34;y,0;Load,"_eval multiplayer grades";SetGrade,"PlayerNumber_P1",mpss:GetGrade(););
			ConnectedCommand=cmd(visible,true;);
			UnpluggedCommand=cmd(visible,false;);
			NoInputHandlerCommand=cmd(visible,false;);
		};
	end
end

return t;
