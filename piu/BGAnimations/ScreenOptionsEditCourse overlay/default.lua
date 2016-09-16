--FIXME: Hack to hide 2-sided steps in StepsDisplayList
GAMESTATE:SetMultiplayer(true);

return Def.ActorFrame {
	LoadActor( THEME:GetPathB('ScreenOptionsSimple','overlay') );
	Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X+136;y,SCREEN_CENTER_Y);
		BeginCommand=cmd(playcommand,"Refresh";playcommand,"RefreshVisible";);
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Refresh");
		CurrentSongChangedMessageCommand=cmd(playcommand,"RefreshVisible";);
		RefreshVisibleCommand=cmd(visible,not GAMESTATE:GetCurrentSong(););
		LoadFont("common normal") .. {
			OnCommand=cmd(y,-134;zoom,0.7;shadowlength,2;playcommand,"CurrentCourseChanged");
			RefreshCommand=function(self)
				local course = GAMESTATE:GetCurrentCourse()
				if not course then return end
				local s = course:GetDisplayFullTitle()
				if s == '' then s = THEME:GetString('ScreenOptionsEditCourse','(no name)') end
				self:settext( s )
			end;
		};
		LoadFont("common normal") .. {
			OnCommand=cmd(y,-116;zoom,0.6;shadowlength,2;playcommand,"CurrentCourseChanged");
			RefreshCommand=function(self)
				local course = GAMESTATE:GetCurrentCourse()
				local trail = GAMESTATE:GetCurrentTrail(PLAYER_1);
				if course == nil or trail == nil then
					self:settext( "" )
					return
				end

				local s = string.format( THEME:GetString('ScreenOptionsEditCourse','%d songs, %.1f minutes'), TrailUtil.GetNumSongs(trail), TrailUtil.GetTotalSeconds(trail)/60 )
				local stop_minutes = GAMESTATE:GetCurrentCourse():GetGoalSeconds() / 60;
				if stop_minutes ~= 0 then
					s = s .. ", " .. string.format( THEME:GetString('ScreenOptionsEditCourse',"cut-off at %d minutes"), stop_minutes )
				end
				self:settext( s )
			end;
		};
	};
	Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X+136;y,SCREEN_CENTER_Y);
		BeginCommand=cmd(playcommand,"CurrentCourseChanged";playcommand,"RefreshVisible";);
		CurrentSongChangedMessageCommand=cmd(playcommand,"RefreshVisible";);
		RefreshVisibleCommand=cmd(visible,not GAMESTATE:GetCurrentSong(););
		LoadActor( THEME:GetPathB('','_framed WorkoutGraph') ) .. {
			InitCommand=cmd(y,-36);
		};
		Def.CourseContentsList {
			MaxSongs = 20;
			NumItemsToDraw = 6;
			InitCommand=cmd(x,-82;y,100;SetMask,0,0);
			BeginCommand=cmd(playcommand,"Refresh");
			OnCommand=cmd(playcommand,"Refresh";SetPauseCountdownSeconds,0.55);
			OffCommand=cmd(stoptweening);
			RefreshCommand=function(self)
				self:SetFromGameState();
				--[[
				self:SetSecondsPauseBetweenItems(0.35);
				]]
				self:SetLoop(false);
				self:SetPauseCountdownSeconds(0.05);
				self:SetSecondsPauseBetweenItems(0);
				self:SetCurrentAndDestinationItem(-2.5);

				self:playcommand("ScrollUp");
				self:setsecondsperitem(0.05);
			end;
			ScrollDownCommand = function(self)
				self:finishtweening();
				self:setsecondsperitem(0.25);
				self:SetDestinationItem( self:GetNumChildren()-1-1.0 );
				local fTime = self:getsecondtodestination();
				self:sleep(fTime + 0.5);
				self:queuecommand("ScrollUp");
			end;
			ScrollUpCommand = function(self)
				self:finishtweening();
				self:setsecondsperitem(0.25);
				self:SetDestinationItem( 1.5 );
				local fTime = self:getsecondtodestination();
				self:sleep(fTime + 0.5);
				self:queuecommand("ScrollDown");
			end;
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Refresh");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Refresh");
			PlayerJoinedMessageCommand=cmd(playcommand,"Refresh");
			Display = Def.ActorFrame { 
				InitCommand=cmd(setsize,350,18);

				LoadFont("_venacti 15px bold") .. {
					InitCommand=cmd(shadowlength,0;halign,0;zoom,1.0;ztest,true);
					SetSongCommand=function(self, params)
						self:diffuse( color("#C0C0C0") );
						self:maxwidth(150);
						if params.Song then
							self:settext( params.Song:GetDisplayFullTitle() );
						else
							self:settext( "??????????" );
						end
					end;
				};

				LoadFont("_venacti 15px bold") .. {
					InitCommand=cmd(ztest,true;x,160;zoom,1.0;shadowlength,0);
					OnCommand=cmd();
					SetSongCommand=function(self, params)
						if params.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() then return end
						local c = StepsOrTrailToColor(params.Steps);
						self:settext( params.Meter );
						--self:diffuse( color("#C0C0C0") );
						--self:diffuse( c );
					end;
				};
			};
		};
	};	
	Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X+136;y,SCREEN_CENTER_Y);
		BeginCommand=cmd(playcommand,"CurrentCourseChanged";playcommand,"RefreshVisible";);
		CurrentSongChangedMessageCommand=cmd(playcommand,"RefreshVisible";);
		RefreshVisibleCommand=cmd(visible,GAMESTATE:GetCurrentSong() and true or false;);
		--[[LoadActor( "frame" ) .. {
			InitCommand=cmd(x,0;y,10);
		};
		]]

		Def.Banner {
			InitCommand=cmd(y,-100;scaletoclipped,256,80);
			CurrentSongChangedMessageCommand=function(self, params)
				local song = GAMESTATE:GetCurrentSong();
				if song then 
					self:LoadFromSong( GAMESTATE:GetCurrentSong() );
				else
					self:LoadFromSong( nil );
				end
			end;
		};

		
		Def.StepsDisplayList {
			Name="StepsDisplayListEditCourse";
			InitCommand=cmd(x,10;y,-40);
			CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh";);
			RefreshCommand=function(self, params)
				local song = GAMESTATE:GetCurrentSong();
				self:setfromgamestate();
				if song then 
					self:visible( true );
				else
					self:visible( false );
				end
			end;
			CursorP1 = Def.ActorFrame {
				InitCommand=cmd(x,-120;bounce;effectmagnitude,-5,0,0;effectperiod,1.0;effectoffset,0.0;effectclock,"bgm");
				BeginCommand=cmd(visible,true);
				StepsChosenMessageCommand=function( self, param ) 
					if param.Player ~= "PlayerNumber_P1" then return end;
					self:visible(false);
				end;

				LoadActor( "_cursor p1" ) .. {
					BeginCommand=cmd(player,"PlayerNumber_P1";);
					PlayerJoinedMessageCommand=function(self,param )
						if param.Player ~= "PlayerNumber_P1" then return end;
						self:visible( true );
					end;
				};
				LoadFont( "common normal" ) .. {
					Text="P1";
					InitCommand=cmd(x,-4;y,-1;zoom,0.4;diffuse,color("#000000");shadowlength,0);
					BeginCommand=cmd(player,"PlayerNumber_P1";);
					PlayerJoinedMessageCommand=function(self,param )
						if param.Player ~= "PlayerNumber_P1" then return end;
						self:visible( true );
					end;
				};
			};
			CursorP2 = Def.Actor {};
			CursorP1Frame = Def.Actor {};
			CursorP2Frame = Def.Actor {};
		};
	

		Def.ActorFrame {
			Name="Contents";
			InitCommand=cmd(x,0;y,60;);
						
			Def.ActorFrame {
				Name="Stats";
				BeginCommand=cmd(visible,true);

				InitCommand=cmd();
				LoadActor( "_steps info labels" ) .. { Name="StepsInfoIcon1"; InitCommand=cmd(pause;setstate,0;x,StepsPaneScale(-54,-68)+StepsPaneScale(76,86)*0;y,10+36*0); };
				LoadActor( "_steps info labels" ) .. { Name="StepsInfoIcon2"; InitCommand=cmd(pause;setstate,1;x,StepsPaneScale(-54,-68)+StepsPaneScale(76,86)*1;y,10+36*0); };
				LoadActor( "_steps info labels" ) .. { Name="StepsInfoIcon3"; InitCommand=cmd(pause;setstate,2;x,StepsPaneScale(-54,-68)+StepsPaneScale(76,86)*0;y,10+36*1); };
				LoadActor( "_steps info labels" ) .. { Name="StepsInfoIcon4"; InitCommand=cmd(pause;setstate,3;x,StepsPaneScale(-54,-68)+StepsPaneScale(76,86)*1;y,10+36*1); };
				LoadActor( "_steps info labels" ) .. { Name="StepsInfoIcon5"; InitCommand=cmd(pause;setstate,4;x,StepsPaneScale(-54,-68)+StepsPaneScale(76,86)*0;y,10+36*2); };
				LoadActor( "_steps info labels" ) .. { Name="StepsInfoIcon6"; InitCommand=cmd(pause;setstate,5;x,StepsPaneScale(-54,-68)+StepsPaneScale(76,86)*1;y,10+36*2); };
				
				Def.PaneDisplay {
					MetricsGroup="PaneDisplayEditCourse";
					PlayerNumber="PlayerNumber_P1";
					InitCommand=cmd(playcommand,"Set";x,0;y,0);
					
					SetCommand=function(self) self:SetFromGameState() end;
					CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
					CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
					CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
					CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
					SortOrderChangedMessageCommand=cmd(playcommand,"Set");
				};
				
			};
		};



		--[[
		Def.ActorFrame { 
			OnCommand=cmd(zoom,0.5;sleep,0.3;linear,0.3;zoom,1.0);			
			LoadActor("_bar difficulty") .. { 
				InitCommand=cmd();
				OnCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1);
				OffCommand=cmd();
				StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0);
			};

			LoadActor( THEME:GetPathG("","_StepsType icon single") ) .. {
				InitCommand=cmd(x,-128;y,2;playcommand,"Refresh";);
				OnCommand=cmd();
				OnCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1);
				OffCommand=cmd();
				StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0);
				RefreshCommand=function(self)
					local song = GAMESTATE:GetCurrentSong();
					local playable = false;
					if song and SongUtil.IsStepsTypePlayable(song,"StepsType_Pump_Single") then
						playable = true;
					end
					self:diffusealpha( playable and 1 or 0.2 );
				end;
				CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh";);
				PlayerJoinedMessageCommand=cmd(playcommand,"Refresh";);
			};
		
			LoadActor( "difficulties" ) .. {
				InitCommand=cmd(x,-130);
				OnCommand=cmd();
				OffCommand=cmd();
				StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0);
			};
			
			LoadActor( THEME:GetPathG("","_StepsType icon double") ) .. {
				InitCommand=cmd(x,52;y,2;playcommand,"Refresh";visible,GameMode() ~= "multi");
				OnCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1);
				OffCommand=cmd();
				StartSelectingStepsMessageCommand=cmd(linear,0.5;diffusealpha,0;);
				RefreshCommand=function(self)
					local song = GAMESTATE:GetCurrentSong();
					local playable = false;
					if song and SongUtil.IsStepsTypePlayable(song,"StepsType_Pump_Double") then
						playable = true;
					end
					self:diffusealpha( playable and 1 or 0.2 );
				end;
				CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh";);
				PlayerJoinedMessageCommand=cmd(playcommand,"Refresh";);
			};
		};
		]]



	};
};
