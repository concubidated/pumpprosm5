local t = Def.ActorFrame {
	LoadActor("_delay in");
	Def.Quad {
		InitCommand=cmd(stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM);
		StartTransitioningCommand=function(self)
			if FadeState then
				self:diffuse( FadeState );
				(cmd(diffusealpha,1;linear,0.3;diffusealpha,0))(self);
			else
				self:diffusealpha(0);
			end
		end;
	};
};

return t;
