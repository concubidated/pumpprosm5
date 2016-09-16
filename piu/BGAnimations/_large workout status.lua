return Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=cmd(x,-20;zoom,1.3);
		Def.Quad { 
			InitCommand=cmd(x,20;zoomtowidth,310;zoomtoheight,134;diffuse,color("0,0,0,0.5"));
		};
		LoadActor( THEME:GetPathB('','_framed WorkoutGraph') );
	};
	Def.Quad { 
		InitCommand=cmd(zoomtowidth,450;zoomtoheight,50;y,125;diffuse,color("0,0,0,0.5"));
	};
	LoadFont("Common normal") .. {
		InitCommand=cmd(halign,0;x,-200;y,120);
		OnCommand=cmd(playcommand,"Finish");
		StartCommand=cmd(settext,string.format( THEME:GetString('_large workout status','Song %d'), GAMESTATE:GetCourseSongIndex()+2 ));
		FinishCommand=cmd(settext,string.format( THEME:GetString('_large workout status','Song %d'), GAMESTATE:GetCourseSongIndex()+1 ));
	};
	LoadFont("common normal") .. {
		InitCommand=cmd(halign,1;x,200;y,120;playcommand,"SetText");
		OnCommand=cmd(glowshift);
		StartCommand=cmd(playcommand,"SetText");
		FinishCommand=cmd(playcommand,"SetText");
		SetTextCommand=function(self)
			local goalSeconds = PROFILEMAN:GetProfile("PlayerNumber_P1"):GetGoalSeconds() * 60;
			local playedSeconds = STATSMAN:GetCurStageStats():GetGameplaySeconds();
			if GAMESTATE:GetWorkoutGoalComplete() then
				self:settext( THEME:GetString('_large workout status','Goal Complete!') );
			else
				local secondsLeft = goalSeconds - playedSeconds;
				local minutesLeft = math.ceil( secondsLeft/60 );
				local sFormat = THEME:GetString('_large workout status','%d minutes left!');
				self:settext( string.format(sFormat, math.ceil(minutesLeft)) );
			end
		end;
	}
}
