local t = Def.ActorFrame {
	Def.Sprite
	{
		BeginCommand=cmd(LoadFromSongBackground,GAMESTATE:GetCurrentSong();scale_or_crop_background);
		OnCommand=cmd(diffusealpha,1;linear,0.5;diffusealpha,0);
	};
};

--t[#t+1] = LoadActor("../ScreenStage overlay/banner gems") .. {
--	OnCommand=cmd(playcommand,"TweenOff");
--};
if IsPlayingWorkout() then
	t[#t+1] = LoadActor( THEME:GetPathB('','_large workout status') ) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		OnCommand=cmd(queuecommand,"HighlightFirstSong";sleep,1;accelerate,0.3;addx,-SCREEN_WIDTH;sleep,0.1;queuecommand,"Hide");
		HideCommand=cmd(visible,false);
	};
end

return t;
