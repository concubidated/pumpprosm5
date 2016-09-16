local MaxGauntletLivesToShow = 30;
if SingleLifeMeter() then
	-- We have twice as much space in doubles, so allow showing more lives.
	MaxGauntletLivesToShow = 60;
end

-- Return the total width of the life meter: the size that the frame, etc. are
-- stretched to.
local function LifeMeterTotalWidth()
	-- The number of pixels we can overlap when we're pressed for space.  We can
	-- cut off the edges of the life meter slightly.
	local PermissibleOverlap = 20;

	-- The max size is 784px.  Above that, clamp to 784.  At 640, give PermissibleOverlap
	-- extra pixels for space.
	local MaxSize = math.min(784, SCREEN_WIDTH);
	return scale_clamp(MaxSize, 640, 784, 640+PermissibleOverlap, 784);
end

local GauntletLivesWidthSingle = 33;
-- Return the exact visible size of the life meter.
local function LifeMeterWidth()
	if SingleLifeMeter() then
		-- 90px of padding on both sides.
		return (LifeMeterTotalWidth())-90-90
	else
		-- 90px of padding on the left; 5 in the middle.
		local width = (LifeMeterTotalWidth()/2)-90-5;

		-- In non-doubles Gauntlet, shrink the life meter to make room for lives.
		if IsGauntlet() and not SingleLifeMeter() then
			width = width - GauntletLivesWidthSingle;
		end
		return width;
	end
end

local FrameStretchOnCommand = function(self, ...)
	self:stoptweening();
	-- Minimum width is the sum of the static parts below.  If the
	-- width is any smaller, static parts will start to flex, too.
	--self:playcommand( "SetSize", { Width=422 } );

	--self:RunCommandsRecursively( cmd(sleep,1.5) );
	--self:RunCommandsRecursively( cmd(linear,0.1) );
	--self:playcommand( "SetSize", { Width=SCREEN_WIDTH, tween = cmd(linear,0.1); } );
	--self:playcommand( "SetSize", { Width=SCREEN_WIDTH; } );
end

-- In normal play, the left side is for P1 and the right side is for P2.  In
-- doubles and routine modes, the master player is always on the left.  If MasterPlayer
-- is P2, then put it on the right.
local Player = {};
for pn in ivalues(PlayerNumber) do
	Player[pn] = pn;
end
if SingleLifeMeter() and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
	Player[PLAYER_1] = PLAYER_2;
	Player[PLAYER_2] = PLAYER_1;
end

-- This is like IsHumanPlayer, except for Routine.  In Routine, we have two
-- human players, but only one is shown.
local IsDisplayedPlayer = {};
if IsRoutine() then
	for pn in ivalues(PlayerNumber) do
		IsDisplayedPlayer[pn] = false;
	end
	IsDisplayedPlayer[GAMESTATE:GetMasterPlayerNumber()] = true;
else
	for pn in ivalues(PlayerNumber) do
		IsDisplayedPlayer[pn] = GAMESTATE:IsHumanPlayer(pn);
	end
end

-- The distance between the edge of the screen and the start of the life meter.
local LifeMeterX = (SCREEN_WIDTH - LifeMeterTotalWidth())/2;

-- The outer edge of each player's meter.
local MeterX = {
	[PLAYER_1] = SCREEN_LEFT+LifeMeterX+90,
	[PLAYER_2] = SCREEN_RIGHT-LifeMeterX-90,
};

-- Load a stretchy life meter part.  These stretch differently if they're doubles parts;
-- just stretch based on the mode, since the unused part will never be displayed.
local function LoadLifeMeterFramePart(f)
	return LoadActor( THEME:GetPathG("_frame", "1D"),
		-- static  flex    static  flex     static  flex     static  flex    static
		{ 121/784, 80/784, 48/784, 106/784, 74/784, 106/784, 48/784, 80/784, 121/784 },
		LoadActor( f )
	) .. {
		InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+32;playcommand, "SetSize", { Width=LifeMeterTotalWidth(); });
		--OnCommand = FrameStretchOnCommand;
	};
end

local function ProgressMeterWidth(source)
	-- The progress meter is the size of parts 3, 4, 5, 6 and 7 of the flex
	-- frame, minus a fixed amount.  We need to be given an active flex frame
	-- to derive this.
	local width = 0;
	for idx=3,7 do
		width = width + source:GetChild(idx):GetZoomedWidth();
	end
	return width - 6*2; -- 6px less on each side
end

--[[
local function VersusMeter()
	local c;
	local PlayerStats;

	local function Shown()
		if not GAMESTATE:IsHumanPlayer(PLAYER_1) or not GAMESTATE:IsHumanPlayer(PLAYER_2) then
			return false;
		end

		if PlayerStats[1]:GetPossibleDancePoints() ~= PlayerStats[2]:GetPossibleDancePoints() then
			return false;
		end

		if GAMESTATE:IsCourseMode() then
			if GAMESTATE:GetCurrentTrail(PLAYER_1) ~= GAMESTATE:GetCurrentTrail(PLAYER_2) then
				return false;
			end
		else
			if GAMESTATE:GetCurrentSteps(PLAYER_1) ~= GAMESTATE:GetCurrentSteps(PLAYER_1) then
				return false;
			end
		end
		return true;
	end

	local Meter = Def.ActorFrame {
		Name = "VersusHighlightFrame";
		LoadActor( "versus highlight" ) ..  {
			Name = "VersusHighlight";
			OnCommand=cmd(diffusealpha,0;sleep,1.9;smooth,0.3;diffusealpha,1);
		};

		-- Delay processing JudgmentMessageCommand a bit, so we don't
		-- jitter a lot when two inputs are only slightly apart.
		Def.Actor {
			JudgmentMessageCommand=function(self, param)
				self:stoptweening();
				self:sleep(.080);
				self:queuecommand("SendUpdate");
			end;
			SendUpdateCommand=function(self, param)
				self:GetParent():playcommand("Update");
			end;
		};

		InitCommand = function(self)
			c = self:GetChildren();
			(cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+32-24))(self);
		end;

		BeginCommand=function(self, param)
			local Stats = STATSMAN:GetCurStageStats();
			PlayerStats = { Stats:GetPlayerStageStats(PLAYER_1), Stats:GetPlayerStageStats(PLAYER_2) };

			if not Shown() then
				self:visible(false);
				return;
			end

			self:visible(true);
		end;

		UpdateCommand=function(self, param)
			local Actual = { PlayerStats[1]:GetActualDancePoints(), PlayerStats[2]:GetActualDancePoints() };
			local iDiffPoints = Actual[2] - Actual[1];

			local bNegative = (iDiffPoints < 0);
			iDiffPoints = math.abs(iDiffPoints);

			--
			-- Scale the motion.  A large portion of the inside of the meter is expanded
			-- significantly, so individual points can be distinguished; if one player
			-- gets a W1 and the other gets a W2, the change in points should be visible.
			-- If one player is winning by one point, it should be clearly visible.
			--
			-- Outside that area, motion slows down.
			--
			-- Scale motion based on the actual points, and not based on possible
			-- points, so motion is constant based on the judgments received, and not
			-- scaled down and harder to read for harder songs.
			--
			
			local iPixelsPerPoint = 8; -- the width of the bright part of the highlight
			local iMaxWidthPixels = (SCREEN_WIDTH-35) / 2; -- in one direction
			local iCloseCallPixels = iMaxWidthPixels * 0.25;
			local iCloseCallPoints = iCloseCallPixels / iPixelsPerPoint;

			local iX;
			if iDiffPoints < iCloseCallPoints then
				-- Near the center, expand the distance per point, so individual
				-- points can be distinguished; if one player gets a W1 and the
				-- other player gets a W2, the change in points should be visible.
				iX = scale( iDiffPoints, 0, iCloseCallPoints, 0, iCloseCallPixels );
			else
				local iNonCloseCallPoints = 100;

				iDiffPoints = iDiffPoints - iCloseCallPoints;
				iDiffPoints = iDiffPoints / iNonCloseCallPoints;
				iDiffPoints = clamp( iDiffPoints, 0, 1 );

				-- Decelerate as we approach the edge.
				iDiffPoints = 1-((1-iDiffPoints)*(1-iDiffPoints));
				iX = scale( iDiffPoints, 0, 1, iCloseCallPixels, iMaxWidthPixels );
			end

			if bNegative then iX = -iX; end

			c.VersusHighlight:stoptweening();
			local fOldX = c.VersusHighlight:GetX();
			
			local fDistX = math.abs(iX - fOldX);
			c.VersusHighlight:linear(0.05);
			c.VersusHighlight:x( iX );
		end;
	};
	return Meter;
end
]]

local TopFrame = Def.ActorFrame {
	OnCommand = function(self, ...)
		self:addy(-100);
		self:sleep(1.0);
		self:decelerate(0.4);
		self:addy(100);
	end;
--[[
	-- progress bar off mask
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+8;setsize,SCREEN_WIDTH,32;blend,"BlendMode_NoEffect";zwrite,true;zbias,1);
	};
]]
	-- Load a dummy life meter part.  We'll pass this to ProgressMeterWidth so it
	-- can compute how wide the progress meter needs to be.
	LoadLifeMeterFramePart("top frame 1") .. {
		Name="Dummy";
		InitCommand = cmd(visible,false);
	};

	-- progress bar on mask
	Def.SongMeterDisplay {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+6);
		Stream = LoadActor("progress bar");
		Tip = LoadActor( "progress tip" ) .. {
			InitCommand=cmd(halign,0);
		--	OnCommand=cmd(diffusealpha,0;sleep,0.5;diffusealpha,1);
		};
		BeginCommand=function(self)
			local Dummy = self:GetParent():GetChild("Dummy");
			local Width = ProgressMeterWidth(Dummy);
			self:SetStreamWidth(Width);
		end;
	};

	--VersusMeter();

	Def.Quad { InitCommand=cmd(diffusealpha,0;clearzbuffer,true); };
};

TopFrame[#TopFrame+1] = LoadActor( THEME:GetPathS(Var "LoadingScreen", "player failed") ) .. {
	SupportPan = true;

	PlayerFailedMessageCommand=function(self, params)
		if IsRoutine() and GAMESTATE:GetMasterPlayerNumber() ~= params.PlayerNumber then
			-- The hidden player for the dummy player will always fail.  Ignore it.
			return;
		end
		self:playforplayer(params.PlayerNumber);
	end;
};

-- Load the lower mask.  This clips everything inside the life meter itself from
-- spilling into the progress meter.
TopFrame[#TopFrame+1] = LoadLifeMeterFramePart("meter mask") .. {
	InitCommand = cmd( RunCommandsRecursively,(cmd(blend,"BlendMode_NoEffect";zwrite,true;zbias,5)) );
};

TopFrame[#TopFrame+1] = LoadLifeMeterFramePart("meter under") .. {
};
--[[
for pn in ivalues(PlayerNumber) do
	TopFrame[#TopFrame+1] = Def.ActorFrame {
		InitCommand=cmd(x,MeterX[pn]);
		LoadActor("meter under") .. {
			Name = "Under"; 
			InitCommand=cmd(
				y,SCREEN_TOP+30;
				zoomx,pn == PLAYER_1 and 1 or -1
			);
			BeginCommand=cmd(
				zoomtowidth,LifeMeterWidth();
				x,LifeMeterWidth()/2 * (pn == PLAYER_1 and 1 or -1);
				visible,GAMESTATE:IsHumanPlayer(pn)
				);
		--	OnCommand=cmd(diffusealpha,0;sleep,1.7;linear,0.2;diffusealpha,1);
		--	OffCommand=cmd(zoomx,1;linear,0.3;zoomx,0);
		};
	};
end
]]
local function Quantize( f, fRoundInterval ) return math.floor( (f + fRoundInterval/2)/fRoundInterval ) * fRoundInterval end

local function MakeLifeMeterLives(pn, frame)
	local f = Def.ActorFrame {
		LoadActor(frame) .. {
			InitCommand=cmd(zoomx,pn == PLAYER_1 and 1 or -1);
		};
	};

	f[#f+1] = LoadFont("_venacti 18px shadow") .. {
		Name = "LivesLeft";
		InitCommand=cmd(zoom,0.5;shadowlength,0;x,0);
		BeginCommand=cmd(playcommand,"Update");
		ChangedNumLivesMessageCommand=function(self, param)
			if param.Player ~= pn then return end
			self:playcommand("Update");
			self:settext(param.LivesLeft);
		end;

		UpdateCommand=function(self, param)
			local meter = SCREENMAN:GetTopScreen():GetLifeMeter(pn);
			if meter then
				self:settext(meter:GetLivesLeft());
			end
		end;
	};
	return f;
end;


local function MakeLifeMeter(side)
	local c;
	local pn = Player[side];
	if not IsDisplayedPlayer[pn] then
		return Def.Actor {};
	end

	-- The actual size of the life meter and segments is dynamic.  
	-- In internal coordinates, each segment is WidthPerSegment pixels wide.  If
	-- we render this directly, we'll end up with ugly aliasing.  Adjust the
	-- spacing so the width of segments in the framebuffer ends is an integer.
	local fDisplayWidth = DISPLAY:GetDisplayWidth();
	local fScreenWidth = SCREEN_WIDTH;
	local LifeMeterAdjustRatio = fScreenWidth/fDisplayWidth;
	-- 1/4 -> *4 is fine (== 1)
	-- 1/3 -> *3
	-- 2/3 -> *2 -> 4/3
	local fAdjusted = math.floor( 1/LifeMeterAdjustRatio + 0.5 );
	if fAdjusted > 0.001 then
		LifeMeterAdjustRatio = LifeMeterAdjustRatio*fAdjusted;
	end;

	-- Create the ticks sprite with a width of the actual screen resolution it'll be
	-- displayed at.  If the internal size is 100 pixels, but it'll be stretched to
	-- 150 real framebuffer pixels, then render it to 150 pixels, so each texel in the
	-- sprite becomes one pixel in the framebuffer.
	local TicksWidth = LifeMeterWidth();
	TicksWidth = TicksWidth/LifeMeterAdjustRatio;

	-- This will be the final, zoomed size of the ticks.  The rest of the
	-- life meter is sized to match it.
	local MeterWidth = LifeMeterWidth();

	-- The honeycomb texture is 1024px.  To avoid blurring it, never scale it; leave it
	-- zoomed at 1.0, and crop it.
	local HexFullPercent = MeterWidth/1024;

	-- Size each segment to fit the number we want.  Since the sprite is rendered with
	-- unfiltered quads (see life meter ticks.lua), the borders dividing the segment will
	-- always have a fixed width.  When the segments don't divide evenly into TicksWidth,
	-- it's the space between the border ticks that will vary, not the ticks themselves.
	local WidthPerSegment;
	local function SetWidthPerSegment(width)
		assert(c);
		WidthPerSegment = width;
		c.Tick:SetDistanceBetweenTicks(WidthPerSegment);
	end
	local function SetNumberOfSegments(NumberOfSegments)
		assert(c);

		WidthPerSegment = TicksWidth / NumberOfSegments;
		c.Tick:SetDistanceBetweenTicks(WidthPerSegment);
	end

	local meter;
	local function Update(self)
		if not meter then
			return;
		end

		local original_life = meter:GetLife();
--original_life=0;
		if meter.GetTotalLives then
			-- In Gauntlet, clamp the max number of lives we show as segments.
			local max_lives = meter:GetTotalLives();
			local cur_lives = meter:GetLivesLeft();
			max_lives = math.min(max_lives, MaxGauntletLivesToShow);
			cur_lives = math.min(cur_lives, MaxGauntletLivesToShow);
			original_life = cur_lives / max_lives;
		end

--		original_life = c.HexTweenHelper:GetSecsIntoEffect() / 4;
--		original_life = 1;
--		original_life = 0.02;
		local life = original_life;

		if c.TweenHelper:GetTweenTimeLeft() ~= 0 then
			life = c.TweenHelper:getaux();
		end;

		local fBeat = GAMESTATE:GetSongBeatVisible();
		local fBeatFract = fBeat % 1;

		if c.Grad:GetTweenTimeLeft() == 0 then
			-- Each section in the texture is WidthPerSegment texels wide, including 2 pixels
			-- of separator on the right edge.  The whole life meter is ideally
			-- LifeMeterWidth wide, and exactly MeterWidth wide (MeterWidth*LifeMeterAdjustRatio
			-- pixels).  full width (no crop) = MeterWidth; 
			local fSectionWidth = WidthPerSegment*LifeMeterAdjustRatio;
			local fSeparatorWidth = 2*LifeMeterAdjustRatio;
			local fPulseSections = 3;

			-- Life ranges from 0 (empty) to 1 (full).  Scale it up a little, so
			-- the life range is something like [0,1.05].  At exactly 1, the whole
			-- life meter will be visible, but we'll still be pulsing.  When at its
			-- full scaled value (when the original value of life reaches 1), we'll
			-- be overfilled, so the pulsing won't be visible anymore; it'll be happening
			-- above 1.0 so it has no effect.
			--
			-- The exact amount we scale is the width of the sections that are pulsing,
			-- scaled down to the life meter space.
			--
			-- We don't pulse in Gauntlet and we show an exact number of life segments,
			-- so don't do this in Gauntlet.
			if not IsGauntlet() then
				local ExtraMeterWidth = ((fSectionWidth+fSeparatorWidth)*fPulseSections);
				local ExtraMeterPercent = ExtraMeterWidth / MeterWidth;
				-- Tricky: Only apply scaling past 50%, so when we start play at
				-- 50% life the meter fill is centered; this is especially visible
				-- in doubles.
				if life >= 0.5 then
					life = scale(life, 0.5, 1.0, 0.5, 1+ExtraMeterPercent);
				end

--				life = life * (1+ExtraMeterPercent);
			end

			local fPos = life;
			fPos = fPos * MeterWidth;
			fPos = Quantize(fPos, fSectionWidth);
			fPos = fPos - fSeparatorWidth;
			fPos = fPos / MeterWidth;

			local fPulseDistance = (fPulseSections * fSectionWidth);
			fPulseDistance = fPulseDistance / MeterWidth;

			local fTipPos = math.min(life, 1.0) * MeterWidth;
			fTipPos = Quantize(fTipPos, fSectionWidth);
			fTipPos = fTipPos - fSeparatorWidth/2;

			local fFlip = (side == PLAYER_1 and 1 or -1 );
			c.Tip:x( MeterX[side] + (fTipPos * fFlip) );
			c.Tip:visible( fTipPos >= 0.01 );
			local fVisible = scale( life, 0.95, 1.00, 1, 0 );
			c.Tip:basealpha(fVisible);

			if not IsGauntlet() then
				local fPulse = scale( fBeatFract, 0.0, 0.25, 0, fPulseDistance );
				fPulse = clamp( fPulse, 0, fPulseDistance );
				if c.TweenHelper:GetTweenTimeLeft() ~= 0 then
					fPulse = fPulseDistance;
				end;
				fPos = fPos - fPulse;
			end

			c.HexMask:cropleft( fPos );
			c.Grad:cropright( 1-fPos );
			
			local FadePos = c.HexTweenHelper:GetSecsIntoEffect() / 4;
			FadePos = scale( FadePos, 0, 1, -0.65, 1 );
			c.Hex:fadeleft(0.2);
			c.Hex:faderight(0.2);
			c.Hex:cropleft(FadePos);
			c.Hex:cropright(1-(FadePos+0.65));
		end

		--if not IsGauntlet() then
			local DangerAlpha = scale_clamp( original_life, 0.1, 0.25, 0.8, 0 );
			c.Danger:stoptweening();
			local OldDangerAlpha = c.Danger:GetDiffuseAlpha();
			c.Danger:linear(math.abs(OldDangerAlpha - DangerAlpha) * 1);
			c.Danger:diffusealpha(DangerAlpha);
		--end

		-- This doesn't follow aux.
		local fFillVisible = scale_clamp( original_life, 0.80, 0.90, 0, 1 );
		c.Filled:diffusealpha(fFillVisible);
		c.FilledHex:diffusealpha(fFillVisible);

		local fFilledHexCrop = scale_clamp( original_life, 0.80, 1.00, 0.15, -0.25 );
		c.FilledHex:cropright( fFilledHexCrop );
		c.FilledHex:cropleft( fFilledHexCrop );
	end

	local f = Def.ActorFrame {
		Def.Quad {
			Name = "HexMask";
		};

		LoadActor("meter tip") .. { Name = "Tip"; };
		LoadActor("meter grad") .. { Name = "Grad"; };
		LoadActor("meter danger") .. { Name = "Danger"; };
		LoadActor("meter honeycomb") .. { Name = "Hex"; };
		LoadActor("life meter ticks", TicksWidth) .. { Name = "Tick"};
		LoadActor("meter filled color") .. { Name = "Filled"; };
		LoadActor("meter honeycomb") .. { Name = "FilledHex"; };
		LoadActor("meter danger") .. { Name = "Dead"; };
		Def.Actor {
			Name = "TweenHelper";
		};
		Def.Actor {
			Name = "HexTweenHelper";
		};
	};

	if IsGauntlet() then
		if SingleLifeMeter() then
			f[#f+1] = MakeLifeMeterLives(pn, "lives frame double") .. {
				OnCommand=cmd(x,MeterX[side]+MeterWidth/2;y,6);
			};
		else
			local X = MeterX[PLAYER_1]+MeterWidth-18+GauntletLivesWidthSingle;
			if pn == PLAYER_2 then X = SCREEN_WIDTH - X; end
			f[#f+1] = MakeLifeMeterLives(pn, "lives frame single") .. {
				OnCommand=cmd(x,X;y,6);
			};
		end
	end

		f.InitCommand = function(self)
			self:SetUpdateFunction( Update );

			self:y(SCREEN_TOP+21);
			c = self:GetChildren();
			c.Tick = c.Tick.sprite;

			local f = cmd(
				zoomx,side == PLAYER_1 and 1 or -1;
				ztest,true;
				halign,0;
				x,MeterX[side]
			);
			f(c.Grad);
			f(c.Danger);
			f(c.Tick);
			f(c.Filled);
			f(c.FilledHex);
			f(c.Hex);
			f(c.HexMask);
			f(c.Dead);
		--	f(c.PlayerName);
		end;

		f.BeginCommand=function(self)
			self:visible(IsDisplayedPlayer[pn]);
			if not IsDisplayedPlayer[pn] then
				return;
			end

			meter = SCREENMAN:GetTopScreen():GetLifeMeter(pn);
			if meter.GetTotalLives then
				local lives = meter:GetTotalLives();
				lives = math.min(lives, MaxGauntletLivesToShow);
				SetNumberOfSegments(lives);
			else
				SetWidthPerSegment(10);
			end
			c.Tick:SetDistanceBetweenTicks(WidthPerSegment);
			c.Tick:SetTextureFiltering(false);
			c.Tick:SetWidth( MeterWidth );

			c.Grad:SetWidth( MeterWidth );
			c.Grad:diffusealpha(1);

			c.Danger:SetWidth( MeterWidth );
			c.Danger:diffuse(color("#C0C0C0"));
			c.Danger:diffusealpha(0);
			c.Dead:SetWidth( MeterWidth );
			c.Dead:diffuse(color("#909090"));
			c.Dead:diffusealpha(0);

			-- "meter mask" is at zbias 5, and masks all of these parts of the
			-- life meter that shouldn't spill into the progress meter.
			-- HexMask is at zbias -1; this is only used to mask the hex pattern.
			-- Most of the elements here sit at the default zbias 0, which is below
			-- just "meter mask".  HexMask is at -2, so it sits below HexMask, too.

			-- Move HexMask down, so it doesn't cover the regular life meter elements
			-- and only masks c.Hex.
			c.HexMask:diffuse(color("#FF00FF"));
			(cmd(blend,"BlendMode_NoEffect";zwrite,true;zbias,-1))(c.HexMask);
			c.HexMask:setsize(MeterWidth, 32);

			c.Hex:zbias(-2);
			c.Hex:setsize(MeterWidth, 32);
			c.Hex:SetCustomImageRect( 0, 0, HexFullPercent, 1 );
			c.Hex:diffusealpha( 0.4 );

			c.Filled:visible(false);
			c.FilledHex:visible(false);

			c.Filled:setsize(MeterWidth, 32);
			c.Filled:SetCustomImageRect( 0, 0, HexFullPercent, 1 );
			c.FilledHex:setsize(MeterWidth, 32);
			c.FilledHex:SetCustomImageRect( 0, 0, HexFullPercent, 1 );
			c.FilledHex:fadeleft(0.25);
			c.FilledHex:faderight(0.25);
--			c.FilledHex:diffusealpha( 0.4 );

--			c.Filled:y(100);
--			c.FilledHex:y(100);

			--c.Filled:glowshift();
			--c.Filled:effectclock("beat");
			--c.Filled:effectperiod(1.000);
			--c.Filled:effectcolor1(color("#FFFFFF00"));
			--c.Filled:effectcolor2(color("#FFFFFF40"));

			c.Tip:ztest(true);
			c.Tip:zoomx(LifeMeterAdjustRatio);

			-- c.Tick has been expanded so each tick lines up with the framebuffer.  We also
			-- need to move it to the left, so it starts on an even pixel, too, or the whole
			-- thing will be misaligned.  Make this adjustment on the whole layer, so all of the
			-- parts that line up with the ticks (tip, grad) will automatically receive the same
			-- adjustment, regardless of how they're positioned or stretched.
			local fSnappedX = math.floor( c.Tick:GetX()/LifeMeterAdjustRatio )*LifeMeterAdjustRatio;
			local fXAdjust = fSnappedX - c.Tick:GetX();
			self:addx( fXAdjust );
		end;
		f.HealthStateChangedMessageCommand = function(self, params)
			if params.PlayerNumber ~= pn then return; end
			local bDanger = params.HealthState == "HealthState_Danger" or
				params.HealthState == "HealthState_Dead";
--			c.Danger:stoptweening();
--			c.Danger:linear(0.3);
--			c.Danger:diffusealpha(bDanger and 1 or 0);
		end;

		f.OnCommand=function(self)
			(cmd(finishtweening;diffusealpha,1;fadeleft,0.25;cropleft,1;sleep,2.0;linear,0.3;cropleft,-0.25;
			     linear,0.2;diffusealpha,0.4))(c.Tick);

			c.TweenHelper:aux(0.0);
			c.TweenHelper:sleep(2.0);
			c.TweenHelper:decelerate(0.3);
			c.TweenHelper:aux(meter:GetLife());

			c.HexTweenHelper:effectperiod(4);
		end;

		f.PlayerFailedMessageCommand=function(self, params)
			if params.PlayerNumber ~= pn then return; end

			(cmd(finishtweening;diffusealpha,1;faderight,0.25;cropright,1;decelerate,0.3;cropright,-0.25))(c.Dead);
		end;

	return f;
end

for side in ivalues(PlayerNumber) do
	TopFrame[#TopFrame+1] = MakeLifeMeter(side);
end

--Overlay[#Overlay+1] = LoadActor("life meter tick", 8);
--TopFrame[#TopFrame+1] = LoadActor("life meter tick", 8) .. { InitCommand=cmd(x,300;y,300); };
for side in ivalues(PlayerNumber) do
	-- The origin of this frame is the outer edge of the life meter for each player.

	-- The bubble width depends on the stretchiness of the life meter.  Don't try to
	-- calculate where each part will end; instead, figure out the left and right boundaries
	-- (which is easy) and take the difference.
	local Bubble;
	if SingleLifeMeter() then
		Bubble = {
			Outer = 60,	-- The bubble starts 60px from the left edge of the life meter frame.
			Inner = 60	-- The bubble ends 60px from the right edge.
		};
	else
		Bubble = {
			Outer = 60,	-- The bubble starts 60px from the outer edge of the life meter frame.
			Inner = 17	-- The bubble ends 17px from the inner edge.
		};
	end

	-- The distance from this frame's origin to the center of the life meter.
	local LifeMeterCenter = LifeMeterTotalWidth()/2;

	-- 14px on each side is glow padding and border, not the body of the bubble.
	local BubblePadding = 15*2;

	local function LoadBubblePart(part)
		return LoadActor( THEME:GetPathG("_frame", "1D"),
			-- static  flex    static
			{ 15/348, 318/348, 15/348 },
			LoadActor(part)
		);
	end

	local pn = Player[side];
	local fFlip = (side == PLAYER_1 and 1 or -1 );
	local PlayerFrame = Def.ActorFrame {
		LoadBubblePart("difficulty bubble border") .. {
			Name="BubbleBorder";
		};
		LoadBubblePart("difficulty bubble color") .. {
			Name="BubbleColor";
		};

		InitCommand=cmd(x,SCREEN_CENTER_X-LifeMeterTotalWidth()/2*fFlip;y,SCREEN_TOP+44);
		BeginCommand=function(self)
			local BubbleLeft = Bubble.Outer;
			local BubbleRight;

			if SingleLifeMeter() then
				-- The right edge of the doubles bubble is at the right edge.
				BubbleRight = LifeMeterTotalWidth() - Bubble.Inner;
			else
				-- ... but on the normal life meter, it's anchored to the center.
				BubbleRight = LifeMeterCenter - Bubble.Inner;
			end
			local BubbleCenter = (BubbleRight - BubbleLeft) / 2;
			local BubbleWidth = (BubbleRight-BubbleLeft) + BubblePadding;

			self:visible(IsDisplayedPlayer[pn]);
			if not IsDisplayedPlayer[pn] then return end

			local c = self:GetChildren();

			for child in ivalues({ c.BubbleBorder, c.BubbleColor }) do
				child:playcommand( "SetSize", { Width=BubbleWidth } );
--				child:zoomx(side == PLAYER_1 and 1 or -1);
				child:x((BubbleCenter + Bubble.Outer) * fFlip);
			end

			local Selection = GAMESTATE:GetCurrentTrail(pn) or GAMESTATE:GetCurrentSteps(pn)

			local CustomDifficulty = StepsOrTrailToCustomDifficulty(Selection);
			local DifficultyColor = CustomDifficultyToColor(CustomDifficulty);
			c.BubbleColor:RunCommandsRecursively( cmd(diffuse,DifficultyColor) );

			-- Make a copy, so we don't inadvertently modify the static custom difficulty table.
			local DifficultyColor = {DifficultyColor[1], DifficultyColor[1], DifficultyColor[2], DifficultyColor[4]};

			-- Shift the border color towards white.
			Trace(DifficultyColor[1]);
			for x=1,3 do
				DifficultyColor[x] = 1 - ((1-DifficultyColor[x]) * 0.25);
			end
			c.BubbleBorder:RunCommandsRecursively( cmd(diffuse,DifficultyColor) );
		end;
	};

	TopFrame[#TopFrame+1] = PlayerFrame;
end

TopFrame[#TopFrame+1] = LoadLifeMeterFramePart("top frame 1") .. { OnCommand = cmd(hide_if,not SingleLifeMeter()); };
TopFrame[#TopFrame+1] = LoadLifeMeterFramePart("top frame 2") .. { OnCommand = cmd(hide_if,SingleLifeMeter()); };

TopFrame[#TopFrame+1] = LoadFont("_venacti 18px shadow") .. {
	InitCommand = cmd(zoom,.52;maxwidth,470;settext,"TITLE";x,SCREEN_CENTER_X;y,6;shadowlength,0;playcommand,"Title");
	CurrentSongChangedMessageCommand=cmd(playcommand,"Title");
	TitleCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		local course = GAMESTATE:GetCurrentCourse();
		local text = ""
		if song then
			text = song:GetDisplayFullTitle()
		end
		if course then
			text = course:GetDisplayFullTitle() .. " - " .. text;
		end
		self:settext( text )
		end;
};

local function MakeStageCreditIcons(pn)
	local Icon = LoadActor("stage credit icon") .. { InitCommand=cmd(pause) };

	local Total;
	if GAMESTATE:IsCourseMode() then
		Total = GAMESTATE:GetCurrentCourse():GetEstimatedNumStages();
	else
		Total = PREFSMAN:GetPreference("SongsPerPlay");
	end

	-- With three stages, prefer to show the icons across 20 pixels.  With more,
	-- stretch it to up to 28.
	local Width = scale_clamp(Total, 3, 5, 20, 28);
	if Total == 2 then Width = 15; end -- special case; 1 doesn't matter (always centered)
	local t = Def.ActorFrame {
	};
	for i = 1,Total do
		local function Lit()
			if not GAMESTATE:IsHumanPlayer(pn) then return false; end;
			local IconsToLight;
			if GAMESTATE:IsCourseMode() then
				IconsToLight = GAMESTATE:GetLoadingCourseSongIndex() + 1;
			else
				-- +1 because our current stage has already been counted as used
				local StagesLeft = GAMESTATE:GetNumStagesLeft(pn)+1;
				IconsToLight = scale(StagesLeft, 1, Total, Total, 1);
			end
			return i <= IconsToLight;
		end;
		t[#t+1] = Icon .. {
			InitCommand = cmd(x,scale(i, 1, Total, -Width/2, Width/2));
			BeginCommand=cmd(setstate,Lit() and 0 or 1);
			ChangeCourseSongOutMessageCommand=cmd(playcommand,"Refresh");
			OnCommand=cmd(diffusealpha,0;zoom,0;sleep,1.7+0.1*(i-1);linear,0.3;zoom,1;diffusealpha,1);
			RefreshCommand=cmd(setstate,Lit() and 0 or 1);
		};
	end
	return t;
end;

TopFrame[#TopFrame+1] = MakeStageCreditIcons(PLAYER_1) .. {
	InitCommand=cmd(x,SCREEN_LEFT+LifeMeterX+82;y,SCREEN_TOP+34);
};
TopFrame[#TopFrame+1] = MakeStageCreditIcons(PLAYER_2) .. {
	InitCommand=cmd(x,SCREEN_RIGHT-LifeMeterX-82;y,SCREEN_TOP+34;zoomx,-1);
};



for side in ivalues(PlayerNumber) do
	local pn = Player[side];
	local fFlip = (side == PLAYER_1 and 1 or -1 );

	local PlayerFrame = Def.ActorFrame {
		LoadActor(side == PLAYER_1 and "difficulty color p1" or "difficulty color p2") .. {
			Name="Color";
			InitCommand=cmd(x,66 * fFlip;y,17);
		};
		LoadActor(side == PLAYER_1 and "difficulty frame p1" or "difficulty frame p2") .. {
			InitCommand=cmd(x,66 * fFlip;y,17);
		};
		LoadFont("_venacti 15px bold") .. {
			Name="Meter";
			InitCommand=cmd(x,68 * fFlip;y,17;shadowlength,1);
		};

		InitCommand=cmd(x,SCREEN_CENTER_X-LifeMeterTotalWidth()*fFlip/2;y,SCREEN_TOP);

		BeginCommand=function(self)
			local c = self:GetChildren();

			local Selection = GAMESTATE:GetCurrentTrail(pn) or GAMESTATE:GetCurrentSteps(pn)
			local DifficultyColor;
			if IsDisplayedPlayer[pn] then
				DifficultyColor = StepsOrTrailToColor(Selection);
			else
				DifficultyColor = color("#404040");
			end
			c.Color:diffuse(DifficultyColor);
			if Selection then
				c.Meter:settext(Selection:GetMeter());
			end;
			c.Meter:visible(IsDisplayedPlayer[pn]);
		end;
	}

	TopFrame[#TopFrame+1] = PlayerFrame;
end

local Overlay = Def.ActorFrame {
	TopFrame,
};

if Var "LoadingScreen" ~= "ScreenDemonstration" then
	local LastCoins = 0;
	local CreditsString = THEME:GetString("ScreenSystemLayer", "CreditsCredits");

	CreditsText = LoadFont("_venacti 26px bold diffuse") .. {
		InitCommand=cmd(
			shadowlength,1;
			visible,GAMESTATE:GetCoinMode() == "CoinMode_Pay";
			x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-10;zoom,0.5;
			playcommand,"Update";
		);

		CoinInsertedMessageCommand=cmd(playcommand,"Update");
		UpdateCommand=function(self)
			local Coins = GAMESTATE:GetCoins();
			if Coins == 0 then
				self:settext( "" );
				return;
			end
			if LastCoins == 0 then
				self:addy(30);
				self:smooth(0.3);
				self:addy(-30);
			end
			LastCoins = Coins;

			local CoinsPerCredit = PREFSMAN:GetPreference("CoinsPerCredit");
			local Credits = math.floor(Coins / CoinsPerCredit);
			local RemainingCoins = Coins % CoinsPerCredit;
			local s = CreditsString .. ": ";
			if Credits > 0 or CoinsPerCredit == 1 then
				s = s .. tostring(Credits);
			end
			
			if CoinsPerCredit > 1 then
				s = s .. "  " .. tostring(RemainingCoins) .. "/" .. tostring(CoinsPerCredit);
			end
			self:settext( s );
		end;
	};
	Overlay[#Overlay+1] = CreditsText;
end

return Overlay;
