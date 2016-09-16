local t = Def.ActorFrame {
	LoadActor( "../_title" ) .. {
		OnCommand=cmd(play);
	};
	LoadActor("186_JB_HD_purple") .. { 
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT);
	};
	LoadActor("186_JB_HD_purple") .. { 
		-- hack to get move to decode at 2x the normal frame rate
		InitCommand=cmd(diffusealpha,0;);
	};
	Def.ActorFrame { 
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,0.9);
		LoadActor("_hexes") .. {
			InitCommand=cmd(x,-40;y,123);
			OnCommand=cmd(fadeleft,0.5;cropleft,1;sleep,0.5;linear,0.5;cropleft,-0.5);
		};
		Def.ActorFrame { 
			InitCommand=cmd(y,-56);
			LoadActor("_pump it up") .. { 
				OnCommand=cmd(stoptweening;
				diffusealpha,0;
				sleep,0.5;
				linear,0.3;
				diffusealpha,1;);
			};
			LoadActor("pump it up glow") .. { 
				InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;);
				OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1;linear,0.5;diffusealpha,0;);
			};
			LoadActor("pump mask") .. { 
				InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.0);
				OnCommand=cmd(sleep,3;queuecommand,"Shine";);
				ShineCommand=cmd(diffusealpha,0.3;fadeleft,0.1;faderight,0.1;cropleft,-0.2;cropright,1;linear,1;;cropleft,1;cropright,-0.2;sleep,3;queuecommand,"Shine";);
			};
		};
		LoadActor("_pro") .. { 
			InitCommand=cmd(x,-130;y,50);
			OnCommand=cmd(stoptweening;diffusealpha,0;zoomx,1.5;zoomy,0.7;
			sleep,0.55;
			decelerate,0.25;diffusealpha,1;zoom,1);
		};
		LoadActor("_pro") .. { 
			InitCommand=cmd(x,-130;y,50);
			OnCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;queuecommand,"Shine";);
			ShineCommand=cmd(accelerate,2.75;diffusealpha,.3;linear,.25;diffusealpha,0.7;decelerate,.5;diffusealpha,0;sleep,.5;queuecommand,"Shine";);
			ForceEnding2MessageCommand=cmd(stoptweening;diffuse,color("#ffc600");linear,.3;diffusealpha,1;sleep,.25;linear,1;diffusealpha,0);
		};
		Def.ActorFrame { 
			InitCommand=cmd(x,142;y,42);
			LoadActor("_2") .. {
				OnCommand=cmd(diffusealpha,0;sleep,0.8;linear,0.1;diffusealpha,1);
			};
			LoadActor("2 glow") .. {
				InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0;accelerate,0.7;diffusealpha,0.5;linear,0.3;diffusealpha,0);
			};
			LoadActor("2 mask") .. {
				InitCommand=cmd(blend,"BlendMode_Add";diffuse,color("#fff799");diffusealpha,0;);
				OnCommand=cmd(sleep,3;queuecommand,"Shine";);
				ShineCommand=cmd(diffusealpha,0.3;fadetop,0.1;fadebottom,0.1;croptop,-0.2;cropbottom,1;linear,1;;croptop,1;cropbottom,-0.2;sleep,3;queuecommand,"Shine";);
			};
			LoadActor("2 glow") .. { 
				InitCommand=cmd(zoom,1;blend,"BlendMode_Add");
				OnCommand=cmd(
				diffusealpha,0;
				sleep,0.2;
				accelerate,0.4;
				diffusealpha,1;decelerate,1;diffusealpha,0;zoom,1.25);
			};
		};
		LoadActor("_box bl") .. { 
			InitCommand=cmd(x,53;y,131;glowshift;);
			OnCommand=cmd(finishtweening;addx,-20;addy,20;diffusealpha,0;
				sleep,0.8;decelerate,0.3;diffusealpha,1;addx,20;addy,-20);
		};
		LoadActor("_box bottom") .. { 
			InitCommand=cmd(x,98;y,156;glowshift;);
			OnCommand=cmd(finishtweening;addx,20;diffusealpha,0;
				sleep,0.8;decelerate,0.3;diffusealpha,1;addx,-20);
		};
		LoadActor("_box ur") .. { 
			InitCommand=cmd(x,206;y,-23;glowshift;);
			OnCommand=cmd(finishtweening;rotationz,30;diffusealpha,0;
				sleep,0.8;decelerate,0.3;diffusealpha,1;rotationz,0);
		};
x			--LoadActor("mockup") .. { 
		--	InitCommand=cmd(diffusealpha,0.1);
		--};
	};
};

t[#t+1] = LoadFont("Common", "normal") .. {
	InitCommand=cmd(halign,1;valign,0;x,SCREEN_RIGHT-20;y,SCREEN_TOP+16;zoom,0.7;diffuse,color("#A0A0A0");shadowlength,2;playcommand,"SetText";);
	SetTextCommand=function(self)
		local serial = GetSerialNumber and GetSerialNumber() or "XXXXXXXXXXXXX"
		local rev = GetRevision and GetRevision() or 0;
		
		local s = serial .. " r" .. rev .. "\n";
--[[
		s = s .. SONGMAN:GetNumSongs() .. " songs";
		local packs = { "Pump It Up Pro Encore", "Pump It Up Pro School Musical" };
		if AddonManager then 
			packs = AddonManager.GetSongPacks();
		end
			
		for i,v in ipairs(packs) do
			local sPack = THEME:GetString("AddonManager",v);
			s = s .. "\n" .. sPack;
		end
]]
		self:settext( s );
	end;
};

return t;
