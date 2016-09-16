local function MakeDiskErrorMonitor()
	local function GetErrorCount()
		local Count = tonumber(Helpers.ReadStateFile("ata-eh-count"));
		if Count == nil then return 0 end
		return Count
	end

	local LastSeenErrorCount = GetErrorCount();
	return Def.Actor {
		DiskErrorMessageCommand=function(self, params)
			local ErrorCount = GetErrorCount();
			if ErrorCount == LastSeenErrorCount then return end
			LastSeenErrorCount = ErrorCount;

			-- We've had a disk error.  A dying HDD or bad SATA cable can cause
			-- major intermittent skips; show a system message to explain what
			-- happened to increase the likelihood of the operator finding out.
			MESSAGEMAN:Broadcast("SystemMessage", { Message="Hard drive read error, system may require service" });
		end;
	};
end


local t = Def.ActorFrame {
--	Def.TimingGraph {
--		InitCommand=cmd(halign,1;x,SCREEN_WIDTH;y,SCREEN_HEIGHT*2/4);
--	};

	MakeDiskErrorMonitor();

	LoadActor( THEME:GetPathG(Var "LoadingScreen","MessageFrame") ) .. {
		InitCommand=cmd(
			halign,0;
			y,SCREEN_TOP+40;
			diffusealpha,0
		);
		SystemMessageMessageCommand = function(self, params)
			local f = cmd(finishtweening;x,SCREEN_LEFT;diffusealpha,0.5;addx,-SCREEN_WIDTH;linear,0.5;addx,SCREEN_WIDTH); f(self);
			self:playcommand( "On" );
			if params.NoAnimate then
				self:finishtweening();
			end
			f = cmd(sleep,5;linear,0.5;diffusealpha,0); f(self);
			self:playcommand( "Off" );
		end;
		HideSystemMessageMessageCommand = cmd(finishtweening);
	};
	LoadFont(Var "LoadingScreen","message") .. {
		InitCommand=cmd(maxwidth,750;
		halign,0;
		zoom,0.8;shadowlength,2;
		y,SCREEN_TOP+40;
		diffusealpha,0
		);
		SystemMessageMessageCommand = function(self, params)
			self:settext( params.Message );
			local f = cmd(finishtweening;x,SCREEN_LEFT+20;diffusealpha,1;addx,-SCREEN_WIDTH;linear,0.5;addx,SCREEN_WIDTH); f(self);
			self:playcommand( "On" );
			if params.NoAnimate then
				self:finishtweening();
			end
			f = cmd(sleep,5;linear,0.5;diffusealpha,0); f(self);
			self:playcommand( "Off" );
		end;
		HideSystemMessageMessageCommand = cmd(finishtweening);
	};
};

local CreditsArea = Def.ActorFrame {
	ScreenChangedMessageCommand=function(self)
		local screen = SCREENMAN:GetTopScreen();
		local bShow = true;
		if screen then
			local sClass = screen:GetName();
			bShow = THEME:GetMetric( sClass, "ShowOverlayCoinsAndCredits" );
		end

		self:visible( bShow );
	end;
};
t[#t+1] = CreditsArea;
CreditsArea[#CreditsArea+1] = LoadActor(THEME:GetPathG("", "_credits text"));

CreditsArea[#CreditsArea+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_1;
	InitCommand=cmd(x,SCREEN_CENTER_X-195;y,SCREEN_BOTTOM-12);
};

CreditsArea[#CreditsArea+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_2;
	InitCommand=cmd(x,SCREEN_CENTER_X+195;y,SCREEN_BOTTOM-12);
};

--[[
-- "Shared credits", to show a single credits text.  This isn't used right now.
t[#t+1] = LoadFont("_venacti 22px bold") .. {
	InitCommand=cmd(
		shadowlength,1;
		diffuse,color("#fcff00");
		strokecolor,color("#000000AA");
		shadowlength,0;
		playcommand,"Update";
	);

	CoinInsertedMessageCommand=cmd(playcommand,"Update");
	RefreshCreditTextMessageCommand=cmd(playcommand,"Update");
	PlayerJoinedMessageCommand=cmd(playcommand,"Update");
	UpdateCommand=function(self)
		local Coins = GAMESTATE:GetCoins();
		--if Coins == 0 then
		--	self:settext( "" );
		--	return;
		--end

		local CoinsPerCredit = PREFSMAN:GetPreference("CoinsPerCredit");
		local Credits = math.floor(Coins / CoinsPerCredit);
		local RemainingCoins = Coins % CoinsPerCredit;
		local CreditsString = THEME:GetString("ScreenSystemLayer", "CreditsCredits");
		local s = CreditsString .. ": ";
		if Credits > 0 or CoinsPerCredit == 1 then
			s = s .. tostring(Credits);
		end
		
		if CoinsPerCredit > 1 then
			s = s .. "  " .. tostring(RemainingCoins) .. "/" .. tostring(CoinsPerCredit);
		end
		Trace("xxx: " .. s);
		self:settext( s );
	end;
	
	ScreenChangedMessageCommand=function(self)
		local screen = SCREENMAN:GetTopScreen();
		local bShow = true;
		local bLarge = false;
		if screen then
			local sClass = screen:GetName();
			bShow = THEME:GetMetric( sClass, "ShowSharedCredits" );
			bLarge = THEME:GetMetric( sClass, "LargeSharedCredits" );
		end
		if bLarge then
			(cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-13;zoom,.8;))(self);
		else
			(cmd(x,SCREEN_CENTER_X+250;y,SCREEN_BOTTOM-8;zoom,0.6;))(self);
		end
		self:visible( bShow  and  GAMESTATE:GetCoinMode() == "CoinMode_Pay");
	end
};
]]

local function MakeTicketsText()
	return LoadFont("_venacti 22px bold") .. {
		Name="TicketsText";
		InitCommand=cmd(
			shadowlength,1;
			diffuse,color("#fcff00");
			strokecolor,color("#000000AA");
			shadowlength,0;
			x,SCREEN_CENTER_X-230;
			y,SCREEN_BOTTOM-8;
			zoom,0.6;
			playcommand,"Refresh";
		);
		RefreshCommand=function(self)
			local bShow = true;
			local enableTicketDispenser = PREFSMAN:GetPreference("EnableTicketDispenser");
			if enableTicketDispenser == nil  or  enableTicketDispenser == false then
				bShow = false;
			end 
			--bShow = true;  --uncomment for debug
			
			local bEmpty = true;
			local iUndispensed = 0;
			if MK6 then
				bEmpty = MK6.GetTicketsEmpty();
				iUndispensed = MK6.GetNumUndispensedTickets();
			end
			self:visible(bShow and bEmpty);
			self:settext( "TICKETS EMPTY (" .. iUndispensed .. ") - CALL ATTENDANT" );

		end;
		TicketsEmptyMessageCommand=cmd(playcommand,"Refresh";);
		TicketsNotEmptyMessageCommand=cmd(playcommand,"Refresh";);
		TicketDispensedMessageCommand=cmd(playcommand,"Refresh";);
		ScreenChangedMessageCommand=function(self)
			if SaveUndispensedTicketsToDisk then
				SaveUndispensedTicketsToDisk();
			end
		end
	};
end

if PREFSMAN:PreferenceExists("EnableTicketDispenser") then
	t[#t+1] = MakeTicketsText();
end

return t;
