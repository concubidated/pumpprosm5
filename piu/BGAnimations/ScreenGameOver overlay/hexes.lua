local numHex = 50;
local t = Def.ActorFrame{};
for i=1,numHex do
	t[#t+1] = LoadActor("_hex") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		OnCommand=cmd(sleep,0.8;queuecommand,"Sparkle");
		SparkleCommand=function(self)
			local rotation = math.random(-3000,3000)/100
			local horiz = math.random(-48000,48000)/100
			local vert = math.random(-64000,64000)/100
			local life = math.random(15,30)/10
			local ssize = math.random(40,60)/100
			local fsize = math.random(60,75)/100
			self:diffusealpha(.3)
			self:zoom(ssize)
			self:decelerate(life)
			self:rotationz(rotation)
			self:addx(horiz)
			self:addy(vert)
			self:zoom(fsize)
			self:diffusealpha(0)
		end;
	};
end;

return t;