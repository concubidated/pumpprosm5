-- Many copies of this are loaded by MusicWheel, so keep this simple and only
-- return a sprite.
local s = Def.Sprite
{
	Texture="_animation 1x20.png";
};
s.Frames = {};
local NumFrames=20;
local Seconds=1;
local LastFrameTime = 0;
for i = 0,NumFrames-1 do
	local Percent = (i+1)/NumFrames;
--	Percent = 1-(math.pow(1-Percent, 2));

	local FrameTime = Percent*Seconds;

	s.Frames[#s.Frames+1] = {
		Frame = i;
		Delay = FrameTime-LastFrameTime;
	};

	LastFrameTime=FrameTime;
end

-- s.Frames = Sprite.LinearFrames(20, 2.0)
s.Frames[#s.Frames+1] = { Delay=1.5; Frame=19; };

return s;
