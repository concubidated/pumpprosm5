local t = Def.ActorFrame {
	LoadActor("_background") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		TweenOnCommand=cmd(finishtweening;diffusealpha,0;fadetop,0;croptop,0;linear,0.3;diffusealpha,1);
		--TweenOffCommand=cmd(finishtweening;fadetop,0.5;croptop,-0.5;sleep,0.4;linear,0.3;croptop,1);
		TweenOffCommand=cmd(finishtweening;diffusealpha,1;sleep,0.8;linear,0.3;diffusealpha,0);
		SetOnCommand=cmd(diffusealpha,1);
		SetOffCommand=cmd(diffusealpha,0);
	};
};


t[#t+1] = Def.Actor {
	Name="BonusController";
	UpdateDisplayedGraphicsCommand=function(self)
		local EitherPlayerDidWell = false;
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local PlayerStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
			local PlayerGrade = PlayerStats:GetGrade();
			local GradeVal = Grade:Reverse()[PlayerGrade];
			local IsBeginner = GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == "Difficulty_Beginner";

			Trace("ShowOOOSV: " .. pn .. ": " .. tostring(GradeVal) .. ", " .. tostring(IsBeginner) );
			if GradeVal <= 2 and not IsBeginner then -- SS, S, A
				EitherPlayerDidWell = true;
			end
		end

		local ShowOOOSV = GAMESTATE:GetCurrentSong() and
			GAMESTATE:GetCurrentSong():GetSongDir() == "/Songs/Pump It Up Pro 2/Oh Oh Oh Sexy Vampire/" and EitherPlayerDidWell;

		Trace("ShowOOOSV: " .. tostring(ShowOOOSV) );

		self:GetParent():GetChild("OOOSV_P1"):visible( ShowOOOSV );
		self:GetParent():GetChild("OOOSV_P2"):visible( ShowOOOSV );
	end;

	SetOnCommand=cmd(playcommand,"UpdateDisplayedGraphics");
	TweenOnCommand=cmd(playcommand,"UpdateDisplayedGraphics");
};

t[#t+1] = Def.ActorFrame {
	Name = "OOOSV_P1";

	InitCommand=cmd(visible,false;x,SCREEN_CENTER_X+80;y,SCREEN_CENTER_Y-55;zoom,0.3);
	LoadActor("_ooosv cape") .. {
		SetOnCommand=cmd(finishtweening;diffusealpha,1);
		TweenOnCommand=cmd(finishtweening;diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1);
		SetOffCommand=cmd(finishtweening;diffusealpha,0);
		TweenOffCommand=cmd(finishtweening;sleep,0.5;linear,0.3;diffusealpha,0);
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

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X-332;y,SCREEN_CENTER_Y-126);
	LoadActor(THEME:GetPathG("", "_sequential tween"), hexes) .. {
		InitCommand=function(self)
			self:playcommand("SetOff");
		end;
		SetOnCommand=function(self)
			for name, alpha in pairs(RegularAlpha) do
				self.actors:GetChild(name):diffusealpha(alpha);
			end
		end;
		SetOffCommand=function(self)
			for name, alpha in pairs(RegularAlpha) do
				self.actors:GetChild(name):diffusealpha(0);
			end
		end;
		TweenOnCommand=function(self)
			local function MakeTween(name)
				return {
					Name = name;
					Tween = function(self)
						local alpha = RegularAlpha[name] or 0;
						self:diffusealpha(0);
						self:sleep(0.2);
						self:linear(0.3);
						self:diffusealpha(alpha*2);
						self:linear(0.25);
						self:diffusealpha(alpha);
					end;
				};
			end;

			local Tween = {
				{ Interval=0.05 },
				{ Label = "Start" };
				MakeTween("2x1");
				MakeTween("2x2");
				MakeTween("3x1");
				MakeTween("4x2");
				MakeTween("5x1");
				MakeTween("5x2");
			};
		
			self:RunTween(Tween);
		end;
		
		TweenOffCommand=function(self)
			local function MakeTween(alpha)
				return function(self)
					self:stoptweening();
					self:linear(0.3);
					self:diffusealpha(0.5);
					self:linear(0.3);
					self:diffusealpha(0);
				end
			end;

			-- Tween random hexes, and always tween the ones we've shown, so they
			-- disappear.
			local HexesToTweenSet = { };
			for idx, name in ipairs({ "2x1", "2x2", "3x1", "4x2", "5x1", "5x2" }) do
				HexesToTweenSet[name] = true;
			end
			for i=1,5 do
				local idx = math.random(#hexes);
				HexesToTweenSet[hexes[idx].Name] = true;
			end

			local HexesToTween = { };
			for name, ignore in pairs(HexesToTweenSet) do
				HexesToTween[#HexesToTween+1] = name;
			end

			Shuffle(HexesToTween);

			local Tween = {
				{ Delay=0.3 },
				{ Interval=0.08, OnDuration=0.3, OffDuration=0.3 },
			};
			for i=1,#HexesToTween do
				Tween[#Tween+1] = {
					Name=HexesToTween[i];
					Tween=MakeTween(0);
				};
			end
			self:RunTween(Tween);
		end;


	};
};

local letters = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
};
t[#t+1] = letters;

local LetterOffset = { 0, 65, 130, 201, 274, 347, 418 };
for i=1,7 do
	local letter = Def.ActorFrame {
		TweenOnCommand = function(self)
--			local ClearedWidth = self:GetChild("Cleared"):GetWidth();
--			local distance = ClearedWidth+(SCREEN_WIDTH-ClearedWidth)/2;
--			(cmd(finishtweening;addx,distance;sleep,(i-1)*0.1;accelerate,0.8;addx,-distance))(self);
		end;
	};
	letter[#letter+1] = LoadActor("_letter mask") .. {
		InitCommand=cmd(zwrite,true;blend,"BlendMode_NoEffect";x,LetterOffset[i]);
	};

	-- The delay between each letter:
	local LetterDelay = (i-1)*0.05;

	-- The remaining delay, to sync the letters back up after the stagger:
	-- local LetterDelayRemainder = (7-i)*0.05;

	letter[#letter+1] = LoadActor("_cleared gradient") .. {
		Name="Cleared";
		InitCommand=cmd(ztest,true;ztestmode,"ZTestMode_WriteOnFail");
		SetOnCommand=cmd(diffusealpha,1);
		SetOffCommand=cmd(diffusealpha,0);
		TweenOnCommand=cmd(finishtweening;
			diffusealpha,0;sleep,0.2;sleep,LetterDelay;
			linear,0.4;diffusealpha,1;
			);
		TweenOffCommand=cmd(finishtweening;sleep,0.5;linear,0.5;diffusealpha,0);
	};

	local Bright = LoadActor("_cleared bright") .. {
		Name="Cleared";
		InitCommand=cmd(ztest,true;ztestmode,"ZTestMode_WriteOnFail");
		SetOffCommand=cmd(diffusealpha,0);
		TweenOnCommand=cmd(finishtweening;
			diffusealpha,0;sleep,0.2;sleep,LetterDelay;
			linear,0.4;diffusealpha,1);
		TweenOffCommand=cmd(finishtweening;sleep,0.5;linear,0.5;diffusealpha,0);
	};
	if ShowGoodCleared() then
		-- On GoodCleared, leave the glow part visible and apply a shimmer.
		Bright = Bright .. {
			InitCommand=cmd();
			SetOnCommand=cmd(diffusealpha,1);
		};
	else
		-- On not GoodCleared, hide the glow part after the transition.
		Bright = Bright .. {
			TweenOnCommand=cmd(linear,0.2;diffusealpha,0);
			SetOnCommand=cmd(diffusealpha,0);
		};
	end
	letter[#letter+1] = Bright;

	letter[#letter+1] = Def.Actor {
		InitCommand=cmd(clearzbuffer,true);
	};

	letters[#letters+1] = letter;
end;

local FlowerAnchor = {38,-108};
t[#t+1] = Def.ActorFrame {
	Name = "OOOSV_P2";
	InitCommand=cmd(visible,false;x,SCREEN_CENTER_X+80;y,SCREEN_CENTER_Y-55;zoom,0.3);

	Def.ActorFrame {
		InitCommand=cmd(x,152-FlowerAnchor[1];y,-144-FlowerAnchor[2]);

		SetOnCommand=cmd(finishtweening;rotationz,0);
		TweenOnCommand=cmd(finishtweening;
			rotationz,30;
			sleep,0.3;accelerate,0.15;rotationz,15;
			decelerate,0.15;rotationz,0);

--		SetOffCommand=cmd(diffusealpha,0);

		LoadActor("_ooosv flowers") .. {
			InitCommand=cmd(x,FlowerAnchor[1];y,FlowerAnchor[2]);
			SetOnCommand=cmd(finishtweening;diffusealpha,1);
			TweenOnCommand=cmd(finishtweening;
				diffusealpha,0;
				sleep,0.3;linear,0.3;diffusealpha,1;
				linear,0.3);

			SetOffCommand=cmd(finishtweening;diffusealpha,0);
			TweenOffCommand=cmd(finishtweening;sleep,0.5;linear,0.3;diffusealpha,0);
		};
	};

	LoadActor("_ooosv dude") .. {
		SetOnCommand=cmd(finishtweening;diffusealpha,1);
		TweenOnCommand=cmd(finishtweening;diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1);
		SetOffCommand=cmd(finishtweening;diffusealpha,0);
		TweenOffCommand=cmd(finishtweening;sleep,0.5;linear,0.3;diffusealpha,0);
	};
};

return t;

