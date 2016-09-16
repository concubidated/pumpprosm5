function MakeBeatDisplay()
	local fWidth = SCREEN_WIDTH*0.75;
	local f = Def.ActorFrame { };
	local bEnabled = false;

	-- The LED flashing is controlled by CrossedBeat, and the on-screen flashing
	-- is controlled by CrossedBeatVisible, so only the latter is affected by
	-- VisualDelaySeconds.
	f[#f+1] = Def.Actor {
		CrossedBeatMessageCommand=function(self, param)
			if not bEnabled then return end;

			debug_leds.set(true, 0);
			debug_leds.set(true, 1);
			debug_leds.set(true, 2);

			self:stoptweening();
			self:sleep(0.1);
			self:queuecommand("FlashOff");
		end;

		FlashOffCommand=function(self)
			debug_leds.set(false, 0);
			debug_leds.set(false, 1);
			debug_leds.set(false, 2);
		end;

		BeginCommand=function(self)
			bEnabled = true;
		end;

		EndCommand=function(self)
			self:stoptweening();
			bEnabled = false;
			debug_leds.release();
		end;
	};

	local FlashCommand = cmd(stoptweening;diffusealpha,1;sleep,0.1;diffusealpha,0);
	f[#f+1] = Def.Quad {
		InitCommand=cmd(setsize,fWidth,50);
		BeginCommand=cmd(diffusealpha,0);
		CrossedBeatVisibleMessageCommand=FlashCommand;
	};
	for i=0,3 do
		f[#f+1] = Def.Quad {
			InitCommand=cmd(diffuse,color("#00FFFF");setsize,fWidth*0.25,50;halign,0;x,scale(i, 0, 4, -fWidth/2,fWidth/2);effectoffset,-i);
			BeginCommand=cmd(diffusealpha,0);

			CrossedBeatVisibleMessageCommand=function(self, param)
				if math.fmod(param.Beat, 4) ~= i then return end;
				FlashCommand(self);
			end;
		};
	end
	return f;
end

local t = Def.ActorFrame {
	OnCommand=cmd(finishtweening;x,-852;decelerate,0.3;addx,852);
	OffCommand=cmd(finishtweening;accelerate,0.3;addx,852);
};

t[#t+1] = LoadActor( THEME:GetPathS("_common", "value") ) .. {
	DelayChangedMessageCommand=cmd(play);
}

t[#t+1] = MakeBeatDisplay() .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-100);
};

t[#t+1] = LoadFont("Common", "Normal") .. {
-- t[#t+1] = LoadFont("_venacti 22px bold") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+90;wrapwidthpixels,math.min(700, (640-20)/0.75);zoom,0.75);
	Text="Adjust the delay so the flashing box is in sync with the audio.\n\nFor precise calibration, attach a USB keyboard.  Adjust the delay so the flashing box is in sync with the flashing keyboard LEDs.";
}
t[#t+1] = LoadFont("Common", "Normal") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X-130;y,SCREEN_CENTER_Y-50;halign,0);
	DelayChangedMessageCommand=cmd(playcommand,"Refresh");
	BeginCommand=cmd(playcommand,"Refresh");
	RefreshCommand = function(self)
		local fDelay = PREFSMAN:GetPreference("VisualDelaySeconds");

		-- Invert the value, since we only allow setting negative values to compensate
		-- for lagged screens.  Don't invert 0, or we'll display -0.
		if fDelay ~= 0 then
			fDelay = -fDelay;
		end
		local sValue = string.format("Monitor delay: &MENULEFT; %03.0f ms &MENURIGHT;" , fDelay * 1000);
		self:settext( sValue );
	end;
}
t[#t+1] = LoadFont("Common", "Normal") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-15);
	Text="&START; Accept &SELECT; Reset";
};
return t;
