
local function MakeBothPlayersNotice(pn)
	local text = LoadFont("_venacti 26px bold diffuse") .. {
		Text=THEME:GetString(Var "LoadingScreen", "BothPlayers");
		InitCommand=cmd(wrapwidthpixels,350);
		BeginCommand=function( self, param ) self.was_shown = true; self.on = false; self.opened = false; self:playcommand("Set"); self:finishtweening(); end;
		FadeOnCommand=cmd(diffuseblink;effectperiod,2;effectclock,"bgm";
			finishtweening;zoomx,0.5*1.35;zoomy,0;diffusealpha,0;linear,0.2;zoom,0.5;diffusealpha,1);
		FadeOffCommand=cmd(stoptweening;linear,0.2;zoomx,0.5*1.35;zoomy,0;diffusealpha,0);
		SetCommand=function( self, param )
			local two = GAMESTATE:GetNumPlayersEnabled() > 1;
			local on = self.opened and self.on and two;
			if self.was_on == on then return end
			self.was_on = on;
			if on then
				self:playcommand("FadeOn");
			else
				self:playcommand("FadeOff");
			end
		end;
		PlayerJoinedMessageCommand=function( self, param )
			self:playcommand("Set");
		end;
		OptionsMenuChangedMessageCommand=function( self, param )
			if param.Player ~= pn then return end;
			self.on = param.Menu == "SongRate";
			self:playcommand("Set");
		end;
		OptionsListOpenedMessageCommand=function( self, param )
			if param.Player ~= pn then return end;
			self.opened = true;
			self:playcommand("Set");
		end;
		OptionsListClosedMessageCommand=function( self, param )
			if param.Player ~= pn then return end;
			self.opened = false;
			self:playcommand("Set");
		end;
	};
	return text
end

local function PlayerArea( pn )
	assert(pn == PLAYER_1 or pn == PLAYER_2, pn);
	local flip = (pn == PLAYER_1 and 1 or -1 );

	local function StepsPaneScale(side_of_panes_cut_off, sides_of_panes_not_cut_off)
		return scale_clamp( SCREEN_WIDTH, 640, 700, side_of_panes_cut_off, sides_of_panes_not_cut_off );
	end

	local function right_flip(y, pn)
		if pn == PLAYER_2 then
			return SCREEN_WIDTH - y
		else
			return y
		end
	end

	local pane_area_width = StepsPaneScale( 134, 164 );
	local pane_area_offset_x = StepsPaneScale( flip*20, 0 );

	local t = Def.ActorFrame { }

	local function MakePlayerFrame()
		local c;
		local function set(self, player)
			assert( player )
			if player ~= pn then return end
			local Selection = GAMESTATE:GetCurrentSteps(pn) or GAMESTATE:GetCurrentTrail(pn)

			local difficulty_color = CustomDifficultyToColor( StepsOrTrailToCustomDifficulty(Selection) );
			local Bar = self:GetChild("HeaderBar");
			local difficulty_color_and_alpha = { difficulty_color[1], difficulty_color[2], difficulty_color[3], Bar:GetDiffuseAlpha() };
			Bar:diffuse( difficulty_color_and_alpha );
		end;

		local frame = Def.ActorFrame { 
			OnCommand=cmd(player,pn;x,SCREEN_CENTER_X+flip*-268;y,GAMESTATE:GetMultiplayer() and (SCREEN_CENTER_Y+48) or (SCREEN_CENTER_Y-2););
			PlayerJoinedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;

				self:player(pn);
				set(self, pn);
			end;
			OptionsListOpenedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				self:playcommand("FadeOff");
			end;
			OptionsListClosedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				self:playcommand("FadeOn");
			end;
			InitCommand=function(self)
			end;

			CurrentStepsP1ChangedMessageCommand=function(self) set(self, PLAYER_1); end;
			CurrentStepsP2ChangedMessageCommand=function(self) set(self, PLAYER_2); end;
			CurrentTrailP1ChangedMessageCommand=function(self) set(self, PLAYER_1); end;
			CurrentTrailP2ChangedMessageCommand=function(self) set(self, PLAYER_2); end;
		};

		frame[#frame+1] = LoadActor( GAMESTATE:GetMultiplayer() and "steps pane multiplayer" or "steps pane normal" ) .. { 
			InitCommand=cmd(zoomx,flip;faderight,.1);
			OnCommand=cmd(cropright,1;sleep,0;linear,0.3;cropright,-0.1);
			FadeOffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
			FadeOnCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;);
		};

		frame[#frame+1] = LoadActor("steps header color") .. { 
			Name="HeaderBar";
			InitCommand=cmd(blend,"BlendMode_Add";zoomx,flip);
			FadeOffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
			FadeOnCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;);

			OnCommand=function(self)
				if GAMESTATE:GetMultiplayer() then
					self:visible(false);
				else
					(cmd(cropright,1;sleep,0;linear,0.3;cropright,-0.1))(self);
				end;
			end;
		};

		return frame;
	end
	t[#t+1] = MakePlayerFrame();
	
	local function MakeSortMenu()
		local frame = Def.ActorFrame { 
			Name="SelectMenu";
			SelectMenuOpenedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playcommand("Opened"); end;
			SelectMenuClosedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playcommand("Closed"); end;

			LoadFont("_venacti 15px bold") .. {
				InitCommand=cmd(settext,"&START; Change Sort";diffuseblink;effectperiod,0.5;shadowlength,2;);
				OnCommand=cmd(y,-30;zoom,0.9;diffusealpha,0);
				OpenedCommand=cmd(stoptweening;bounceend,0.2;diffusealpha,1;zoom,1;);
				ClosedCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;zoom,0.9;);
			};
			LoadFont("_venacti 15px bold") .. {
				InitCommand=cmd(settext,"&MENULEFT; Easier";shadowlength,2;);
				OnCommand=cmd(halign,1;x,-5;y,-50;zoom,1;diffusealpha,0;);
				OpenedCommand=cmd(stoptweening;bounceend,0.2;diffusealpha,1;);
				ClosedCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			};
			LoadFont("_venacti 15px bold") .. {
				InitCommand=cmd(settext,"Harder &MENURIGHT;";shadowlength,2);
				OnCommand=cmd(halign,0;x,5;y,-50;zoom,1;diffusealpha,0;);
				OpenedCommand=cmd(stoptweening;bounceend,0.2;diffusealpha,1;);
				ClosedCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;);
			};			
		};

		local c;
		frame.InitCommand=function(self)
			c = self:GetChildren();
		end

		local sorts = THEME:GetMetric("MusicWheel", "SortOrders");
		for idx, sort in ipairs(sorts) do
			local text = THEME:GetString("SortOrder", sort:sub(11));
			frame[#frame+1] = LoadFont("_venacti 22px bold") .. {
				Name = sort;
				InitCommand=cmd(settext,text;y,idx*17-26;zoom,0.5;shadowlength,1.5;);
				OnCommand=cmd(diffusealpha,0;);
				OpenedCommand=cmd(stoptweening;linear,0.2;diffusealpha,1);
				ClosedCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			};
		end

		for side in ivalues({-1,1}) do
			frame[#frame+1] = LoadActor("sort cursor") .. {
				InitCommand=cmd(rotationy,side == -1 and 180 or 0);
				OnCommand=cmd(diffusealpha,0);
				SortOrderChangedMessageCommand=cmd(playcommand,"Set");
				OpenedCommand=cmd(stoptweening;linear,0.2;diffusealpha,1);
				ClosedCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);

				SetCommand=function(self)
					local CurrentSort = GAMESTATE:GetSortOrder();
					if not c[CurrentSort] then return end -- course modes aren't listed in sorts
					local x = c[CurrentSort]:GetX();
					local y = c[CurrentSort]:GetY();
					local width = c[CurrentSort]:GetZoomedWidth();
					self:x(side * (width/2 + 8));
					self:y(y);
				end;
			};
		end

		return frame;
	end

	local function MakePlayerData()
		local c;

		local function set(self, player)
			assert( player )
			if player ~= pn then return end
			local Selection = GAMESTATE:GetCurrentSteps(pn) or GAMESTATE:GetCurrentTrail(pn)
			if not Selection then return end

			local s = Selection:GetDescription();
			s = string.upper( s );	-- TODO: upper doesn't work for French where accents change

			if Selection and not GAMESTATE:GetCurrentCourse() then
				local meter = Selection:GetMeter();
				s = string.format("%02d %s", meter, s);
			end

			c.HeaderDifficultyText:settext( s );

			local difficulty_color = CustomDifficultyToColor( StepsOrTrailToCustomDifficulty(Selection) );
			c.HeaderDifficultyText:diffuse( difficulty_color );
			for name, icon in pairs(c.StepsInfoIcon) do
				icon:diffusecolor( difficulty_color );
			end;
		end
	
		local frame = Def.ActorFrame { 
			InitCommand=cmd(SetWidth,180);
			OnCommand=cmd(player,pn;x,round(right_flip(SCREEN_LEFT+round(WideScale(70, 156),0), pn),0); y,GAMESTATE:GetMultiplayer() and (SCREEN_CENTER_Y+80) or (SCREEN_CENTER_Y-40););

			CurrentStepsP1ChangedMessageCommand=function(self) set(self, PLAYER_1); end;
			CurrentStepsP2ChangedMessageCommand=function(self) set(self, PLAYER_2); end;
			CurrentTrailP1ChangedMessageCommand=function(self) set(self, PLAYER_1); end;
			CurrentTrailP2ChangedMessageCommand=function(self) set(self, PLAYER_2); end;
			PlayerJoinedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				self:visible( true );
				set(self, pn);
			end;
			OptionsListOpenedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				-- Don't fade stats when we go to the options menu, so we don't
				-- flicker it as the select menu turns off.
				local FadeOff = cmd(finishtweening;diffusealpha,0;)
				self:GetChild("Contents"):runcommandsonleaves( FadeOff );
			end;
			OptionsListClosedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				local FadeOn = cmd(stoptweening;linear,0.2;diffusealpha,1);
				self:GetChild("Contents"):runcommandsonleaves( FadeOn );
			end;

			InitCommand=function(self)
				c = self:GetChildren();

				c.HeaderDifficultyText = self:GetChild("DifficultyText");
				local Stats = self:GetChild("Contents"):GetChild("Stats");
				local SongStatsIcons = Stats:GetChild("SongStatsIcons");
				c.StepsInfoIcon = SongStatsIcons:GetChildren();
			end;
		};
		local function MakeSongStats(pn)
			local f = Def.ActorFrame { };

			local Fields = {
				TapsAndHolds = {
					BeginCommand = cmd(x,66*0;y,36*0);
					RadarField = "RadarCategory_TapsAndHolds";
				};
				Jumps = {
					BeginCommand = cmd(x,66*1;y,36*0);
					RadarField = "RadarCategory_Jumps";
				};
				Holds = {
					BeginCommand = cmd(x,66*0;y,36*1);
					RadarField = "RadarCategory_Holds";
				};
				Mines = {
					BeginCommand = cmd(x,66*1;y,36*1);
					RadarField = "RadarCategory_Mines";
				};
				Hands = {
					BeginCommand = cmd(x,66*0;y,36*2);
					RadarField = "RadarCategory_Hands";
				};
				Rolls = {
					BeginCommand = cmd(x,66*1;y,36*2);
					RadarField = "RadarCategory_Rolls";
				};
			};

			local font = LoadFont("_venacti 26px bold diffuse") .. {
				InitCommand=cmd(ztest,true;ztestmode,"ZTestMode_WriteOnFail";shadowlength,0;halign,1;zoom,0.6);
			};
			for name, field in pairs(Fields) do
				f[#f+1] = font .. {
					Name = name;
					BeginCommand = field.BeginCommand;
				};
			end;

			local c;
			f.InitCommand = function(self)
				c = self:GetChildren();
			end;

			f.SetCommand = function(self)
				local Selection = GAMESTATE:GetCurrentTrail(pn) or GAMESTATE:GetCurrentSteps(pn);
				local rv = Selection and Selection:GetRadarValues(pn);
				for name, field in pairs(Fields) do
					local child = c[name];
					if rv then
						local value = rv:GetValue(field.RadarField);
						child:settext(string.format("%3.0f", value));
					else
						child:settext("");
					end;
				end;
			end;

			return f;
		end

		frame[#frame+1] = Def.ActorFrame {
			Name="Contents";
			InitCommand=cmd();

			-- These don't tween when changing to the sort menu, because the
			-- interactions with opening the options menu become a mess.  It's
			-- not really needed anyway; it could make showing the options menu
			-- too busy.
			ShowCommand=function(self) self:runcommandsonleaves(cmd(visible,true)) end;
			HideCommand=function(self) self:runcommandsonleaves(cmd(visible,false)) end;

			SelectMenuOpenedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playcommand("Hide") end;
			SelectMenuClosedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playcommand("Show") end;

			StepsChosenMessageCommand=function( self, param ) if param.Player ~= pn then return end; self:playcommand("Hide") end;
			StepsUnchosenMessageCommand=function( self, param ) if param.Player ~= pn then return end; self:playcommand("Show") end;

			PlayerJoinedMessageCommand=function( self, param ) if param.Player ~= pn then return end; self:visible( true ); end;


			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_1});
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_1});
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_2});
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_2});
			SortOrderChangedMessageCommand=cmd(playcommand,"Set");
			BeginCommand=cmd(playcommand,"Set");
			OnCommand=function(self)
				local StatChildren = { "TapsAndHolds", "Holds", "Hands", "Rolls", "Mines", "Jumps", };

				local Stats = self:GetChild("Stats");
				local SongStats = Stats:GetChild("SongStats"):GetChildren();
				local SongStatsIcons = Stats:GetChild("SongStatsIcons"):GetChildren();

				for idx, name in ipairs({ "TapsAndHolds", "Holds", "Hands", "Jumps", "Mines", "Rolls", }) do
					local a = SongStats[name];
					a:finishtweening();
					local x, y = a:GetX(), a:GetY();
					(cmd(x,8;y,36;diffusealpha,0;sleep,0.8;decelerate,0.2;diffusealpha,1;x,x;y,y))(a);

					local a = SongStatsIcons[name];
					a:finishtweening();
					local x, y = a:GetX(), a:GetY();
					(cmd(x,8;y,36;diffusealpha,0;sleep,0.8;decelerate,0.2;diffusealpha,1;x,x;y,y))(a);
				end
			end;

			SetCommand=function(self, params)
				if params.PlayerNumber and params.PlayerNumber ~= pn then return end

				local TextMachineHighScore = self:GetChild("MachineHighScore");
				local TextMachineHighScoreName = self:GetChild("MachineHighScoreName");
				local TextPersonalHighScore = self:GetChild("PersonalHighScore");

				-- jeez:
				local Selection = GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentCourse();
				local SelectionItem = GAMESTATE:GetCurrentSteps(pn) or GAMESTATE:GetCurrentTrail(pn);
				TextMachineHighScore:settext("");
				TextMachineHighScoreName:settext("");
				TextPersonalHighScore:settext("");
				if not (Selection and SelectionItem) then return; end

				local MachineProfile = PROFILEMAN:GetMachineProfile();
				local MachineHighScorePercent, MachineHighScoreName = GetHighScoreAndName(MachineProfile, Selection, SelectionItem);

				if MachineHighScoreName == RankingToFillInMarker[pn] then
					MachineHighScoreName = "New Arcade Best!"
				elseif MachineHighScoreName == RankingToFillInMarker[OtherPlayer[pn]] then
					local OtherPlayerNumber = PlayerNumber:Reverse()[OtherPlayer[pn]]+1;
					MachineHighScoreName = string.format("P%i's New Best!", OtherPlayerNumber);
				else
					MachineHighScoreName = string.format("%s's Best", MachineHighScoreName);
				end

				local PlayerProfile = PROFILEMAN:IsPersistentProfile(pn) and PROFILEMAN:GetProfile(pn);
				local PlayerHighScorePercent, PlayerHighScoreName;
				if PlayerProfile then
					PlayerHighScorePercent, PlayerHighScoreName = GetHighScoreAndName(PlayerProfile, Selection, SelectionItem);
				end

				if SelectionItem:IsAPlayerEdit() then
					TextMachineHighScore:settext("");
					TextMachineHighScoreName:settext("");
					TextPersonalHighScore:settext("");
				else
					TextMachineHighScore:settext( FormatPercentScore2(MachineHighScorePercent) .. "%" );
					TextMachineHighScoreName:settext(MachineHighScoreName);
					if PlayerHighScorePercent then
						TextPersonalHighScore:settext( FormatPercentScore2(PlayerHighScorePercent) .. "%" );
					else
						TextPersonalHighScore:settext( "N/A" );
					end
				end

			end;

			Def.Quad {
				Name="SongStatsMask";
				InitCommand=cmd(zoomtowidth,pane_area_width;
					SetHeight,109;
					diffuse,color("#FFFF00");
					blend,"BlendMode_NoEffect";zwrite,true;
					valign,1;y,104);

				OnCommand=cmd(croptop,0.5;cropbottom,0.5;sleep,0.35+0.2;accelerate,0.3;croptop,0;cropbottom,0);
			};

			LoadFont("_zosma bold silver 25px") .. {
				Name="MachineHighScore";
				InitCommand=cmd(shadowlength,0;y,-22;ztest,true);
				OnCommand=cmd(addy,50;diffusealpha,0;sleep,0.35+0.2+0.3+0.25-0.1;diffusealpha,1;decelerate,0.5;addy,-50);
			};

			LoadFont("_venacti 26px bold diffuse") .. {
				Name="MachineHighScoreName";
				InitCommand=cmd(shadowlength,0;zoom,0.615;y,-45;ztest,true);
				OnCommand=cmd(addy,50;diffusealpha,0;sleep,0.35+0.2+0.3+0.15-0.1;diffusealpha,1;decelerate,0.5;addy,-50);
			};

			LoadFont("_zosma bold orange 25px") .. {
				Name="PersonalHighScore";
				InitCommand=cmd(shadowlength,0;y,143;ztest,true);
				OnCommand=cmd(addy,-84;diffusealpha,0;sleep,0.35+0.2+0.3-0.1;diffusealpha,1;decelerate,0.5;addy,84);
			};

			Def.ActorFrame {
				Name="Stats";

				InitCommand=cmd();
				Def.ActorFrame {
					Name="SongStatsIcons";
					LoadActor( "_steps info labels" ) .. { Name="TapsAndHolds"; InitCommand=cmd(pause;setstate,0;ztest,true;ztestmode,"ZTestMode_WriteOnFail";x,-54+72*0;y,13+36*0); };
					LoadActor( "_steps info labels" ) .. { Name="Jumps"; InitCommand=cmd(pause;setstate,1;ztest,true;ztestmode,"ZTestMode_WriteOnFail";x,-54+72*1;y,13+36*0); };
					LoadActor( "_steps info labels" ) .. { Name="Holds"; InitCommand=cmd(pause;setstate,2;ztest,true;ztestmode,"ZTestMode_WriteOnFail";x,-54+72*0;y,13+36*1); };
					LoadActor( "_steps info labels" ) .. { Name="Mines"; InitCommand=cmd(pause;setstate,3;ztest,true;ztestmode,"ZTestMode_WriteOnFail";x,-54+72*1;y,13+36*1); };
					LoadActor( "_steps info labels" ) .. { Name="Hands"; InitCommand=cmd(pause;setstate,4;ztest,true;ztestmode,"ZTestMode_WriteOnFail";x,-54+72*0;y,13+36*2); };
					LoadActor( "_steps info labels" ) .. { Name="Rolls"; InitCommand=cmd(pause;setstate,5;ztest,true;ztestmode,"ZTestMode_WriteOnFail";x,-54+72*1;y,13+36*2); };
				};
				
				MakeSongStats(pn) .. {
					Name="SongStats";
					InitCommand=cmd(x,-3;y,12);
				};
				LoadFont("_venacti 26px bold diffuse") .. {
					InitCommand=cmd(shadowlength,0;zoom,0.615;
						ztest,true;ztestmode,"ZTestMode_WriteOnPass";
						settext,"My Best";
					);
					OnCommand=function(self)
						if GAMESTATE:GetMultiplayer() then
							self:visible(false);
						else
							(cmd(y,118;addy,-24;diffusealpha,0;sleep,0.35+0.2+0.3+0.15;diffusealpha,1;decelerate,0.5;addy,24))(self);
						end
					end;
				};

				Def.ActorFrame {
					Def.Quad {
						InitCommand=cmd(setsize,pane_area_width,1);
						--InitCommand=cmd(setsize,WideScale(134, 179,1);
						OnCommand=cmd(y,109/2;zoomx,0;sleep,0.35;accelerate,0.2;zoomx,1;accelerate,0.15;y,109/4;decelerate,0.15;y,0);
					};
					Def.Quad {
						InitCommand=cmd(setsize,pane_area_width,1;y,109);
						OnCommand=cmd(y,109/2;zoomx,0;sleep,0.35;accelerate,0.2;zoomx,1;accelerate,0.15;y,109/4*3;decelerate,0.15;y,109;);
					};

					InitCommand=cmd(y,-5);
				};
			};
		};

		-- This is outside of Contents, so it doesn't disappear when the
		-- sort menu is displayed.  It's affected by SongStatsMask, so draw
		-- it after.
		frame[#frame+1] = LoadFont("_venacti shadow 22px") .. {
			Name="DifficultyText";
			InitCommand=cmd(y,-71;maxwidth,128;shadowlength,0;ztest,true);
			--OnCommand=cmd(addy,75;diffusealpha,0;sleep,0.35+0.2+0.3;diffusealpha,1;sleep,0.05;linear,0.3;addy,-75);
			OnCommand=cmd(diffusealpha,0;zoomy,0;zoomx,1;sleep,0.35+0.2+0.3;linear,0.25;diffusealpha,1;zoom,1);
			OptionsListOpenedMessageCommand=function(self,param) 
				if param.Player ~= pn then return end; 
				self:finishtweening(); 
				self:linear(0.15); 
				self:diffusealpha(0); 
			end;
			OptionsListClosedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;);
		--	BeginCommand=cmd(
		--		x, GAMESTATE:IsCourseMode() and
		--			pane_area_offset_x+(8*flip) or
		--			pane_area_offset_x
		--	);
		};

		frame[#frame+1] = MakeSortMenu();

		return frame;
	end
	t[#t+1] = MakePlayerData();

	local function MakeOptionsMenu()
		local frame = Def.ActorFrame { 
			LoadActor( THEME:GetPathS('', '_select menu') ) .. { 
				OpenedCommand=cmd(playforplayer,pn); 
				SupportPan = true;
				SelectMenuOpenedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playcommand("Opened"); end;
			};
			LoadActor( THEME:GetPathS("OptionsList", "opened") ) .. { 
				SupportPan = true;
				OptionsListOpenedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playforplayer(pn); end;
			};
			LoadActor( THEME:GetPathS('', '_player joined') ) .. { 
				-- SupportPan = true;
				PlayerJoinedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:play(); end;
			};
			LoadActor( THEME:GetPathS("OptionsList", "left") ) .. { 
				SupportPan = true;
				OptionsListMoveMessageCommand=function(self,param) if param.Player ~= pn or param.Direction ~= 1 then return end; self:playforplayer(pn); end;
			};
			LoadActor( THEME:GetPathS("OptionsList", "right") ) .. { 
				SupportPan = true;
				OptionsListMoveMessageCommand=function(self,param) if param.Player ~= pn or param.Direction ~= -1 then return end; self:playforplayer(pn); end;
			};
			LoadActor( THEME:GetPathS("OptionsList", "enter submenu") ) .. { 
				SupportPan = true;
				OptionsMenuChangedMessageCommand=function(self,param)
					if param.Player ~= pn then return end;
					if param.Menu == "MainMenu" then return end;
					self:playforplayer(pn);
				end;
			};
			LoadActor( THEME:GetPathS("OptionsList", "exit submenu") ) .. { 
				SupportPan = true;
				OptionsMenuChangedMessageCommand=function(self,param)
					if param.Player ~= pn then return end;
					if param.Menu == "MainMenu" then return end;
					self:playforplayer(pn);
				end;
			};
			LoadActor( THEME:GetPathS("OptionsList", "start") ) .. { 
				SupportPan = true;
				OptionsListQuickChangeMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playforplayer(pn); end;
			};
			LoadActor( THEME:GetPathS("OptionsList", "start") ) .. { 
				SupportPan = true;
				OptionsListStartMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playforplayer(pn); end;
--				OptionsListResetMessageCommand=function(self,param) if param.Player ~= pn then return end; self:play(); end;
			};
		
			LoadActor( THEME:GetPathS("OptionsList", "closed") ) .. { 
				SupportPan = true;
				OptionsListClosedMessageCommand=function(self,param) if param.Player ~= pn then return end; self:playforplayer(pn); end;
			};
		};
		return frame;
	end
	t[#t+1] = MakeOptionsMenu();

	t[#t+1] = Def.ActorFrame { 
		InitCommand=cmd(x,round(SCREEN_CENTER_X+flip*StepsPaneScale(-250,-270),0);y,SCREEN_CENTER_Y+0);
		BeginCommand=cmd(visible,false);
		ShowCommand=cmd(visible,true);
		HideCommand=cmd(visible,false);
		StepsChosenMessageCommand=function( self, param ) 
			if param.Player ~= pn then return end;
			self:playcommand("Show");
		end;
		StepsUnchosenMessageCommand=function( self, param ) 
			if param.Player ~= pn then return end;
			self:playcommand("Hide");
		end;
		Def.ActorFrame {
			InitCommand=cmd(y,25;);
			ShowCommand=cmd(finishtweening;addy,-20;zoom,1.5;accelerate,0.2;zoom,1;addy,20);
			LoadActor("check outline");
			LoadActor("check fill") .. {
				ShowCommand=cmd(finishtweening;glow,color("#FFFFFF");accelerate,0.2;glow,color("#FFFFFF00"));
			};
			LoadActor("check ready") .. {
				InitCommand=cmd(y,37);
				ShowCommand=cmd(finishtweening;diffusealpha,0;zoom,0.5;sleep,0.1;linear,0.1;zoom,1;diffusealpha,1);
			};
		};
		LoadFont("_venacti 15px bold") .. {
			Text = THEME:GetString(Var "LoadingScreen", "PressToUnReady");
			InitCommand=cmd(wrapwidthpixels,140;y,-54;shadowlength,1);
			SetCommand=function(self, params)
				if params.PlayerNumber and params.PlayerNumber ~= pn then return end
				if GAMESTATE:IsCourseMode() then self:visible(false); return; end
				local steps = GAMESTATE:GetCurrentSteps(pn)
				local st = steps and steps:GetStepsType();
				local IsNotRoutine = st ~= "StepsType_Pump_Routine";
				self:visible(IsNotRoutine);
			end;
			BeginCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_1});
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_2});
		};
		LoadFont("_venacti 15px bold") .. {
			Text = THEME:GetString(Var "LoadingScreen", "PressToUnReadyCourse");
			InitCommand=cmd(wrapwidthpixels,140;y,-54;shadowlength,1);
			SetCommand=function(self, params)
				if params.PlayerNumber and params.PlayerNumber ~= pn then return end
				if not GAMESTATE:IsCourseMode() then self:visible(false); return; end
				local steps = GAMESTATE:GetCurrentSteps(pn)
				local st = steps and steps:GetStepsType();
				local IsNotRoutine = st ~= "StepsType_Pump_Routine";
				self:visible(IsNotRoutine);
			end;
			BeginCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_1});
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_2});
		};

		LoadFont("_venacti 15px bold") .. {
			Text = THEME:GetString(Var "LoadingScreen", "BothPlayersRoutine");
			InitCommand=cmd(wrapwidthpixels,140;y,-54;shadowlength,1);
			BeginCommand=cmd(visible,false);
			SetCommand=function(self, params)
				if params.PlayerNumber and params.PlayerNumber ~= pn then return end
				if GAMESTATE:IsCourseMode() then self:visible(false); return; end
				local steps = GAMESTATE:GetCurrentSteps(pn)
				local st = steps and steps:GetStepsType();
				local IsRoutine = st == "StepsType_Pump_Routine";
				self:visible(IsRoutine);
			end;
			BeginCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_1});
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_2});
		};
	};	

	t[#t+1] = LoadActor("card profiles", {PlayerNumber=pn}) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,320);
	};
	

	t[#t+1] = LoadActor("options frame") .. { 
		InitCommand=cmd(player,pn;x,SCREEN_CENTER_X+flip*-237;y,SCREEN_CENTER_Y;zoomx,flip);
		BeginCommand=function(self)
		end;
		PlayerJoinedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				self:visible( true );
			end;
		OnCommand=cmd(diffusealpha,0);
		OptionsListOpenedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				self:stoptweening();
				self:decelerate(0.2);
				self:diffusealpha(1);
			end;
		OptionsListClosedMessageCommand=function( self, param )
				if param.Player ~= pn then return end;
				self:stoptweening();
				self:decelerate(0.2);
				self:diffusealpha(0);
			end;
	};

	t[#t+1] = MakeBothPlayersNotice(pn) .. {
		InitCommand=cmd(x,SCREEN_CENTER_X-239*flip;y,SCREEN_CENTER_Y-155);
		OnCommand=cmd(shadowlength,1;zoom,0.5;diffusealpha,0);
	};

	return t;
end





local function DifficultyIcons(pn)
	local function set(self, player)
		if player and player ~= pn then return end
		local Selection = GAMESTATE:GetCurrentSteps(pn) or GAMESTATE:GetCurrentTrail(pn)

		if not Selection then
			self:Unset();
			return
		end
		local dc = Selection:GetDifficulty()
		self:SetFromDifficulty( dc );
	end

	local t = Def.DifficultyIcon {
		File="_difficulty icons 1x6";
		InitCommand=function(self)
			self:player( pn );
			self:SetPlayer( pn );
		end;

		CurrentStepsP1ChangedMessageCommand=function(self) set(self, PLAYER_1); end;
		CurrentStepsP2ChangedMessageCommand=function(self) set(self, PLAYER_2); end;
		CurrentTrailP1ChangedMessageCommand=function(self) set(self, PLAYER_1); end;
		CurrentTrailP2ChangedMessageCommand=function(self) set(self, PLAYER_2); end;
	};
	return t;
end

local function CurrentSortText()
	return LoadFont("_venacti 26px bold diffuse") .. {
		InitCommand=cmd(zoom,0.6;diffusetopedge,color("#fffa06");diffusebottomedge,color("#ffbb0a");shadowlength,1);
		BeginCommand=cmd(playcommand,"Set");
		SortOrderChangedMessageCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:visible(false);
				return;
			end
			self:visible(true);

			local so = GAMESTATE:GetSortOrder();
			local s = SortOrderToLocalizedString( so );
			if so == "SortOrder_PinnedMeter" then
				local pn = GAMESTATE:GetSortOrderPinnedToDifficultyPlayer()
				local player_text = (pn == PLAYER_1) and "P1 " or "P2 ";
				s = player_text .. s;
			end
			--s = string.upper( s );	-- TODO: upper doesn't work for French
			self:settext( "Sort: " .. s );
		end;
	};
end

function SongCenterFrame()
	local t = Def.ActorFrame {
		InitCommand=cmd(ztest,true);
		OnCommand=cmd(y,SCREEN_CENTER_Y-31);
	};
	
	t[#t+1] = Def.ActorFrame { 
		InitCommand=cmd(y,1);
		
		LoadActor( THEME:GetPathG("","_StepsType icon single") ) .. {
			InitCommand=cmd(x,-128;y,2;playcommand,"Refresh";);
			OnCommand=cmd();
			OffCommand=cmd();
			--StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0);
			RefreshCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				local playable = false;
				if song and SongUtil.IsStepsTypePlayable(song,"StepsType_Pump_Single") then
					playable = true;
				end
				self:diffusealpha( playable and 1 or 0.2 );
			end;
			BeginCommand=cmd(playcommand,"Refresh";);
			CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh";);
			PlayerJoinedMessageCommand=cmd(playcommand,"Refresh";);
		};

		LoadActor( THEME:GetPathG("","_StepsType icon halfdouble") ) .. {
			InitCommand=cmd(x,5;y,2;playcommand,"Refresh";visible,GameMode() ~= "multi");
			OffCommand=cmd();
			RefreshCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				local playable = false;

				-- darken for one player, hide completely for two players
				local alpha = GAMESTATE:GetNumSidesJoined() ~= 2 and 0.2 or 0;

				if song and SongUtil.IsStepsTypePlayable(song,"StepsType_Pump_Halfdouble") then
					playable = true;
				end
				self:diffusealpha( playable and 1 or alpha );
			end;
			BeginCommand=cmd(playcommand,"Refresh";);
			CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh";);
			PlayerJoinedMessageCommand=cmd(playcommand,"Refresh";);
			PlayerUnjoinedMessageCommand=cmd(playcommand,"Refresh");
		};
	
		LoadActor( THEME:GetPathG("","_StepsType icon double") ) .. {
			InitCommand=cmd(x,74;y,2;playcommand,"Refresh";visible,GameMode() ~= "multi");
			OffCommand=cmd();
		--	StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0;);
			RefreshCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				local playable = false;

				if song then
					if SongUtil.IsStepsTypePlayable(song,"StepsType_Pump_Double") or
					   SongUtil.IsStepsTypePlayable(song,"StepsType_Pump_Routine") then
						playable = true;
					end
				end
				self:diffusealpha( playable and 1 or 0.2 );
			end;
			BeginCommand=cmd(playcommand,"Refresh";);
			CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh";);
			PlayerJoinedMessageCommand=cmd(playcommand,"Refresh";);
		};

		LoadActor( "difficulties" ) .. {
			InitCommand=cmd(x,-130);
			OnCommand=cmd();
			OffCommand=cmd();
		--	StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0);
		};
	};

	t[#t+1] = Def.ActorFrame { 
		OnCommand=cmd(y,-20);
	--	StartSelectingStepsMessageCommand=cmd(linear,0.5;addy,-40);

		
		Def.ActorFrame { 
			
			LoadFont("_venacti 26px bold diffuse") .. {
				InitCommand=cmd(diffuse,color('#802626');x,-90;zoom,0.55;skewx,-.1;shadowlength,0;halign,0;maxwidth,400;);
				BeginCommand=cmd(playcommand,"Set");
				OffCommand=cmd();
				SetCommand=function(self) 
					local song = GAMESTATE:GetCurrentSong();
					self:settext( song and song:GetDisplayArtist() or "..." );
				end;
				CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
				CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			};
			InitCommand=cmd(x,-50);
		};

		LoadFont("_venacti 26px bold diffuse") .. {
			InitCommand=cmd(diffuse,color('#802626');halign,0;skewx,-.1;x,122;y,2;zoom,0.4;shadowlength,0);
			Text="BPM";
		};

		-- BPM (XXX duplicates course BPM)
		Def.ActorFrame { 
			Name="BPMDisplay";
			LoadFont("BPM", "Normal") .. {
				Name="BPM";
				InitCommand=cmd(diffuse,color('#802626');halign,1;x,118;skewx,-.1;shadowlength,0;zoom,0.55;draworder,1);
				SetCommand=function(self)
					local song = GAMESTATE:GetCurrentSong();
					if not song then
						self:settext("");
						return;
					end

					local Min = 999999;
					local Max = 0;
					local SongMin, SongMax = song:GetDisplayBpms();
					Min = math.min(Min, SongMin);
					Max = math.max(Max, SongMax);
					if Min == Max then
						self:settext(string.format("%i", Min));
					else
						self:settext(string.format("%i-%i", Min, Max));
					end
				end;
				BeginCommand=cmd(playcommand,"Set");
				CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
				CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			};
		};

		Def.Quad {
			InitCommand=cmd(x,-96;y,24-44;diffuse,color("#fff8aa");zoomtowidth,105;zoomtoheight,22;faderight,1;);
			OnCommand=cmd(playcommand,"Set");
			OffCommand=cmd(linear,0.2;diffusealpha,0;rotationz,-25);
			ShowCommand=cmd(stoptweening;diffusealpha,0;linear,0.2;diffusealpha,1);
			HideCommand=cmd(stoptweening;diffusealpha,0);
			SetCommand=function(self, params)
				if params.PlayerNumber and params.PlayerNumber ~= pn then return end
				local num_stages = GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse();
				local show = num_stages > 1;
				self:playcommand( show and "Show" or "Hide" );
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_1});
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_2});
		};
		
		LoadFont( "_venacti 26px normal" ) .. {
			InitCommand=cmd(x,-96;y,24-44;diffuse,color("#FFFFFF");shadowlength,0;zoom,0.5;diffuseblink;effectcolor1,color("#FF0000");effectcolor2,color("#000000");effectperiod,0.5;effecttiming,0.4,0,0.1,0);
			OnCommand=cmd(playcommand,"Set");
			OffCommand=cmd(linear,0.2;diffusealpha,0;rotationz,-25);
			ShowCommand=cmd(stoptweening;diffusealpha,0;linear,0.2;diffusealpha,1);
			HideCommand=cmd(stoptweening;diffusealpha,0);
			SetCommand=function(self, params)
				local num_stages = GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse();
				local show = num_stages > 1;
				--self:visible( show );
				self:settext( "LONG VERSION" );
				self:playcommand( show and "Show" or "Hide" );
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_1});
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set", {PlayerNumber=PLAYER_2});
		};
	};

	return t;
end;

function CourseCenterFrame()
	local t = Def.ActorFrame {
		InitCommand=cmd(ztest,true);
	};

	-- Song list and scrolling masks:
	t[#t+1] = Def.ActorFrame { 
		InitCommand=cmd(x,-50);

		Def.Quad {
			InitCommand=cmd(valign,1;setsize,200,65;y,-35;diffuse,color("#00FFFF");
				blend,"BlendMode_NoEffect";zwrite,true);
		};
		Def.Quad {
			InitCommand=cmd(setsize,200,65;valign,0;y,32;diffuse,color("#00FFFF");
				blend,"BlendMode_NoEffect";zwrite,true);
		};
		Def.CourseContentsList {
			MaxSongs = 12;
			NumItemsToDraw = 8;
			InitCommand=cmd(x,-88;y,-27;SetMask,0,0);
			BeginCommand=cmd(playcommand,"Refresh");
			OnCommand=cmd(playcommand,"Refresh";SetPauseCountdownSeconds,0.55);
			OffCommand=cmd(stoptweening);
			RefreshCommand=function(self)
				self:stoptweening();

				self:SetFromGameState();
				--[[
				self:SetSecondsPauseBetweenItems(0.35);
				]]
				self:SetLoop(false);
				self:SetPauseCountdownSeconds(0.05);
				self:SetSecondsPauseBetweenItems(0);
				self:SetCurrentAndDestinationItem(0)---2.5);

				local course = GAMESTATE:GetCurrentCourse();
				if course and course:GetEstimatedNumStages() > 4 then
					self:playcommand("ScrollUp");
					self:setsecondsperitem(0.05);
				end
			end;
			ScrollDownCommand = function(self)
				self:finishtweening();
				self:setsecondsperitem(0.9);
				self:SetDestinationItem( self:GetNumChildren()-4 );
				local fTime = self:getsecondtodestination();
				self:sleep(fTime + 0.5);
				self:queuecommand("ScrollUp");
			end;
			ScrollUpCommand = function(self)
				self:finishtweening();
				self:setsecondsperitem(0.9);
				self:SetDestinationItem( 0 );
				local fTime = self:getsecondtodestination();
				self:sleep(fTime + 0.5);
				self:queuecommand("ScrollDown");
			end;
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Refresh");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Refresh");
			PlayerJoinedMessageCommand=cmd(playcommand,"Refresh");
			Display = Def.ActorFrame { 
				InitCommand=cmd(setsize,350,16);

				LoadFont("_venacti 15px bold") .. {
					InitCommand=cmd(shadowlength,0;halign,0;zoom,1.0;ztest,true);
					SetSongCommand=function(self, params)
						self:diffuse( color("#FFFFFF") );
						self:maxwidth(170);
						if params.Song and not params.Secret then
							self:settext( params.Song:GetDisplayFullTitle() );
						else
							self:settext( "??????????????????" );
						end
					end;
				};

				LoadFont("_venacti 15px bold") .. {
					InitCommand=cmd(ztest,true;x,180;zoom,1.0;shadowlength,0);
					OnCommand=cmd();
					SetSongCommand=function(self, params)
						if params.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() then return end
						local c = StepsOrTrailToColor(params.Steps);
						self:settext( params.Meter ); self:diffuse( c );
						--self:diffuse( color("#C0C0C0") );
						self:diffuse( c );
					end;
				};
			};
		};
	};

	function SetMeter(self)
		local pn = GAMESTATE:GetMasterPlayerNumber();
		if not pn then return end -- can be null when we updating during SContinue

		local Selection = GAMESTATE:GetCurrentTrail( pn );
		if not Selection then
			self:settext("");
		else
			local meter = Selection:GetMeter();
			self:settext( string.format("%i",meter) );
		end
	end;

	-- Single/double icon and meter:
	t[#t+1] = Def.ActorFrame { 
		InitCommand=cmd(x,98;y,15);
		BeginCommand=cmd(playcommand,"Refresh");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Refresh");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Refresh");
		PlayerJoinedMessageCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
			local trail = GAMESTATE:GetCurrentTrail( GAMESTATE:GetMasterPlayerNumber() );
			local st = trail and trail:GetStepsType();
			local single = st and st == "StepsType_Pump_Single" or false;
			local double = st and st == "StepsType_Pump_Double" or false;
playable=false;
			local single_icon = self:GetChild("Single");
			local double_icon = self:GetChild("Double");
			local text = self:GetChild("BPM");
			single_icon:visible( single );
			double_icon:visible( double );
			if single then
				text:x(8);
			else
				text:x(16);
			end
		end;

		LoadActor( THEME:GetPathG("","_StepsType icon single") ) .. {
			Name="Single";
			InitCommand=cmd(x,-8;y,3);
		};

		LoadActor( THEME:GetPathG("","_StepsType icon double") ) .. {
			Name="Double";
			InitCommand=cmd(x,-6;y,3);
		};

		LoadFont("_venacti numbers 26px bold") .. {
			Name="BPM";
			InitCommand=cmd(shadowlength,0;zoom,0.6;halign,0;x,8;y,0);

			--OnCommand=cmd(shadowlength,0;zoom,0.6);--;diffuse,color("#000000"));
			BeginCommand=function(self) SetMeter(self); end;
			CurrentTrailP1ChangedMessageCommand=function(self) SetMeter(self); end;
			CurrentTrailP2ChangedMessageCommand=function(self) SetMeter(self); end;
		};
	};

	-- Difficulty label:
	t[#t+1] = LoadFont("_venacti 26px normal") .. {
		InitCommand=cmd(halign,1;x,142;y,62-82;zoom,0.5;diffuse,color("#000000");shadowlength,0);
		Text="DIFFICULTY";
	};

	-- BPM:
	t[#t+1] = Def.ActorFrame { 
		InitCommand=cmd(x,110;y,-22;zoom,0.6);
		LoadFont("_venacti 26px bold diffuse") .. {
			Name="BPM";
			InitCommand=cmd(halign,0;x,-55;shadowlength,0;ztest,true);
			SetCommand=function(self)
				local course = GAMESTATE:GetCurrentCourse();
				if not course then
					self:settext("");
					return;
				end

				local Min = 999999;
				local Max = 0;
				for ce in ivalues(course:GetCourseEntries()) do
					local SongMin, SongMax = ce:GetSong():GetDisplayBpms();
					Min = math.min(Min, SongMin);
					Max = math.max(Max, SongMax);
				end
				self:settext(string.format("%i-%i", Min, Max));
			end;
			BeginCommand=cmd(playcommand,"Set");
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		};
	};

	return t;
end;

local t = Def.ActorFrame {
	OnCommand=cmd(finishtweening);
	CodeMessageCommand = function(self, param)

	--[[
		local pn = param.PlayerNumber;
		if not SCREENMAN:GetTopScreen():GetAnyStillEntering() and param.Name == "Enter" then
			if SCREENMAN:GetTopScreen():Finish(pn) then
				c.Enter:play();
			end
			return;
		end
		if SCREENMAN:GetTopScreen():GetFinalized( pn ) then
			return;
		end

		if param.Name == "Left" or param.Name == "Right" then
			local iDir = param.Name == "Left" and -1 or 1;
			
			local idx = LetterIndexes[ Selection[pn] ];
			idx = idx + iDir;
			idx = math.mod(idx+#Letters-1, #Letters)+1;
			self:playcommand("SelectKey", { Key = Letters[idx], PlayerNumber = pn });
			c.Move:playforplayer(pn);
			return;
		end

		if param.Name == "Backspace" then
			if SCREENMAN:GetTopScreen():Backspace(pn) then
				c.Back:playforplayer(pn);
			end
			return;
		end
			]]
	end;
};

local function MakeBannerFrame()
	local f = Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-74;ztest,true);
	--	OnCommand=cmd(addy,100;zoom,0.75;sleep,0.25;decelerate,0.3;addy,-100;zoom,1);
		BeginCommand=cmd(visible,not GAMESTATE:IsCourseMode());
	};


	f[#f+1] = Def.Quad {
		InitCommand=cmd(setsize,360,184;diffuse,color("#FF00FF");y,-24;
			blend,"BlendMode_NoEffect";zwrite,true);
		OnCommand=cmd(cropleft,0.5;linear,0.3;cropleft,1);
	};
	f[#f+1] = Def.Quad {
		InitCommand=cmd(setsize,360,184;diffuse,color("#FF00FF");y,-24;
			blend,"BlendMode_NoEffect";zwrite,true);
		OnCommand=cmd(cropright,0.5;linear,0.3;cropright,1);
	};

	f[#f+1] = Def.ActorProxy {
		BeginCommand=function(self) local banner = SCREENMAN:GetTopScreen():GetChild('Banner'); self:SetTarget(banner); end;
		InitCommand=cmd(y,-22-13);
	};

	f[#f+1] = LoadActor( "_banner frame" );
	return f;
end

local function MakeCourseBannerFrame()
	local f = Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-74-4;ztest,true);
	--	OnCommand=cmd(addy,100;zoom,0.75;sleep,0.25;decelerate,0.3;addy,-100;zoom,1);
		BeginCommand=cmd(visible,GAMESTATE:IsCourseMode());
	};

	f[#f+1] = Def.Quad {
		InitCommand=cmd(setsize,360,192;diffuse,color("#FF00FF");y,1;
			blend,"BlendMode_NoEffect";zwrite,true);
		OnCommand=cmd(cropleft,0.5;linear,0.3;cropleft,1);
	};
	f[#f+1] = Def.Quad {
		InitCommand=cmd(setsize,360,192;diffuse,color("#FF00FF");y,1;
			blend,"BlendMode_NoEffect";zwrite,true);
		OnCommand=cmd(cropright,0.5;linear,0.3;cropright,1);
	};

	f[#f+1] = Def.ActorProxy {
		BeginCommand=function(self) local banner = SCREENMAN:GetTopScreen():GetChild('Banner'); self:SetTarget(banner); end;
		InitCommand=cmd(y,-22-13);
	};

	f[#f+1] = LoadActor("_course banner frame");
	return f;
end

t[#t+1] = MakeBannerFrame();
t[#t+1] = MakeCourseBannerFrame();

t[#t+1] = SongCenterFrame() .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-62);
	BeginCommand=cmd(visible,not GAMESTATE:IsCourseMode());
};

t[#t+1] = CourseCenterFrame() .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-24);
	BeginCommand=cmd(visible,GAMESTATE:IsCourseMode());
};


t[#t+1] = Def.ActorFrame { 
	InitCommand=cmd(y,SCREEN_CENTER_Y-74);
	BeginCommand=cmd(visible,not GAMESTATE:IsCourseMode());
	OnCommand=cmd(finishtweening;x,SCREEN_CENTER_X;linear,0.3;addx,360/2);
	LoadActor("_banner flash") .. {
		OnCommand=cmd(finishtweening;diffusealpha,1;sleep,0.25;linear,0.05;diffusealpha,0);
	};
};

t[#t+1] = Def.ActorFrame { 
	InitCommand=cmd(y,SCREEN_CENTER_Y-74);
	BeginCommand=cmd(visible,not GAMESTATE:IsCourseMode());
	OnCommand=cmd(finishtweening;x,SCREEN_CENTER_X;linear,0.3;addx,-360/2);
	LoadActor("_banner flash") .. {
		OnCommand=cmd(finishtweening;diffusealpha,1;sleep,0.25;linear,0.05;diffusealpha,0);
	};
};

t[#t+1] = Def.ActorFrame { 
	InitCommand=cmd(y,SCREEN_CENTER_Y-78);
	BeginCommand=cmd(visible,GAMESTATE:IsCourseMode());
	OnCommand=cmd(finishtweening;x,SCREEN_CENTER_X;linear,0.3;addx,-360/2);
	LoadActor("_course banner flash") .. {
		OnCommand=cmd(finishtweening;diffusealpha,1;sleep,0.25;linear,0.05;diffusealpha,0);
	};
};

t[#t+1] = Def.ActorFrame { 
	InitCommand=cmd(y,SCREEN_CENTER_Y-78);
	BeginCommand=cmd(visible,GAMESTATE:IsCourseMode());
	OnCommand=cmd(finishtweening;x,SCREEN_CENTER_X;linear,0.3;addx,360/2);
	LoadActor("_course banner flash") .. {
		OnCommand=cmd(finishtweening;diffusealpha,1;sleep,0.25;linear,0.05;diffusealpha,0);
	};
};

t[#t+1] = LoadActor("outer frames");

t[#t+1] = CurrentSortText() .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-59);
	OnCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1);
	StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0);
};

t[#t+1] = PlayerArea( PLAYER_1 );
t[#t+1] = PlayerArea( PLAYER_2 );


t[#t+1] = Def.Quad {
	InitCommand=cmd(clearzbuffer,true;halign,0;x,SCREEN_CENTER_X+137;y,SCREEN_CENTER_Y+88;z,1;blend,"BlendMode_NoEffect";zwrite,1;setsize,294,280;diffuse,color("#FF000077"));
	StartSelectingStepsMessageCommand=cmd(sleep,0.5;diffusealpha,0;);
	DoInvisibleCommand=cmd(visible,false);
};

t[#t+1] = LoadFont("_regra bold 30px") .. {
	Text="Press &START; when ready";
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+96;shadowlength,0;wrapwidthpixels,250);
	BeginCommand=cmd(visible,GAMESTATE:IsCourseMode());
	OnCommand=cmd(diffusealpha,0);
	StartSelectingStepsMessageCommand=cmd(finishtweening;sleep,0.2;addy,-30;linear,0.3;diffusealpha,1;addy,30);
};

local function MakeStepsDisplayList()
	local f = Def.StepsDisplayList {
		Name="StepsDisplayList";
		OnCommand=cmd(x,SCREEN_CENTER_X+286;y,SCREEN_CENTER_Y+10;runcommandsonleaves,cmd(ztest,true));
		BeginCommand=cmd(visible,false);
		StartSelectingStepsMessageCommand=function(self)
			if GAMESTATE:IsCourseMode() then return end
			self:visible(true);
			self:setfromgamestate();
			self.StartSelectingSteps = true;
			self:playcommand("SlideOn");
		end;
		SlideOnCommand=cmd(linear,0.5;addx,-286;);
		RefreshCommand=function(self) if self.StartSelectingSteps then self:setfromgamestate() end end;
		UpdateContentsCommand=function(self)
			if not self:GetVisible() then return end;
			Trace("update");
			self:setfromgamestate();
		end;
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"UpdateContents");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"UpdateContents");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"UpdateContents");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"UpdateContents");

		CursorP1Frame = LoadActor( "_cursor frame p1" ) .. {
		};
		CursorP2Frame = LoadActor( "_cursor frame p2" ) .. {
		};
	};

	local function MakeCursor(pn, path)
		local flip = (pn == PLAYER_1 and 1 or -1 );
		local Update = cmd(effectmagnitude,self:getaux()*-10*flip,0,0);
		local f = Def.ActorFrame {
			InitCommand=cmd(aux,1;x,-120*flip;bounce;effectperiod,1.0;effectoffset,0.0;effectclock,"bgm";SetUpdateFunction,Update);

			StepsChosenMessageCommand=function( self, param ) 
				if param.Player ~= pn then return end;
				self:stoptweening();
				self:accelerate(0.3);
				self:aux(0);
			end;
			StepsUnchosenMessageCommand=function( self, param ) 
				if param.Player ~= pn then return end;
				self:stoptweening();
				self:accelerate(0.3);
				self:aux(1);
			end;
			LoadActor( path ) .. {
				BeginCommand=cmd(player,pn);
				PlayerJoinedMessageCommand=function(self,param )
					if param.Player ~= pn then return end;
					self:visible( true );
				end;
			};
		};

		local X = pn==PLAYER_1 and -4 or -3; -- nudge P2 slightly for alignment
		f[#f+1] = LoadFont( "common normal" ) .. {
			Text=pn == PLAYER_1 and "P1" or "P2";
			InitCommand=cmd(x,X*flip;y,-1;zoom,0.4;diffuse,color("#000000");shadowlength,0);
			BeginCommand=cmd(player,pn);
			PlayerJoinedMessageCommand=function(self,param )
				if param.Player ~= pn then return end;
				self:visible( true );
			end;
		};
		return f;
	end

	f.CursorP1 = MakeCursor(PLAYER_1, "_cursor p1");
	f.CursorP2 = MakeCursor(PLAYER_2, "_cursor p2");

	return f;
end
t[#t+1] = MakeStepsDisplayList()

t[#t+1] = LoadActor( THEME:GetPathB("ScreenWithMenuElements","overlay") );

-- Lock input briefly when a song is chosen, so players don't choose a
-- steps accidentally if both players press start to choose a song simultaneously.
t[#t+1] = Def.Actor { 
	StartSelectingStepsMessageCommand=function() SCREENMAN:GetTopScreen():lockinput(0.5); end;
};





if not GAMESTATE:GetMultiplayer() then
	t[#t+1] = LoadActor( THEME:GetPathB("","_join menu overlay") );
else
	local pads = 32;
	if WirelessLicensing then
		pads = WirelessLicensing.GetLicensedPads();
	end
	local PlayerPillFrame = Def.ActorFrame {
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-60;playcommand,"Reposition";);
		MultiPlayerConnectedChangedMessageCommand=cmd(playcommand,"Reposition";);
		RepositionCommand=function(self,param)
			local numConnected = GetNumConnectedMultiPlayers();
			local joinedIndex = 0;
			for i = 1,pads do
				local child = self:GetChild(i);
				if IsMultiPlayerConnected(MultiPlayer[i]) then	
					ScreenSelectMusicMultiplayerItemPositionJoined( child, joinedIndex, numConnected );
					joinedIndex = joinedIndex + 1;
				else
					(cmd(stoptweening;linear,0.2;zoom,0;))(child);
				end
			end
		end;
	};
	for i = 1,pads do
		PlayerPillFrame[#PlayerPillFrame+1] = Def.ControllerStateDisplay { 
			Name=i;
			InitCommand=cmd(LoadMultiPlayer,"ControllerStateDisplay",MultiPlayer[i];);
		};
	end
	t[#t+1] = PlayerPillFrame;
--	t[#t+1] = Def.ActorFrame {
--		InitCommand=cmd(x,SCREEN_CENTER_X+268;y,SCREEN_CENTER_Y+118;);
--		LoadActor("steps pane multiplayer") .. {
--			InitCommand=cmd(zoomx,-1;);
--		};
--		LoadFont("Common normal") .. {
--			InitCommand=cmd(x,-30;y,4;settext,"Class High Score:  78.92%\nLocation High Score:  92.34%\nClass Popularity: #1\nLocation Popularity: #4";shadowlength,0;zoom,0.5;vertspacing,16;);
--		};
--	};
end

t[#t].OffCommand = nil; -- don't tween out

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+320);

	LoadActor( "wheel highlight" ) .. {
		OnCommand=cmd(stoptweening;faderight,1.5;fadeleft,1.5;sleep,0.75;linear,0.15;faderight,0;fadeleft,0;);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Changed");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Changed");
		ChangedCommand=function(self)
			local Screen = SCREENMAN:GetTopScreen();
			local Wheel = Screen:GetChild("MusicWheel");
			if not Wheel then return; end

			local SelectionType = Wheel:GetSelectedType();
			if SelectionType == "WheelItemDataType_Song" or SelectionType == "WheelItemDataType_Course" then
				self:playcommand("ChangedToSongOrCourse");
			else
				self:playcommand("ChangedToNoSong");
			end
		end;
		ChangedToSongOrCourseCommand=cmd(stoptweening;linear,0.1;fadeleft,1.5;faderight,1.5;linear,0.3;faderight,0;fadeleft,0);
		ChangedToNoSongCommand=cmd(stoptweening;linear,0.1;fadeleft,1.5;faderight,1.5);
		StartSelectingStepsMessageCommand=cmd(stoptweening;accelerate,0.2;diffusealpha,0);
	};
	
	LoadActor("MusicWheel selector" ) .. {
		InitCommand=cmd(x,-124);
		CurrentSongChangedMessageCommand=cmd(stoptweening;linear,0.1;x,-124-5;sleep,.15;linear,0.12;x,-124);
		CurrentCourseChangedMessageCommand=cmd(stoptweening;linear,0.1;x,-124-5;sleep,.15;linear,0.12;x,-124);
		StartSelectingStepsMessageCommand=cmd(stoptweening;accelerate,0.25;addx,-20;diffusealpha,0);
		OnCommand=cmd(finishtweening;addy,-100;diffusealpha,0;sleep,0.4;decelerate,0.4;addy,100;diffusealpha,1);
	};
	LoadActor("MusicWheel selector" ) .. {
		InitCommand=cmd(x,124;zoomx,-1);
		CurrentSongChangedMessageCommand=cmd(stoptweening;linear,0.1;x,124+5;sleep,.15;linear,0.12;x,124);
		CurrentCourseChangedMessageCommand=cmd(stoptweening;linear,0.1;x,124+5;sleep,.15;linear,0.12;x,124);
		StartSelectingStepsMessageCommand=cmd(stoptweening;accelerate,0.25;addx,20;diffusealpha,0);
		OnCommand=cmd(finishtweening;addy,-100;diffusealpha,0;sleep,0.4;decelerate,0.4;addy,100;diffusealpha,1);
	};
	LoadActor("MusicWheel pulse" ) .. {
		InitCommand=cmd(x,-124;blend,"BlendMode_Add";diffuseramp;effectoffset,0.15;effectcolor1,color("#55555555");effectcolor2,color("#FFFFFFFF");effectclock,"bgm");
		OnCommand=cmd(finishtweening;addy,-100;diffusealpha,0;sleep,0.4;decelerate,0.4;addy,100;diffusealpha,1);
		CurrentSongChangedMessageCommand=cmd(stoptweening;linear,0.1;x,-124-5;sleep,.15;linear,0.12;x,-124);
		CurrentCourseChangedMessageCommand=cmd(stoptweening;linear,0.1;x,-124-5;sleep,.15;linear,0.12;x,-124);
		StartSelectingStepsMessageCommand=cmd(stoptweening;accelerate,0.25;addx,-20;diffusealpha,0);
	};
	LoadActor("MusicWheel pulse" ) .. {
		InitCommand=cmd(x,124;zoomx,-1;blend,"BlendMode_Add";diffuseramp;effectoffset,0.15;effectcolor1,color("#55555555");effectcolor2,color("#FFFFFFFF");effectclock,"bgm");
		OnCommand=cmd(finishtweening;addy,-100;diffusealpha,0;sleep,0.4;decelerate,0.4;addy,100;diffusealpha,1);
		CurrentSongChangedMessageCommand=cmd(stoptweening;linear,0.1;x,124+5;sleep,.15;linear,0.12;x,124);
		CurrentCourseChangedMessageCommand=cmd(stoptweening;linear,0.1;x,124+5;sleep,.15;linear,0.12;x,124);
		StartSelectingStepsMessageCommand=cmd(stoptweening;accelerate,0.25;addx,20;diffusealpha,0);
	};
	
	
	
	
	
};

return t;
