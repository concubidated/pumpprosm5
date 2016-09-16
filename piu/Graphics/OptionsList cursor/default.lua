return Def.ActorFrame {
	Def.ActorFrame {
		Name="ShadowFrame";
		InitCommand=cmd(x,1;y,1);
		LoadActor("cursor") .. {
			Name="Shadow";
			InitCommand=cmd(diffuse,color("#000000FF"));
			TweenOnCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1);
			TweenOffCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0);
		};
	};
	LoadActor("cursor") .. {
		Name="Cursor";
		TweenOnCommand=cmd(stoptweening;diffusealpha,1);
		TweenOffCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0);
	};

	InitCommand=cmd(setsize,16,16);

	PositionCommand=function(self, params)
		-- Point us at the selected item.
		local t = params.Selection;
		self:stoptweening();
		self:decelerate(0.15);
		self:y(t:GetY());

		-- Rotate the parts to face the right way.  Don't do this on the whole
		-- actor, or the shadow angle will rotate, too.
		local cursor = self:GetChild("Cursor");
		local shadow = self:GetChild("ShadowFrame"):GetChild("Shadow");
		cursor:stoptweening();
		cursor:decelerate(0.15);
		-- Rotate on Y instead of Z, so the edge of the arrow doesn't shift up
		-- and down a pixel.  This also keeps the gradient consistently top-down.
		cursor:rotationy((params.Menu == "MainMenu") and 0 or 180);

		shadow:stoptweening();
		shadow:decelerate(0.15);
		shadow:rotationy((params.Menu == "MainMenu") and 0 or 180);
	end

};
