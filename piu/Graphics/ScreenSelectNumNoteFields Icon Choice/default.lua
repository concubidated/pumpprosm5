local index = Var("GameCommand"):GetIndex();
local color_name = ({"blue", "orange", "purple"})[index+1]
local name = Var("GameCommand"):GetText();
local title = THEME:GetString( Var "LoadingScreen", name .. "Title" );
local explanation = THEME:GetString( Var "LoadingScreen", name .. "Explanation" );

-- Items are 0, 1, 2.  Items are centered around 1.  When an item is focused in non-widescreen,
-- shift it toward the center.
local index = Var("GameCommand"):GetIndex();
local offset_from_center_y = WideScale(50 * (index - 1), 0);

return Def.ActorFrame { 
	GainFocusCommand=cmd(stoptweening;linear,0.15;zoom,WideScale(0.9,1.0);draworder,1;playcommand,"Focus");
	LoseFocusCommand=cmd(stoptweening;linear,0.15;zoom,WideScale(0.7,0.8);draworder,0;playcommand,"Focus");
	-- Sort the screen, so the draworder change takes effect, putting the selected item on top.
	FocusCommand=function(self)
		self:GetParent():SortByDrawOrder();
	end;

	Def.ActorFrame { 
		GainFocusCommand=cmd(stoptweening;linear,0.15;addx,-offset_from_center_y);
		LoseFocusCommand=cmd(stoptweening;linear,0.15;x,0);
		OnCommand=cmd(rotationz,45*(index==0 and 1 or -1);bounceend,0.45;rotationz,0;
			runcommandsonleaves,cmd(diffusealpha,0;decelerate,0.25;diffusealpha,1));
		OffCommand=cmd(bouncebegin,0.35;rotationz,45*(index==0 and 1 or -1);
			runcommandsonleaves,cmd(bouncebegin,0.35;diffusealpha,0));
		LoadActor( "pill diffuse " .. color_name ) .. {
			InitCommand=cmd();
			DisabledCommand=cmd(diffuse,color("#222222"););
		};
		LoadActor( "pill glow " .. color_name ) .. {
			InitCommand=cmd(blend,"BlendMode_Add";visible,false;);
			GainFocusCommand=cmd(visible,true;stopeffect;diffuseshift;effectcolor1,color("1,1,1,1");effectcolor2,color("0,0,0,1"););
			LoseFocusCommand=cmd(visible,false);
			DisabledCommand=cmd(diffuse,color("#222222"););
		};
		LoadFont("_regra bold glow 30px") .. {
			InitCommand=cmd(y,-50;settext,title;diffuse,color("#FFFFFF77");shadowlength,0;);
			DisabledCommand=cmd(diffuse,color("#222222"););
		};
		LoadFont("_regra bold 30px") .. {
			InitCommand=cmd(y,-50;settext,title;diffuse,color("#000000");shadowlength,0;);
		};
		LoadFont("_regra bold 30px") .. {
			InitCommand=cmd(y,20;settext,explanation;shadowlength,1;zoom,0.8;wrapwidthpixels,280;vertspacing,-4;);
			DisabledCommand=cmd(diffuse,color("#222222"););
		};
	};
};
