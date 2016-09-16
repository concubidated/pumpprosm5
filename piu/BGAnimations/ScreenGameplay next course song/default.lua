local t = Def.ActorFrame { };
t[#t+1] = Def.Quad {
	InitCommand=cmd(diffuse,color("#000000");stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM);
	StartCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1);
	FinishCommand=cmd(sleep,1;linear,0.5;diffusealpha,0);
};
t[#t+1] = Def.Sprite {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
	StartCommand=function(self)
		self:LoadFromSongBackground( SCREENMAN:GetTopScreen():GetNextCourseSong() );
		self:scale_or_crop_background();
		(cmd(diffusealpha,0;linear,0.5;diffusealpha,1))(self);
	end;
	FinishCommand=cmd(sleep,1;linear,0.5;diffusealpha,0);
};

if IsPlayingWorkout() then
	t[#t+1] = LoadActor( THEME:GetPathB('','_large workout status') ) .. {
		StartCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;addx,SCREEN_WIDTH;decelerate,0.3;addx,-SCREEN_WIDTH);
		FinishCommand=cmd(sleep,3;accelerate,0.3;addx,-SCREEN_WIDTH);
	};
end

return t;

