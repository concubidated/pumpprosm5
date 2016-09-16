local t = Def.ActorFrame {
};

t[#t+1] = Def.Sprite
{
	BeginCommand=cmd(LoadFromCurrentSongBackground;scale_or_crop_background);
	OnCommand=cmd(diffusealpha,1);
	OffCommand=cmd(sleep,0.3;linear,0.3;diffusealpha,1);
};

t[#t+1] = Def.ActorFrame {
	BeginCommand=cmd(visible,not GAMESTATE:IsCourseMode());
	LoadActor("banner gems") .. {
		OffCommand=cmd(playcommand,"TweenOff");
	};
};

if IsPlayingWorkout() then
	t[#t+1] = LoadActor( THEME:GetPathB('','_large workout status') ) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		OnCommand=cmd(queuecommand,"HighlightFirstSong");
	};
end

return t;
