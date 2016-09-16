local zoom, y;
local big_zoom;
local current = nil;
local f = LoadActor("movie") .. {
	InitCommand=function(self)
		self:scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		self:diffuseshift();
		self:effectcolor1(color("#FFFFFF"));
		self:effectcolor2(color("#CCFFFF"));
		self:effectperiod(90);
		zoom = self:GetZoom();
		y = self:GetY();

		-- We're pushing the video down by 400 pixels, so we need at least
		-- 400 extra pixels on top (minus a little where it's hidden under
		-- the header).
		local top_half_height = self:GetZoomedHeight()/2;
		local height_needed = SCREEN_HEIGHT/2 + 400;
		if height_needed > top_half_height then
			big_zoom = height_needed / top_half_height;
		else
			big_zoom = 1;
		end
		self:playcommand("Big");
	end;
	
	BackgroundBigMessageCommand=cmd(playcommand,"Tween", {to="Big"});
	BackgroundNormalMessageCommand=cmd(playcommand,"Tween", {to="Normal"});

	RunBigCommand=cmd(y,y+400;zoom,zoom*big_zoom);
	RunNormalCommand=cmd(zoom,zoom;y,y);
	RunTweenBigCommand=cmd(stoptweening;smooth,1.5;playcommand,"RunBig");
	RunTweenNormalCommand=cmd(stoptweening;smooth,1.5;playcommand,"RunNormal");

	TweenCommand=function(self, params)
		-- If current is set, then we've already been told what to show by one
		-- screen, so we're tweening to another.  Otherwise, it's the initial
		-- setting, so snap without tweening.
		assert(params.to);
		Trace(string.format("BG TweenCommand %s -> %s", tostring(current), tostring(params.to)));
		if current == params.to then return end;
		local tween = (current ~= nil);
		current = params.to;

		local c;
		if tween then
			c = "RunTween" .. params.to;
		else
			c = "Run" .. params.to;
		end
		self:playcommand(c);
	end;
};

return f;

