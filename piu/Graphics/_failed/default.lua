local t = Def.ActorFrame {
	LoadActor("_background") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		TweenOnCommand=cmd(finishtweening;diffusealpha,0;fadetop,0;croptop,0;linear,0.3;diffusealpha,1);
		--TweenOffCommand=cmd(finishtweening;fadetop,0.5;croptop,-0.5;sleep,0.4;linear,0.3;croptop,1);
		TweenOffCommand=cmd(finishtweening;diffusealpha,1;sleep,0.5;linear,0.3;diffusealpha,0);
		SetOnCommand=cmd(diffusealpha,1);
		SetOffCommand=cmd(diffusealpha,0);
	};
	LoadActor("failed") .. {
		TweenOnCommand=cmd(play);
	};
};

local hexes = { };
for x=0,7 do
	for y=0,3 do
		local XCoord = x-1;
		local YCoord = y-1;
		local y_offs = 0;
		if (XCoord % 2) == 0 then y_offs = 0.5 end
		hexes[#hexes+1] = LoadActor("_big hex") .. {
			Name=string.format("%ix%i", x, y);
			InitCommand=cmd(x,132*XCoord;y,75*2*(YCoord+y_offs);diffusealpha,0);
		};
	end
end

local RegularAlpha = {
	["2x1"] = 0.06;
	["2x2"] = 0.19;
	["3x1"] = 0.19;
	["4x2"] = 0.19;
	["5x1"] = 0.19;
	["5x2"] = 0.06;
};

t[#t+1] = LoadActor(THEME:GetPathG("", "_sequential tween"), hexes) .. {
	Name="Hexes";
	InitCommand=cmd(x,SCREEN_CENTER_X-332;y,SCREEN_CENTER_Y-126);
	SetOnCommand=function(self)
		for name, alpha in pairs(RegularAlpha) do
			self.actors:GetChild(name):diffusealpha(alpha);
		end
	end;
	SetOffCommand=function(self)
		for idx, a in ipairs(self.actors:GetChildren()) do
			a:diffusealpha(0);
		end
	end;

	TweenOnCommand=function(self)
		local function MakeTween(name)
			return {
				Name = name;
				Tween = function(self)
					local alpha = RegularAlpha[name] or 0;
					self:stoptweening();
					self:linear(0.3);
					self:diffusealpha(alpha+0.5);
					self:linear(0.3);
					self:diffusealpha(alpha);
				end;
			}
		end;

		local Tween = {
			{ Delay=0.3 },
			{ Interval=0.04 },
			{ Label = "Start" };
			MakeTween("1x0");
			MakeTween("2x1");
			MakeTween("3x1");
			MakeTween("4x2");
			MakeTween("5x2");
			MakeTween("6x3");
			MakeTween("7x3");

			{ Interval=0.04 },
			{ Label = "X" };
			MakeTween("6x0");
			MakeTween("5x0");
			MakeTween("4x1");
			MakeTween("3x1");
			MakeTween("2x2");
			MakeTween("1x2");
			MakeTween("0x3");

			{ Goto = "X" };
			MakeTween("1x3");
			MakeTween("2x3");
			MakeTween("3x2");
			MakeTween("4x2");
			MakeTween("5x1");
			MakeTween("6x1");
			MakeTween("7x0");
		};
		self:RunTween(Tween);
	end;

	TweenOffCommand=function(self)
		local function MakeTween(alpha)
			return function(self)
				self:linear(0.3);
				self:diffusealpha(0);
			end
		end;
	
		local Tween = {
			{ Interval=0.1 },
			{ Label = "Start" };
			{ Label = "X" };
			{ Name="3x1", Tween=MakeTween(0.06) };
			{ Name="2x2", Tween=MakeTween(0.19) };
			{ Name="2x1", Tween=MakeTween(0.19) };

			{ Goto = "X" };
			{ Name="4x2", Tween=MakeTween(0.19) };
			{ Name="5x1", Tween=MakeTween(0.19) };
			{ Name="5x2", Tween=MakeTween(0.06) };
		};
	
		self:RunTween(Tween);
	end;
};

local letters = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X+1;y,SCREEN_CENTER_Y-15);
};
t[#t+1] = letters;

for i=1,6 do
	local letter = Def.ActorFrame {
		TweenOnCommand = function(self)
--			local ClearedWidth = self:GetChild("Cleared"):GetWidth();
--			local distance = ClearedWidth+(SCREEN_WIDTH-ClearedWidth)/2;
--			(cmd(finishtweening;addx,distance;sleep,(i-1)*0.1;accelerate,0.8;addx,-distance))(self);
		end;
	};

	-- The delay between each letter:
	local LetterDelay = (i-1)*0.05;

	letter[#letter+1] = LoadActor("_failed " .. i) .. {
		Name="Cleared";
		SetOnCommand=cmd(diffusealpha,1);
		SetOffCommand=cmd(diffusealpha,0);
		TweenOnCommand=cmd(finishtweening;
			diffusealpha,0;sleep,1.0;sleep,LetterDelay;
			linear,0.4;diffusealpha,1;
			);
		TweenOffCommand=cmd(finishtweening;linear,0.3;diffusealpha,0);
	};

	letters[#letters+1] = letter;
end;

return t;

