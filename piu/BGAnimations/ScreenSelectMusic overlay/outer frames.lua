local t = Def.ActorFrame {
};

t[#t+1] = LoadActor( "frame bottom inner" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1);
		OnCommand=cmd(addy,190;decelerate,.5;addy,-190);
		StartSelectingStepsMessageCommand=cmd(finishtweening;accelerate,0.5;addy,100;);

};
t[#t+1] = LoadActor( "bottomslide" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OnCommand=function(self)
				self:x(SCREEN_CENTER_X);
				self:y(SCREEN_BOTTOM);
				self:addy(90);
				self:valign(1);
				if GAMESTATE:Env()["BottomSlideIsVisible"]  ~= "1" then
					self:decelerate(.5)
				end;
				self:y(SCREEN_BOTTOM);
			end;
};
t[#t+1] = LoadActor( "bottomlaser" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OnCommand=function(self)
				self:x(SCREEN_CENTER_X);
				self:y(SCREEN_BOTTOM);
				self:diffusealpha(1);
				self:valign(1);
				if GAMESTATE:Env()["BottomSlideIsVisible"]  ~= "1" then
					self:diffusealpha(0)
					self:sleep(.5)
					self:decelerate(.2)
				end;
				self:diffusealpha(1)
			end;
};
	
t[#t+1] = LoadActor( THEME:GetPathB("","_shared underlay") ) .. { 
}
return t;
