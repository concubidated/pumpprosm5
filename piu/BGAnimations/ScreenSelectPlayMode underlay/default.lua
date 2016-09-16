local PreviousScreen = nil;

return Def.ActorFrame {
	LoadActor( THEME:GetPathB("","_caution underlay") ) .. {
		BeginCommand=function(self)
				PreviousScreen = Var "PreviousScreen";
			end;
		OnCommand=function(self)
				if PreviousScreen ~= "ScreenContinue" then
					self:playcommand("ActualOn");
				end;
			end;
		OffCommand=cmd(playcommand,"ActualOff");
	};
	LoadActor( "header black" ) .. {
		InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0);
		OnCommand=function(self)
				if PreviousScreen == "ScreenContinue" then
					self:addy(-60);
					self:decelerate(.3);
					self:addy(60);
				end;
			end;
		OffCommand = cmd(accelerate,.5;addy,-90);
	};
	LoadActor( THEME:GetPathB("","_shared underlay") ) .. {
	};

	OnCommand=function(self)
		MESSAGEMAN:Broadcast("BackgroundBig");
	end;
	OffCommand=function(self)
		MESSAGEMAN:Broadcast("BackgroundNormal");
	end;
};
