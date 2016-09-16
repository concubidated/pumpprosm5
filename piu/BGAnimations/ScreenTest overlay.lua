--[[
local f = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
};
local HexHorizSpacing = 13;
local HexVertSpacing = -8;
local function MakeDiagonal()
	local f = Def.ActorFrame {};
	for i=-4,4 do
		f[#f+1] = LoadActor("_diagonal hexes") .. {
			InitCommand=cmd(x,HexHorizSpacing*(7*i);y,HexVertSpacing*(7*i);diffusealpha,0);
			FlashCommand=cmd(
				stoptweening;diffusealpha,1;
				diffuse,color("#630fc2");
				linear,0.05;
				diffuse,color("#4d0d95");
				linear,0.15;
				diffusealpha,0;
			);
		}
	end;
	return f;
end

local TotalDiags = 30;
local Diagonals = Def.ActorFrame {
};
for x=0,TotalDiags do
	Diagonals[#Diagonals+1] = MakeDiagonal() .. {
		Name=tostring(x);
	};
end
Diagonals.RunFromPosCommand=function(self, param)
	Trace(param.pos);
	local diag = self:GetChild(param.idx);
	diag:playcommand("Flash");
	diag:x(HexHorizSpacing*param.pos);
	diag:y(HexVertSpacing*-param.pos);
end;
Diagonals.NextCommand=function(self, params)
	local idx = params.idx or 0;
	self:playcommand("RunFromPos", {pos=idx-35, idx=idx % TotalDiags});
	if idx == 90 then return end;

	self:sleep(0.01);
	self:queuecommand("Next", { idx=idx+1 });
end

Diagonals.OnCommand=cmd(playcommand,"Next");
f[#f+1] = Diagonals;
]]
--[[
for y=-10,10 do
	f[#f+1] = MakeDiagonal() .. {
		BeginCommand=function(self)
			PositionDiagonal(self, y);
		end;
	}
end
]]

--[[[
local f = Def.ActorFrame {
	LoadActor(THEME:GetPathG("Player", "combo")) .. {
		OnCommand=cmd(playcommand,"DoExplosion");
	};
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
};
]]
local f = Def.ActorFrame {
--[[
	Def.Sprite {
		InitCommand=cmd(LoadFromSongBackground,SONGMAN:GetRandomSong();scale_or_crop_background);
	};

	LoadActor(THEME:GetPathG("", "_cleared")) .. {
		OnCommand = cmd(playcommand,"SetOff";playcommand,"TweenOn");
		OffCommand = cmd(playcommand,"SetOn";playcommand,"TweenOff");
	};
	]]
};
return f;
