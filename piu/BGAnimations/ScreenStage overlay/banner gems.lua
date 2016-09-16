local function MakeGems(pn)
	local flip = (pn == PLAYER_1 and 1 or -1 );
			
	local f = Def.ActorFrame {
		BeginCommand=cmd(playcommand,"Refresh");
		TweenOnCommand=cmd(playcommand,"Refresh");
		TweenOffCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(pn));
			local CurrentSteps = GAMESTATE:GetCurrentSteps(pn);
			local CurrentTrail = GAMESTATE:GetCurrentTrail(pn);
			local Current = GAMESTATE:IsCourseMode() and CurrentTrail or CurrentSteps;
			if not Current then return end

			local GemColor = self:GetChild("GemColor");
			local Meter = self:GetChild("Meter");
			GemColor:diffuse( StepsOrTrailToColor(Current) );
			Meter:settext( tostring(Current:GetMeter()) ); 
		end;
	};

	f[#f+1] = LoadActor( "gradient" ) .. {
		InitCommand=cmd(halign,0;y,-10;zoomx,flip);
		PlayerJoinedMessageCommand=function(self) self:playcommand("Refresh"); end;
		TweenOffCommand=cmd(finishtweening;linear,.4;diffusealpha,0;);
		TweenOnCommand=cmd(diffusealpha,0;finishtweening;sleep,0.3;decelerate,.3;diffusealpha,1;);
	};

	f[#f+1] = LoadActor( "gem color part" ) .. {
		Name="GemColor";
		InitCommand = cmd(zoomx,flip);
		PlayerJoinedMessageCommand=function(self) self:playcommand("Refresh"); end;
	};
		
	f[#f+1] = LoadActor( "gem overlay part" ) .. {
		InitCommand = cmd(zoomx,flip);
		PlayerJoinedMessageCommand=function(self) self:playcommand("Refresh"); end;
	};
		
	f[#f+1] = LoadFont("_venacti shadow 22px") .. {
		Name="Meter";
		InitCommand=cmd(ztest,true;zoom,.85;shadowlength,1;x,-2*flip);
	};

	return f;
end

function MakeText(pn)
	local flip = (pn == PLAYER_1 and 1 or -1 );

	local f = Def.ActorFrame {
		LoadFont("common normal") .. {
			Name="DescriptionLabel";
			InitCommand=cmd(zoom,.6;halign,pn == PLAYER_1 and 0 or 1;
				shadowlength,1;diffuse,color("#FFFFFF");settext,"Steps by:";skewx,-0.1;);
		};
		LoadFont("common normal") .. {
			Name="Description";
			InitCommand=cmd(zoom,.6;halign,pn == PLAYER_1 and 0 or 1;
				y,16;shadowlength,1);
		};

		BeginCommand=cmd(playcommand,"Refresh");
		TweenOnCommand=cmd(playcommand,"Refresh");
		TweenOffCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(pn));
			local CurrentSteps = GAMESTATE:GetCurrentSteps(pn);
			local CurrentTrail = GAMESTATE:GetCurrentTrail(pn);
			local Current = GAMESTATE:IsCourseMode() and CurrentTrail or CurrentSteps;
			if not Current then return end

			local DescriptionLabel = self:GetChild("DescriptionLabel");
			local Description = self:GetChild("Description");
			local sDescription = tostring(Current:GetCredit());

			if sDescription == "steps" then
				DescriptionLabel:visible( false );
				Description:visible( false );
			else

				Description:settext( sDescription );
			end
		end;
	};

	return f;
end


local t = Def.ActorFrame {
};

t[#t+1] = MakeGems(PLAYER_1) .. {
	InitCommand=cmd(x,SCREEN_LEFT + 16;y,SCREEN_BOTTOM-20);
	TweenOnCommand=cmd(finishtweening;addx,-40;decelerate,.3;addx,40;);
	TweenOffCommand=cmd(finishtweening;sleep,0.3;accelerate,.3;addx,-40);
};
t[#t+1] = MakeGems(PLAYER_2) .. {
	InitCommand=cmd(x,SCREEN_RIGHT - 16;y,SCREEN_BOTTOM-20);
	TweenOnCommand=cmd(finishtweening;addx,40;decelerate,.3;addx,-40;);
	TweenOffCommand=cmd(finishtweening;sleep,0.3;accelerate,.3;addx,40);
};

t[#t+1] = Def.ActorFrame {
	BeginCommand=cmd(visible,not GAMESTATE:IsCourseMode(););
	TweenOnCommand=cmd(finishtweening;addy,40;sleep,.3;decelerate,0.3;addy,-40);
	TweenOffCommand=cmd(accelerate,0.5;addy,SCREEN_HEIGHT*3/2);

	MakeText(PLAYER_1) .. {
		InitCommand=cmd(x,SCREEN_LEFT + 38;y,SCREEN_BOTTOM-28);
	};
	MakeText(PLAYER_2) .. {
		InitCommand=cmd(x,SCREEN_RIGHT - 38;y,SCREEN_BOTTOM-28);
	};
};


return t;
