local c;
local pn = Var "Player";
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local ShowMissComboAt = THEME:GetMetric("Combo", "ShowMissComboAt");
local Pulse = THEME:GetMetric("Combo", "PulseCommand");
local RestZoom = 0.75;

local Number;
local ComboLabel;
local function PositionCombo(self)
	-- We're the NumberFrame.  Position the combo above or below the judgement
	-- based on whether reverse is active.  Don't flip the combo label to the
	-- top.
	local player = self:GetParent():GetParent();

	if player:GetReverse() then
		Number:y(0-52);
		ComboLabel:y(23-52);
	else
		Number:y(0+60);
		ComboLabel:y(23+60);
	end
end

local t = Def.ActorFrame {
	Def.ActorFrame {
		GameplayClearedCommand=function(self)
			local player = self:GetParent():GetParent();
			if player:GetReverse() then
				-- This still puts the full combo text below the
				-- judgement in reverse, not above the combo, to
				-- make sure it's still visible in eg. Centered + Reverse.
				-- The spacing used is optimized for plain Reverse,
				-- and is presentable but not ideal when combined with
				-- other scroll mods.
				self:y(-22);
			else
				self:y(22);
			end
			local tns = PlayerHasAFullCombo(pn);
			if tns then 
				local c1;
				local params = {};
				if tns == "TapNoteScore_W1" then
					params.c1 = color("#FFFFFFFF");
					params.speed = 2;
				elseif tns == "TapNoteScore_W2" then
					params.c1 = color("#1a7fe755");
					params.speed = 1.5;
				elseif tns == "TapNoteScore_W3" then
					params.c1 = color("#5bfe5955");
					params.speed = 1;
				else
					params.c1 = color("#ffff4e55");
					params.speed = 1;
				end
				self:playcommand("SetUpGlow", params);

				-- Tricky: If one player has a full combo, then we play a single explosion
				-- sound on that player's side (playforplayer,pn).  However, if both players
				-- have a full combo, we don't want to do this twice, once for each player's
				-- side.  If we do that, the two sounds won't start at exactly the same time
				-- and sound ugly; it'll also drop stereo.  Instead, if both players have a
				-- full combo, then play the sound once on both speakers with a regular play().
				local Explosion = self:GetChild("Explosion");
				if EveryHumanPlayerHasAFullCombo() then
					if pn == GAMESTATE:GetMasterPlayerNumber() then
						Trace("Playing global full combo explosion");
						Explosion:play();
					end
				else
					Trace("Playing player " .. pn .. " full combo explosion");
					Explosion:playforplayer(pn);
				end
				self:playcommand("DoExplosion");
			end;
		end;
		LoadActor( "explosion" ) .. {
			Name="Explosion";
			SupportPan=true;
		};
		LoadActor( "full combo wave" ) .. {
			InitCommand=cmd(diffusealpha,0;zoomy,1.1;);
			SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
			DoExplosionCommand=cmd(stoptweening;fadetop,0.1;diffusealpha,1;croptop,0.5;cropbottom,0.5;linear,2;diffusealpha,.7;croptop,0;linear,.1;fadebottom,0.1;linear,1.2;cropbottom,1;diffusealpha,0.3;);
		};
		LoadActor( "full combo wave" ) .. {
			InitCommand=cmd(diffusealpha,0;zoomy,1.1;);
			SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
			DoExplosionCommand=cmd(stoptweening;fadebottom,0.1;diffusealpha,1;croptop,0.5;cropbottom,0.5;linear,2;diffusealpha,.7;cropbottom,0;linear,.1;fadetop,0.1;linear,1.2;croptop,1;diffusealpha,0.3;);
		};
		LoadActor( "full combo inner wave" ) .. {
			InitCommand=cmd(diffusealpha,0;zoomy,1.1;);
			DoExplosionCommand=cmd(stoptweening;fadetop,0.1;diffusealpha,1;croptop,0.5;cropbottom,0.5;linear,2;diffusealpha,.7;croptop,0;linear,.1;fadebottom,0.1;linear,1.2;cropbottom,1;diffusealpha,0.3;);
		};
		LoadActor( "full combo inner wave" ) .. {
			InitCommand=cmd(diffusealpha,0;zoomy,1.1;);
			DoExplosionCommand=cmd(stoptweening;fadebottom,0.1;diffusealpha,1;croptop,0.5;cropbottom,0.5;linear,2;diffusealpha,.7;cropbottom,0;linear,.1;fadetop,0.1;linear,1.2;croptop,1;diffusealpha,0.3;);
		};
		LoadActor( "full combo edge" ) .. {
			InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";zoomy,0.5;
				fadeleft,0.1;faderight,0.1);
			SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
			DoExplosionCommand=cmd(stoptweening;accelerate,.1;diffusealpha,1;y,-28;linear,2.0;addy,-564);
		};
		LoadActor( "full combo edge" ) .. {
			InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";zoomy,0.5;
				fadeleft,0.1;faderight,0.1);
			SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
			DoExplosionCommand=cmd(stoptweening;accelerate,.1;diffusealpha,1;y,28;linear,2.0;addy,564);
		};
		Def.ActorFrame {
			InitCommand=cmd(y,80;);
			LoadActor( "full combo beam" ) .. {
				InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";fadeleft,0.25;faderight,0.25;zoomx,1.5;customtexturerect,0,0,2,1;texcoordvelocity,1,0;);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); self:texcoordvelocity(1*params.speed,0); end;
				DoExplosionCommand=cmd(stoptweening;diffusealpha,0;linear,0.5;diffusealpha,0.5;);
			};
			LoadActor( "full combo beam" ) .. {
				InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";fadeleft,0.25;faderight,0.25;zoomx,-1.5;customtexturerect,0.5,0,2.5,1;texcoordvelocity,-0.9,0;);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); self:texcoordvelocity(-0.9*params.speed,0); end;
				DoExplosionCommand=cmd(stoptweening;diffusealpha,0;linear,0.5;diffusealpha,0.5;);
			};
			LoadActor( "full combo beam" ) .. {
				InitCommand=cmd(zoomy,-1;diffusealpha,0;blend,"BlendMode_Add";fadeleft,0.25;faderight,0.25;zoomx,1.5;customtexturerect,0,0,2.5,1;texcoordvelocity,-0.2,0;);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); self:texcoordvelocity(-0.2*params.speed,0); end;
				DoExplosionCommand=cmd(stoptweening;diffusealpha,0;linear,0.5;diffusealpha,0.5;);
			};
			LoadActor( "full combo text" ) .. {
				InitCommand=cmd(diffusealpha,0;);
				DoExplosionCommand=cmd(stoptweening;diffusealpha,0;zoom,2;linear,0.5;zoom,1;diffusealpha,1;);
			};
			LoadActor( "full combo glow" ) .. {
				InitCommand=cmd(diffusealpha,0;);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); self:diffusealpha(0); end;
				DoExplosionCommand=cmd(stoptweening;blend,"BlendMode_Add";sleep,1;linear,0.5;diffusealpha,1;linear,0.5;diffusealpha,0.3;);
			};
			LoadActor( "full combo text" ) .. {
				InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
				DoExplosionCommand=cmd(stoptweening;x,0;y,0;diffusealpha,0;sleep,0.5;diffusealpha,1;linear,0.5;addx,-100;addy,-50;diffusealpha,0;);
			};
			LoadActor( "full combo text" ) .. {
				InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
				DoExplosionCommand=cmd(stoptweening;x,0;y,0;diffusealpha,0;sleep,0.5;diffusealpha,1;linear,0.5;addx,100;addy,-50;diffusealpha,0;);
			};
			LoadActor( "full combo text" ) .. {
				InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
				DoExplosionCommand=cmd(stoptweening;x,0;y,0;diffusealpha,0;sleep,0.5;diffusealpha,1;linear,0.5;addx,-100;addy,50;diffusealpha,0;);
			};
			LoadActor( "full combo text" ) .. {
				InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";);
				SetUpGlowCommand=function(self,params) self:diffuse(params.c1); end;
				DoExplosionCommand=cmd(stoptweening;x,0;y,0;diffusealpha,0;sleep,0.5;diffusealpha,1;linear,0.5;addx,100;addy,50;diffusealpha,0;);
			};
		};
	};
	Def.ActorFrame {
		MilestoneSmallCommand=cmd(stoptweening;y,self:GetParent():GetChild("NumberFrame"):GetChild("Number"):GetY()*RestZoom;);
		LoadActor( "large milestone flash" ) .. {
			InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";);
			MilestoneLargeCommand=cmd(stoptweening;diffusealpha,0.7;x,0;linear,1.5;addx,-200;diffusealpha,0;);
		};
		LoadActor( "large milestone flash" ) .. {
			InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";zoomx,-1;);
			MilestoneLargeCommand=cmd(stoptweening;diffusealpha,0.7;x,0;linear,1.5;addx,200;diffusealpha,0;);
		};
	};
	Def.ActorFrame {
		Name="NumberFrame";
		InitCommand=cmd(SetUpdateFunction,PositionCombo);
		LoadFont( "Combo", "numbers" ) .. {
			Name="Number";
			InitCommand=cmd(shadowlength,0;y,-2+32+6;visible,false);
		};
		LoadActor( THEME:GetPathG("","_combo label") ) .. {
			Name="ComboLabel";
			InitCommand=cmd(visible,false);
		};
	};
	Def.ActorFrame {
		MilestoneSmallCommand=cmd(stoptweening;y,self:GetParent():GetChild("NumberFrame"):GetChild("Number"):GetY()*RestZoom;);
		LoadActor( "small milestone flash" ) .. {
			InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";);
			MilestoneSmallCommand=cmd(stoptweening;rotationz,-45;diffusealpha,0.7;zoom,1.2;linear,0.5;diffusealpha,0;rotationz,0;zoom,0.8;);
			MilestoneLargeCommand=cmd(playcommand,"MilestoneSmall";);
		};
		LoadActor( "small milestone flash" ) .. {
			InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add";);
			MilestoneSmallCommand=cmd(stoptweening;rotationz,90;diffusealpha,0.7;zoom,1.2;linear,0.5;diffusealpha,0;rotationz,45;zoom,0.8;);
			MilestoneLargeCommand=cmd(playcommand,"MilestoneSmall";);
		};
	};
};

t.InitCommand = function(self)
	c = self:GetChildren();
	c.Number = c.NumberFrame:GetChild("Number");
	c.Number:visible(false);
	c.ComboLabel = c.NumberFrame:GetChild("ComboLabel");
	c.ComboLabel:visible(false);

	Number = c.Number;
	ComboLabel = c.ComboLabel;
end;

t.OnCommand = function(self)
	-- Set the frame around the number as the Combo actor, so it's
	-- moved by ComboTransformCommand.  Don't set the number itself,
	-- since we want to set an explicit zoom on it, and ComboTransformCommand
	-- will override the whole TweenState.
	local player = self:GetParent();
	--player:SetActorWithComboPosition( c.NumberFrame );
end;

t.ComboCommand=function(self, param)
	local iCombo = param.Misses or param.Combo;
	local iShowComboAt = (param.Misses and param.Misses > 0) and ShowMissComboAt or ShowComboAt;

	if param.Combo then
		c.ComboLabel:diffuse( color("#FFFFFF") );
		c.Number:diffuse( color("#FFFFFF") );
	else
		c.ComboLabel:diffuse( color("#FF2020") );
		c.Number:diffuse( color("#FF2020") );
	end

	c.Number:settext( string.format("%03i", iCombo or 0) );

	c.NumberFrame:stoptweening();
	local CurrentZoom = c.NumberFrame:GetZoomX();
	local DestZoom = 1;
	local PercentToRest = scale( CurrentZoom, RestZoom, DestZoom, 1, 0 );
	local Time = 0.04;

	c.NumberFrame:linear(Time * PercentToRest);
	c.NumberFrame:zoom(DestZoom);
	c.NumberFrame:linear(Time);
	c.NumberFrame:zoom(RestZoom);

	-- Do the above even if we're not going to show the combo, so the
	-- tweening always matches up with the judgement.
	if not iCombo or iCombo < iShowComboAt then
		c.Number:visible(false);
		c.ComboLabel:visible(false);
	else
		c.Number:visible(true);
		c.ComboLabel:visible(true);
	end
	
	if param.FullComboW1 then
		c.Number:glowshift();
		c.Number:effectcolor1(color("#eafbffAA"));
		c.Number:effectcolor2(color("#1a7fe733"));
		c.Number:diffusealpha(1);
		c.Number:effectclock("bgm");
		c.Number:blend("BlendMode_Normal");
	elseif param.FullComboW2 then
		c.Number:glowshift();
		c.Number:effectcolor1(color("#1a7fe755"));
		c.Number:effectcolor2(color("#1a7fe700"));
		c.Number:diffusealpha(1);
		c.Number:effectclock("bgm");
		c.Number:blend("BlendMode_Normal");
	elseif param.FullComboW3 then
		c.Number:glowshift();
		c.Number:effectcolor1(color("#5bfe5955"));
		c.Number:effectcolor2(color("#5bfe5900"));
		c.Number:diffusealpha(1);
		c.Number:effectclock("bgm");
		c.Number:blend("BlendMode_Normal");
	elseif param.FullComboW4 then
		c.Number:glowshift();
		c.Number:effectcolor1(color("#ffff4e55"));
		c.Number:effectcolor2(color("#ffff4e00"));
		c.Number:diffusealpha(1);
		c.Number:effectclock("bgm");
		c.Number:blend("BlendMode_Normal");
	else
		c.Number:stopeffect();
		c.Number:diffusealpha(1);
		c.Number:blend("BlendMode_Normal");
	end

end;
return t;
