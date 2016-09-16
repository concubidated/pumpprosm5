-- Dynamically render the ticks texture: the vertical lines separating
-- the segments in the life meter.  The actual sprite will be available
-- in actor.sprite.

local MeterWidth = ...;

local distance_between_ticks = 2;
local tick_border_width = 2;
local DrewTicks = false;
local c;

local Draw = function(self)
	if not DrewTicks then
		-- This texture only needs to be drawn once.
		c.Target:GetTexture():BeginRenderingTo();
		local x = 0;
		while x < MeterWidth do
			x = x + distance_between_ticks
			c.Tick:x(x - tick_border_width);
			c.Tick:Draw();
		end
		c.Target:GetTexture():FinishRenderingTo();
		DrewTicks = true;
	end

	-- Draw the result.
	c.Out:Draw();
end

return Def.ActorFrame {
	Def.ActorFrameTexture { Name = "Target"; };
	Def.Sprite {
		Name = "Out";
		InitCommand=cmd(diffusealpha,0.4);
	};

	Def.Quad {
		Name="Tick";
		InitCommand=cmd(setsize,tick_border_width,32;halign,0;valign,0);
	};

	InitCommand = function(self)
		c = self:GetChildren();
		self:SetDrawFunction( Draw );

		-- Create the render target for the first pass.
		c.Target:setsize(MeterWidth, 32);
		c.Target:EnableAlphaBuffer(true);
		c.Target:Create();

		-- Out renders the final pass.
		c.Out:SetTexture( c.Target:GetTexture() );

		self.sprite = c.Out;
		self.sprite.SetDistanceBetweenTicks = function(self, dist)
			distance_between_ticks = dist;
			assert(distance_between_ticks > 0, distance_between_ticks)
			DrewTicks = false;
		end;
	end;
};

