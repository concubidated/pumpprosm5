local index = Var("GameCommand"):GetIndex();
local name = Var("GameCommand"):GetText();
--local title = THEME:GetString( Var "LoadingScreen", name .. "Title" );
--local explanation = THEME:GetString( Var "LoadingScreen", name .. "Explanation" );

-- HACK: We want the hex to tween out (with diffusealpha,0), but Update
-- controls the alphas. Switch to this dummy when we play OffCommand.
local function UpdateDummy(self, params)
end;

local function Update(self, params)
	local frame = self:GetChild("Frame");
	local c = frame:GetChildren();

	local fade = self:getaux();

	-- Only show the fade sprite for the side we're fading to.
	local left = (fade < 0);
	c.Left:visible(left);
	c.Right:visible(not left);

	-- As we move away from centered, fade the solid sprite to show the fading sprite.
	c.Solid:diffusealpha(1 - math.abs(fade));
	c.Glow:diffusealpha(1 - math.abs(fade));

	-- As we move further away than one item from the center, fade the fading sprite away.
	local alpha = 1;
	if math.abs(fade) > 1 then
		alpha = scale(math.abs(fade), 1, 1.5, 1, 0);
	end
	c.Left:diffusealpha(alpha);
	c.Right:diffusealpha(alpha);
end;

local f = Def.ActorFrame {
	InitCommand=cmd(SetUpdateFunction,Update);
	OffCommand=cmd(SetUpdateFunction,UpdateDummy);
};
local PartFadeOnCommand = cmd(diffusealpha,0;sleep,index*0.1+0.1;diffusealpha,1);
local PartFadeOffCommand = cmd(bouncebegin,0.35;diffusealpha,0);
f[#f+1] = Def.ActorFrame { 
	Name="Frame";
	OnCommand=cmd();
	OffCommand=cmd();
	LoadActor( "hex glow" ) .. {
		Name="Glow";
		InitCommand=cmd(blend,"BlendMode_Add";diffuseshift);
	OnCommand=PartFadeOnCommand;
	OffCommand=PartFadeOffCommand;
	};
	LoadActor( "hex " .. name .. " fade right" ) .. {
		Name="Right";
		InitCommand=cmd();
		DisabledCommand=cmd(diffuse,color("#222222"););
	OnCommand=PartFadeOnCommand;
	OffCommand=PartFadeOffCommand;
	};
	LoadActor( "hex " .. name .. " fade left" ) .. {
		Name="Left";
		InitCommand=cmd();
		DisabledCommand=cmd(diffuse,color("#222222"););
	OnCommand=PartFadeOnCommand;
	OffCommand=PartFadeOffCommand;
	};
	LoadActor( "hex " .. name .. " solid" ) .. {
		Name="Solid";
		InitCommand=cmd();
		DisabledCommand=cmd(diffuse,color("#222222"););
	OnCommand=PartFadeOnCommand;
	OffCommand=PartFadeOffCommand;
	};

	LoadActor( "hex tween overlay" ) .. {
		Name="Tween";
		InitCommand=cmd(diffusealpha,0);
		OnCommand=cmd(diffusealpha,0;
			sleep,index*0.1+0.1;
			diffusealpha,1;
			linear,0.3;
			diffusealpha,0);
		OffCommand=cmd(diffusealpha,0;
			sleep,index*0.1+0.1;
			diffusealpha,1;
			linear,0.3;
			diffusealpha,0);
	};

--[[	LoadFont("_regra bold glow 30px") .. {
		InitCommand=cmd(zoom,1.4;y,-20;settext,title;diffuse,color("#FFFFFF77");shadowlength,0;maxwidth,160;);
		DisabledCommand=cmd(diffusealpha,0;);
	};
	LoadFont("_regra styled 30px") .. {
		InitCommand=cmd(zoom,1.4;y,-20;settext,title;shadowlength,0;maxwidth,160;);
	};
	LoadFont("_regra styled 30px") .. {
		InitCommand=cmd(y,20;settext,explanation;shadowlength,0;zoom,0.63;);
		DisabledCommand=cmd(diffuse,color("#222222"););
	};
	]]
};

return f;
