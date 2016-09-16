return Def.ActorFrame {
	LoadActor( THEME:GetPathB('ScreenOptionsSimple','overlay') );
	Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X+136;y,SCREEN_CENTER_Y);
		LoadActor( "frame" ) .. {
			InitCommand=cmd(x,10;y,0);
		};
		LoadFont("common normal") .. {
			OnCommand=cmd(halign,0;x,-154+10;y,-148+10;zoom,0.7;skewx,-0.1;shadowlength,2);
			EditPlaylistSongGenreChangedMessageCommand=function(self)
					local s = GetEditPlaylistSelectedSongGenre()
					if s ~= '' then s = s..':' end
					self:settext(s)
				end;
		};
		LoadFont("common normal") .. {
			OnCommand=cmd(halign,0;valign,0;x,-154+20+2;y,-130+20-4;zoom,0.5;wrapwidthpixels,600;shadowlength,2;maxwidth,292;playcommand,"WorkoutChanged");
			EditPlaylistSongGenreChangedMessageCommand=cmd(settext,GetEditPlaylistSelectedSongGenreText(0,15));
		};
		LoadFont("common normal") .. {
			OnCommand=cmd(halign,0;valign,0;x,0+20-3;y,-130+20-4;zoom,0.5;wrapwidthpixels,600;shadowlength,2;maxwidth,292;playcommand,"WorkoutChanged");
			EditPlaylistSongGenreChangedMessageCommand=cmd(settext,GetEditPlaylistSelectedSongGenreText(1,15));
		};
		LoadFont("common normal") .. {
			InitCommand=cmd(settext,ScreenString('Playlist:'));
			OnCommand=cmd(halign,0;valign,0;x,-154+10;y,122+6;zoom,0.7;skewx,-0.1;shadowlength,2);
		};
		LoadFont("common normal") .. {
			OnCommand=cmd(halign,1;valign,0;x,154;y,122+6;zoom,0.7;shadowlength,2;playcommand,"WorkoutChanged");
			WorkoutChangedMessageCommand=cmd(settext,WORKOUTMAN:GetWorkoutSongsOverview());
		};
	};
};
