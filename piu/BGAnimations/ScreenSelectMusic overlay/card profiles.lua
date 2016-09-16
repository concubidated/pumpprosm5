local params = ...;
local pn = params.PlayerNumber

local function MakePanes(pn)
	local flip = (pn == PLAYER_1 and 1 or -1 );
	-- Player Panes

	local f = Def.ActorFrame {
	};
	f[#f+1] = LoadActor("card box") .. {
		InitCommand=cmd(zoomx,flip);
		OnCommand=cmd(finishtweening;cropbottom,1.3;linear,.65;cropbottom,0);
	};
	f[#f+1] = LoadFont("_venacti Bold Glow 30px") .. {
		InitCommand=cmd(maxwidth,160;y,-66;rotationz,5*flip;skewx,0.1*flip;shadowlength,0);
		UpdateCommand=cmd(settext,GAMESTATE:GetPlayerDisplayName(pn));
		OnCommand=cmd(finishtweening;diffusealpha,0;sleep,.2;linear,.08;diffusealpha,1);
	};
	f[#f+1] = LoadFont("_venacti Bold Glow 30px") .. {
		InitCommand=cmd(y,-14;zoom,0.5;shadowlength,0);
		UpdateCommand=cmd(settext,"Songs Played:\n" .. comma_value(PROFILEMAN:GetProfile(pn):GetTotalNumSongsPlayed()));
		OnCommand=cmd(finishtweening;diffusealpha,0;sleep,.32;linear,.1;diffusealpha,1);
	};
	f[#f+1] = Def.Quad {
		InitCommand=cmd(y,-34+42*1;diffuse,color("#FFFFFF");zoomtowidth,105;zoomtoheight,1;fadeleft,.5;faderight,.5);
		OnCommand=cmd(finishtweening;diffusealpha,0;sleep,.35;linear,.1;diffusealpha,1);
	};
	f[#f+1] = LoadFont("_venacti Bold Glow 30px") .. {
		Text="";
		InitCommand=cmd(maxwidth,320;y,-14+42*1;zoom,0.5;shadowlength,0);
		UpdateCommand=cmd(settext,"Total Notes Hit:\n" .. comma_value(PROFILEMAN:GetProfile(pn):GetTotalTapsAndHolds()));
		OnCommand=cmd(finishtweening;diffusealpha,0;sleep,.42;linear,.1;diffusealpha,1);
	};
	f[#f+1] = Def.Quad {
		InitCommand=cmd(y,-33+42*2;diffuse,color("#FFFFFF");zoomtowidth,105;zoomtoheight,1;fadeleft,.5;faderight,.5);
		OnCommand=cmd(finishtweening;diffusealpha,0;sleep,.44;linear,.1;diffusealpha,1);
	}
	f[#f+1] = LoadFont("_venacti Bold Glow 30px") .. {
		InitCommand=cmd(maxwidth,300;y,-14+42*2;zoom,0.5;shadowlength,0);
		UpdateCommand=function(self)
			local SinglesPercent = PROFILEMAN:GetProfile(pn):GetSongsAndCoursesPercentCompleteAllDifficulties("StepsType_Pump_Single");
			local DoublesPercent = PROFILEMAN:GetProfile(pn):GetSongsAndCoursesPercentCompleteAllDifficulties("StepsType_Pump_Double");
			local Percent = (SinglesPercent + DoublesPercent) / 2;
			self:settext(string.format("Percent Complete:\n%02.2f%%", Percent*100));
		end;
		OnCommand=cmd(finishtweening;diffusealpha,0;sleep,.52;linear,.1;diffusealpha,1);
	};
	f[#f+1] = LoadActor("box outline") .. {
		InitCommand=cmd(zoomx,flip);
		OnCommand=cmd(diffusealpha,.75;finishtweening;cropbottom,1.3;linear,.65;cropbottom,0;linear,.8;diffusealpha,0);
		};
	f[#f+1] = LoadActor("box glow") .. {
		InitCommand=cmd(zoomx,flip);
		OnCommand=cmd(finishtweening;zoom,1.05;croptop,-0.3;cropbottom,1;fadebottom,.1;fadetop,.1;linear,.75;croptop,1;cropbottom,-0.3);
		};
	return f;
end

	
local t = Def.ActorFrame {
};

	local flip = (pn == PLAYER_1 and 1 or -1 );
	local tweening_out = false;
	local WasVisible;
	t[#t+1] = MakePanes(pn) .. {
		BeginCommand=function(self)
			local visible = GAMESTATE:IsPlayerEnabled(pn) and IsNewPlayerProfileLoaded(pn);

			WasVisible = visible;
			self:visible(visible);
			if not visible then return end;

			self:playcommand("Update");
		end;

		OnCommand=cmd(playcommand,"TweenOn";sleep,3;queuecommand,"TweenOff");
		OffCommand=cmd(visible,false);
		TweenOnCommand=function(self)
			tweening_out = false;
			self:playcommand("DoTweenOn");
		end;
		TweenOffCommand=function(self)
			if tweening_out then return end;
			tweening_out = true;
			self:playcommand("DoTweenOff");
		end;
		DoTweenOnCommand=cmd(finishtweening;visible,WasVisible;x,-230 * flip);
		DoTweenOffCommand=cmd(stoptweening;accelerate,.5;addx,-SCREEN_WIDTH/2 * flip;queuecommand,"Hide");
		
		HideCommand=cmd(visible,false);
		PlayerMenuKeyPressedMessageCommand=function(self, params)
			if params.PlayerNumber ~= pn then return end
			self:playcommand("TweenOff");
		end;
	};

return t;
