local t = Def.ActorFrame {
	LoadActor("noise") .. {
		Name="Noise";
		InitCommand=cmd(texturewrapping,true;SetTextureFiltering,false;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,2);
		OnCommand=cmd(diffusealpha,0;linear,1;diffusealpha,1);
	};
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;setsize,SCREEN_WIDTH,100;diffuse,color("#000000"));
		OnCommand=cmd(diffusealpha,0;linear,1;diffusealpha,1;sleep,15;linear,1;diffusealpha,0);
	};
	LoadFont("_venacti 26px bold diffuse") .. {
		Text=ScreenString("Text");
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;wrapwidthpixels,SCREEN_WIDTH-100);
		OnCommand=cmd(diffusealpha,0;linear,1;diffusealpha,1;sleep,15;linear,1;diffusealpha,0);
	};
};

local function Update(self)
	local c = self:GetChild("Noise");
	local x = math.random();
	local y = math.random();
	c:customtexturerect(0+x,0+y,2+x,2+y);
end;
t.InitCommand = cmd(SetUpdateFunction,Update);

return t;
