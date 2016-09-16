local t = Def.ActorFrame {
	OffCommand=function(self)
		local AnySavesFailed = false;
		local TweenTime = 0;
		local screen = SCREENMAN:GetTopScreen();
		for pn in ivalues(PlayerNumber) do
			if screen:ErrorSavingProfile(pn) then
				Trace( "Error saving " .. pn );
				local ErrorText = self:GetChild("ErrorTextP" .. (pn == PLAYER_1 and "1" or "2"));

				if MEMCARDMAN:GetCardState(pn) == "MemoryCardState_Removed" then
					ErrorText:playcommand("SetCardGone");
				else
					ErrorText:playcommand("SetDefaultError");
				end

				AnySavesFailed = true;
				ErrorText:playcommand("Show");
				ErrorText:sleep(2.5);
				TweenTime = ErrorText:GetTweenTimeLeft();
				ErrorText:playcommand("Hide");
			end;
		end;

		local Fade = self:GetChild("Fade");

		if AnySavesFailed then
			SOUND:PlayOnce(THEME:GetPathS("MemoryCardManager", "error"));
			Fade:playcommand("TweenOffPartial");
			Fade:sleep(TweenTime - Fade:GetTweenTimeLeft());
		end
		Fade:playcommand("TweenOff");
	end;

};

t[#t+1] = LoadActor( THEME:GetPathB("","_shared underlay") );


t[#t+1] = Def.Quad {
	Name="Fade";
	InitCommand=cmd(FullScreen;diffuse,color("#000000"));
	OnCommand=cmd(diffusealpha,0;linear,0.15;diffusealpha,1);
	TweenOffCommand=cmd(linear,0.2;diffusealpha,0);
	TweenOffPartialCommand=cmd(linear,0.2;diffusealpha,0.5);
};

local function MakeErrorMessage(pn)
	local text = pn==PLAYER_1 and "player 1" or "player 2"
	return LoadFont("_regra bold 30px") .. {
		OnCommand=cmd(stoptweening;diffusealpha,0);
		ShowCommand=cmd(linear,0.2;diffusealpha,1);
		HideCommand=cmd(linear,0.2;diffusealpha,0);
		SetDefaultErrorCommand=cmd(settext,"Couldn't save\n" .. text .. " (disk full?)");
		SetCardGoneCommand=cmd(settext,"Couldn't save\n" .. text .. " (card removed)");
	};
end
t[#t+1] = MakeErrorMessage(PLAYER_1) .. {
	Name="ErrorTextP1";
	InitCommand=cmd(x,SCREEN_WIDTH*1/4;y,SCREEN_CENTER_Y);
};
t[#t+1] = MakeErrorMessage(PLAYER_2) .. {
	Name="ErrorTextP2";
	InitCommand=cmd(x,SCREEN_WIDTH*3/4;y,SCREEN_CENTER_Y);
};

t[#t+1] = LoadActor( "statusbar" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;addx,-SCREEN_WIDTH*1.5;); 
	OnCommand=cmd(decelerate,0.3;x,SCREEN_CENTER_X);
	OffCommand=cmd(accelerate,0.3;addx,SCREEN_WIDTH*1.5);
};

t[#t+1] = Def.Actor {
	BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToSave() then
			self:sleep(0.3);
		end;
		self:queuecommand("Load");
	end;
	LoadCommand=function()
		SCREENMAN:GetTopScreen():Continue();
	end;
};

return t;
