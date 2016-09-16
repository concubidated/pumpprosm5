function MakeScoreList(StagesAgo)
	local c;
	local Stats;
	local PlayerStats = { }
	local t = Def.ActorFrame {
		LoadActor( "gem color part" ) .. {
			Name="DifficultyP1Color";
			InitCommand = cmd(x,-69;pause;halign,1);
			OnCommand=cmd(zoomx,0;sleep,0.3;bounceend,0.3;zoomx,.5);
			OffCommand=cmd(bouncebegin,0.1;zoomx,0);
		};
		LoadActor( "gem overlay part" ) .. {
			Name="DifficultyP1Overlay";
			InitCommand = cmd(x,-69;pause;halign,1);
			OnCommand=cmd(zoomx,0;sleep,0.3;bounceend,0.3;zoomx,.5);
			OffCommand=cmd(bouncebegin,0.1;zoomx,0);
		};
		LoadActor( "gem color part" ) .. {
			Name="DifficultyP2Color";
			InitCommand = cmd(x,69;pause;halign,1;zoomx,0);
			OnCommand=cmd(zoomx,0;sleep,0.3;bounceend,0.3;zoomx,-.5);
			OffCommand=cmd(bouncebegin,0.1;zoomx,0);
		};
		LoadActor( "gem overlay part" ) .. {
			Name="DifficultyP2Overlay";
			InitCommand = cmd(x,69;pause;halign,1;zoomx,0);
			OnCommand=cmd(zoomx,0;sleep,0.3;bounceend,0.3;zoomx,-.5);
			OffCommand=cmd(bouncebegin,0.1;zoomx,0);
		};
		LoadActor( "banner mask" ) .. {
			Name="BannerMask";
			InitCommand=cmd(clearzbuffer,true;zwrite,true;blend,"BlendMode_NoEffect");
			OnCommand=cmd(zoom,0;bounceend,0.3;zoom,1);
			OffCommand=cmd(bouncebegin,0.3;zoom,0);
		};
		Def.Sprite {
			Name = "Banner";
			InitCommand = cmd(setsize,300,100;zoom,0.5;ztest,true);
			OnCommand=cmd(zoom,0;bounceend,0.3;zoom,0.5);
			OffCommand=cmd(bouncebegin,0.3;zoom,0);
		};
		LoadActor( "banner frame" ) .. {
			Name="BannerFrame";
			OnCommand=cmd(zoom,0;bounceend,0.3;zoom,1);
			OffCommand=cmd(bouncebegin,0.3;zoom,0);
		};

		LoadActor( "side score frame" ) .. {
			Name="ScoreFrameP1";
			InitCommand=cmd();
			OnCommand=cmd(y,3;x,-230;addx,-250;diffusealpha,1;decelerate,0.3;addx,250);
			OffCommand=cmd(linear,0.3;addx,-150;diffusealpha,0);
		};
		LoadActor( "side score frame" ) .. {
			Name="ScoreFrameP2";
			InitCommand=cmd(zoomx,-1);
			OnCommand=cmd(y,3;x,230;addx,250;diffusealpha,1;decelerate,0.3;addx,-250);
			OffCommand=cmd(linear,0.3;addx,150;diffusealpha,0);
		};

		LoadFont( "_venacti 18px shadow" ) .. {
			Name="PlayerScoreP1";
			InitCommand=cmd(x,-110;diffuse,color("#ffffff");shadowlength,0;zoom,1);
			OnCommand=cmd(x,-110;addx,50;zoom,0;diffusealpha,0;sleep,0.1;accelerate,0.3;addx,-50;diffusealpha,1;zoom,0.7;zoomx,.65);
			OffCommand=cmd(linear,0.3;diffusealpha,0);
		};
		LoadFont( "_venacti 18px shadow" ) .. {
			Name="PlayerScoreP2";
			InitCommand=cmd(x,110;diffuse,color("#ffffff");shadowlength,0;zoom,1);
			OnCommand=cmd(x,110;addx,-50;zoom,0;diffusealpha,0;sleep,0.1;accelerate,0.3;addx,50;diffusealpha,1;zoom,0.7;zoomx,.65);
			OffCommand=cmd(linear,0.3;diffusealpha,0);
		};

		LoadFont( "_venacti shadow 22px" ) .. {
			Name="MachineBestP1";
			InitCommand=cmd(diffusetopedge,color("#ff7600");diffusebottomedge,color("#ffc000");shadowlength,0);
			OnCommand=cmd(x,-232;addx,-250;diffusealpha,1;decelerate,0.3;addx,250);
			OffCommand=cmd(linear,0.3;addx,-150;diffusealpha,0);
		};
		LoadFont( "_venacti shadow 22px" ) .. {
			Name="MachineBestP2";
			InitCommand=cmd(diffusetopedge,color("#ff7600");diffusebottomedge,color("#ffc000");shadowlength,0);
			OnCommand=cmd(x,232;addx,250;diffusealpha,1;decelerate,0.3;addx,-250);
			OffCommand=cmd(linear,0.3;addx,150;diffusealpha,0);
		};
		
		InitCommand = function(self)
			c = self:GetChildren();
			c.PlayerScore = {};
			c.PlayerScore[PLAYER_1] = c.PlayerScoreP1;
			c.PlayerScore[PLAYER_2] = c.PlayerScoreP2;
			c.MachineBest = {};
			c.MachineBest[PLAYER_1] = c.MachineBestP1;
			c.MachineBest[PLAYER_2] = c.MachineBestP2;
			c.ScoreFrame = {};
			c.ScoreFrame[PLAYER_1] = c.ScoreFrameP1;
			c.ScoreFrame[PLAYER_2] = c.ScoreFrameP2;
			c.DifficultyColor = {};
			c.DifficultyColor[PLAYER_1] = c.DifficultyP1Color;
			c.DifficultyColor[PLAYER_2] = c.DifficultyP2Color;
			c.DifficultyOverlay = {};
			c.DifficultyOverlay[PLAYER_1] = c.DifficultyP1Overlay;
			c.DifficultyOverlay[PLAYER_2] = c.DifficultyP2Overlay;
		end;
		
		BeginCommand = function(self)
			Stats = STATSMAN:GetPlayedStageStats(StagesAgo);
			if not Stats then
				self:visible(false);
				return;
			end;
			self:visible(true);

			PlayerStats[PLAYER_1] = Stats:GetPlayerStageStats(PLAYER_1);
			PlayerStats[PLAYER_2] = Stats:GetPlayerStageStats(PLAYER_2);

			local Current;
			local CurrentPart = {}
			if GAMESTATE:IsCourseMode() then
				Current = GAMESTATE:GetCurrentCourse();
				CurrentPart[PLAYER_1] = GAMESTATE:GetCurrentTrail( PLAYER_1 );
				CurrentPart[PLAYER_2] = GAMESTATE:GetCurrentTrail( PLAYER_2 );
			else
				Current = Stats:GetPlayedSongs()[1];
				CurrentPart[PLAYER_1] = PlayerStats[PLAYER_1]:GetPlayedSteps()[1];
				CurrentPart[PLAYER_2] = PlayerStats[PLAYER_2]:GetPlayedSteps()[1];
			end
			assert(Current);

			local sBannerPath = Current:GetBannerPath() or THEME:GetPathG("Common","fallback banner");
			c.Banner:LoadBanner( sBannerPath );

			for pn in ivalues(PlayerNumber) do
				local visible = GAMESTATE:IsHumanPlayer(pn) and CurrentPart[pn] ~= nil; -- was present for this song
				c.MachineBest[pn]:visible( visible );
				c.PlayerScore[pn]:visible( visible );
				c.ScoreFrame[pn]:visible( visible );
				c.DifficultyColor[pn]:visible( visible );
				c.DifficultyOverlay[pn]:visible( visible );

				local MachineProfile = PROFILEMAN:GetMachineProfile();
				if visible then
					assert(CurrentPart[pn]);

					c.DifficultyColor[pn]:diffuse( StepsOrTrailToColor(CurrentPart[pn]) );

					local hsl = MachineProfile:GetHighScoreList( Current, CurrentPart[pn] );
					assert( hsl );

					-- Find the first high score that isn't one that we're entering now.
					local HighScores = hsl:GetHighScores();
					local hs;
					for h in ivalues(HighScores) do
						if not hs and not h:IsFillInMarker() then
							hs = h;
						end
					end

					if hs then
						local fMachineScore = hs:GetPercentDP() or 0;
						local sName = hs:GetName() or "";
						local sText = sName .. " " .. FormatPercentScore( fMachineScore );
						c.MachineBest[pn]:settext( sText );
					else
						c.ScoreFrame[pn]:visible( false );
					end

					local fPlayerScore = PlayerStats[pn]:GetPercentDancePoints();
					local sText = FormatPercentScore( fPlayerScore );
					c.PlayerScore[pn]:settext( sText );
					local colors = {
						[PLAYER_1] = color("#fdf991"),
						[PLAYER_2] = color("#abfe8e"),
					};
					if Stats:PlayerHasHighScore(pn) then
						colors = {
							[PLAYER_1] = color("#feef01"),
							[PLAYER_2] = color("#0ffc03"),
						};
					end
					c.PlayerScore[pn]:diffuse(colors[pn]);
				end;
			end;
		end;
	};

	return t;
end

local t = Def.ActorFrame {
	BeginCommand = function(self)
		local StagesPlayed = STATSMAN:GetStagesPlayed();
		local c = self:GetChildren();
		
		local fYCenter = SCREEN_CENTER_Y-60;
		local fYMinSpacing = 44;
		local fYMaxSpacing = 70;
		local fYSpacing = scale(StagesPlayed, 4, 5, fYMaxSpacing, fYMinSpacing);
		fYSpacing = clamp(fYSpacing, fYMinSpacing, fYMaxSpacing);
		fYSpacing = fYSpacing + math.mod(fYSpacing, 2); -- even
		fYSpacing = -fYSpacing;

		local fYStart = fYSpacing*(StagesPlayed-1)/2;
		local fYEnd = -fYSpacing*(StagesPlayed-1)/2;
		for i = 1,StagesPlayed do
			local Name = "Row" .. tostring(i);
			local row = c[Name];
			assert(row);
			local fY = fYCenter + fYEnd + (i-1)*fYSpacing;
			row:y( fY );
		end

		local Timer = SCREENMAN:GetTopScreen():GetChild("Timer");
		if not SCREENMAN:GetTopScreen():GetAnyEntering() then
			Timer:setseconds(5);
			Timer:silent(true);
		else
			Timer:setseconds(25);
			Timer:silent(false);
		end
	end;

	OnCommand = function(self)
		MESSAGEMAN:Broadcast("BackgroundNormal");

		local StagesPlayed = STATSMAN:GetStagesPlayed();
		local c = self:GetChildren();
		for i = 1,StagesPlayed do
			local Name = "Row" .. tostring(i);
			local row = c[Name];
			assert(row);

			row:hibernate(0.3+(i/StagesPlayed)*0.3);
		end
	end;

	LoadActor( "../ScreenEnding1 underlay/frame" ) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
		OnCommand=cmd(croptop,1;fadetop,1;sleep,.2;linear,.8;croptop,-1;fadetop,-1;);
		OffCommand=cmd(stoptweening;linear,0.3;cropbottom,1;addy,-10;fadebottom,1;);
	};
	LoadActor( "line" ) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;SetWidth,290;SetHeight,6;y,SCREEN_CENTER_Y+65;fadeleft,0.3; faderight,0.3);
		OnCommand=cmd(cropleft,.5;cropright,.5;
			sleep,0.2;
			linear,0.3;
			cropleft,-.2;cropright,-.2);
		
		OffCommand=cmd(linear,0.3;cropleft,.5;cropright,.5);
	};

	LoadActor( "frame" );
};

	
for i = 1,5 do
	t[#t+1] =
		MakeScoreList(i) .. {
			Name="Row" .. tostring(i);
			InitCommand=cmd(x,SCREEN_CENTER_X);
		};
end

	
t[#t+1] = LoadActor( "keyboard" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+80);
	BeginCommand = cmd(visible,SCREENMAN:GetTopScreen():GetAnyEntering());
};

for pn in ivalues(PlayerNumber) do
	local FrameX = pn == PLAYER_1 and (SCREEN_CENTER_X-235) or (SCREEN_CENTER_X+235);
	local P1 = pn == PLAYER_1 and 1 or -1;
	t[#t+1] = LoadActor( "name frame" ) .. {
		InitCommand=cmd(y,SCREEN_CENTER_Y+119;
			zoomx,pn == PLAYER_1 and 1.0 or -1.0);
		BeginCommand=cmd(visible,SCREENMAN:GetTopScreen():GetEnteringName(pn));
		OnCommand=cmd(finishtweening;x,FrameX;addx,-200*P1;zoom,0;bounceend,0.3;zoomy,1;zoomx,1*P1;addx,200*P1);
		OffCommand=cmd(stoptweening;bouncebegin,0.3;zoom,0;addx,-200*P1);
	};

	t[#t+1] = LoadFont( "_venacti Bold 30px" ) .. {
		Name="PlayerText";
		InitCommand=cmd(x,pn == PLAYER_1 and (SCREEN_CENTER_X-238) or (SCREEN_CENTER_X+240);
			halign,.5;
			y,SCREEN_CENTER_Y+115;shadowlength,3;maxwidth,130);
		BeginCommand=cmd(visible,SCREENMAN:GetTopScreen():GetEnteringName(pn));
		OnCommand=cmd(finishtweening;diffusealpha,0;sleep,0.1;linear,0.3;diffusealpha,1);
		OffCommand=cmd(stoptweening;bouncebegin,0.3;zoom,0;addx,-200*P1);
		EntryChangedMessageCommand=function(self,params)
			if params.PlayerNumber ~= pn then
				return;
			end;
			self:settext( params.Text );
		end;
	};
end;

return t;
