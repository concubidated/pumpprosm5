return Def.ActorFrame {
	LoadActor( "frame" ) .. {
		InitCommand=cmd(x,20;y,0);
	};
	Def.WorkoutGraph {
		InitCommand=cmd(x,10;y,65;);
		BeginCommand=cmd(playcommand,"Refresh";);
		StartCommand=function(self) self:SetFromGameStateAndHighlightSong(GAMESTATE:GetCourseSongIndex()+1); end;
		FinishCommand=function(self) self:SetFromGameStateAndHighlightSong(GAMESTATE:GetCourseSongIndex()); end;
		HighlightFirstSongCommand=function(self) self:SetFromGameStateAndHighlightSong(0); end;
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Refresh";);
		RefreshCommand=function(self) self:SetFromCurrentWorkout(); end;
	};
};
