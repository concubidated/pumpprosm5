local BPM = 128;
local BPS = BPM/60;

local function beats( num )
	return num/BPS
end

-- blinks the panel with the given name at the given beat
local function BlinkPanel( name, beat )
	local x_pos = THEME:GetMetric( "ScreenHowToPlay", "Panel" .. name .. "X" )
	local y_pos = THEME:GetMetric( "ScreenHowToPlay", "Panel" .. name .. "Y" )

	return LoadActor( THEME:GetPathG("ScreenHowToPlay","lit_panel_"..name:lower() ) ) .. {
		InitCommand=cmd(x,x_pos;y,y_pos;blend,"BlendMode_Normal";glowblink;effectperiod,0.1);
		OnCommand=cmd(diffusealpha,0;sleep,beats(beat);diffusealpha,1;sleep,beats(2);diffusealpha,0);
	};
end


return Def.ActorFrame {
	LoadActor( THEME:GetPathB("ScreenAttract","underlay") );

	LoadActor("floor") .. { 
		InitCommand=cmd(valign,1;x,SCREEN_CENTER_X-160;y,SCREEN_BOTTOM); 
	};

	BlinkPanel( "UpLeft", 4*4 );
	BlinkPanel( "UpLeft", 4*8 );
	BlinkPanel( "DownLeft", 4*10 );
	BlinkPanel( "UpLeft", 4*12 );
	BlinkPanel( "Center", 4*12+2 );
	BlinkPanel( "UpRight", 4*13 );
};