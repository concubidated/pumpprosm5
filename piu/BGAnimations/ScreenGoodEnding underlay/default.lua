local function ShuffleArray(t)
	for iIndex1 = 1,#t do
		local iIndex2 = math.random(#t);
		local t1 = t[iIndex1];
		local t2 = t[iIndex2];
		t[iIndex1] = t2;
		t[iIndex2] = t1;
	end;
end

local t = Def.ActorFrame { 
};
t[#t+1] = Def.Quad{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color('#00000066'));
	OnCommand=cmd(zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT);
};
t[#t+1] = LoadActor( "frame" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
	OnCommand=cmd(cropright,.5;cropleft,.5;faderight,.5;fadeleft,.5;sleep,.2;linear,1.5;cropright,-.5;cropleft,-.5;faderight,-.5;fadeleft,-.5;);
	OffCommand=cmd(stoptweening;linear,0.3;cropbottom,1;fadebottom,1;);
};


local People = {
	{
		Name = "GLENN MAYNARD";
		Description = "lead programmer";
		Picture = "pic glenn";
	},
	{
		Name = "CHRIS DANFORD";
		Description = "producer";
		Picture = "pic chris";
	},
	{
		Name = "KRISTINA PROCTOR";
		Description = "content manager";
		Picture = "pic kristina";
	},
	{
		Name = "JASON DREAD";
		Description = "game content";
		Picture = "pic placeholder";
	},
	{
		Name = "NICK PSYHOGIOS";
		Description = "course design";
		Picture = "pic placeholder";
	},
	{
		Name = "GABRIEL MARCHAN";
		Description = "game content\ncourse design";
		Picture = "pic gabe";
	},
	{
		Name = "DOMINICK RENZETTI";
		Description = "graphic design";
		Picture = "pic dom";
	},
	{
		Name = "ERIC HOLNIKER";
		Description = "game content";
		Picture = "pic eric";
	},
	{
		Name = "JASON BOLT";
		Description = "theme\ngraphic design";
		Picture = "pic jason";
	},
	{
		Name = "MARK CANNON";
		Description = "game content\nsoftware development";
		Picture = "pic placeholder";
	},
	{
		Name = "RYAN MCKANNA";
		Description = "graphic design";
		Picture = "pic ryan";
	},
	{
		Name = "SEAN HANSON";
		Description = "game content";
		Picture = "pic placeholder";
	},
	{
		Name = "WESLEY SMITH";
		Description = "game content";
		Picture = "wes pic";
	},
};

for p in ivalues(People) do
	local Path = p.Picture;
	p.Picture = ResolveRelativePath( Path, 1 );
	-- p.Picture2 = ResolveRelativePath( "second " .. Path, 1 );
end

local PeopleShuffled = { };
for p in ivalues(People) do
	PeopleShuffled[#PeopleShuffled+1] = p;
end
-- ShuffleArray( PeopleShuffled );

local fScrollSpeed = 40;
local PictureCredits = Def.DynamicActorScroller {
	NumItemsToDraw = 1;
	TransformFunction = function( self, offset, itemIndex, numItems )
	end;
	InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;setsecondsperitem,fScrollSpeed);
	OnCommand = cmd(scrollwithpadding,1.5,1);

	LoadFunction = function(self, item)
		if not self then
			return #PeopleShuffled;
		end

		local p = PeopleShuffled[item+1]

		local Name = self:GetChild("Name");
		Name:settext(p.Name);

		local Description = self:GetChild("Description");
		Description:settext(p.Description);
		
		local Picture = self:GetChild("Picture");
		Picture:Load( p.Picture );
	end;
};

PictureCredits[#PictureCredits+1] = Def.ActorFrame { 
	LoadActor("picture mask") .. {
		InitCommand=cmd(x,166;zwrite,true;ztest,true;diffuse,color("#FF0000");blend,"BlendMode_NoEffect";zbias,0.25);
	};
	Def.Sprite {
		Name="Picture";
		InitCommand=cmd(x,166;ztest,true;);

		CodeMessageCommand=function(self, params)
			self:hidden(params.Name == "Down");
		end;
	};
	LoadActor("picture frame") .. {
		InitCommand=cmd(x,166;ztest,true;zbias,0.75);
	};
	LoadFont("_avantgarde lt book 26px") .. {
		Name="Name";
		InitCommand=cmd(x,61;y,-15;rotationz,30;shadowlength,0;halign,1;diffuse,color("#ffc900"));
	};
	LoadFont("_avantgarde lt book 26px") .. {
		Name="Description";
		InitCommand=cmd(x,50;y,-4;rotationz,30;zoom,.65;shadowlength,0;halign,1;valign,0;);
	};
};

t[#t+1] = PictureCredits;

local People2 = {
	{ Text="Production Manager"; Color=color("#FF80FF"); Title=true; },
	{ Text="Tina LeBlanc" },

	{ Text="Business Manager"; Color=color("#FF80FF"); Title=true; },
	{ Text="John Cooney" },

	{ Text="Game Content"; Color=color("#FF80FF"); Title=true; },
	{ Text="Kyle Ward" }, -- steps, song graphics, courses, VJ
	{ Text="Jonas Casarino" }, -- steps
	{ Text="Jason Stewart" }, -- steps
	{ Text="Chris Foy" }, -- steps
	{ Text="Blake Lowry" }, -- song graphics
	{ Text="Aja Williams" }, -- song graphics
	{ Text="Matt Ragsdale" }, -- content production -Kyle

	{ Text="Freevolt" },
	{ Text="F2" },
	{ Text="Nexcade" },

	{ Text="Art"; Title=true; },
	{ Text="Heather Dority" },

	{ Text="Music"; Title=true; },
	{ Text="BanYa" },
	{ Text="Yahpp" },
	{ Text="Kyle Ward" },

	{ Text="Additional Programming"; Title=true; },
	{ Text="Steve Checkoway" },

	{ Text="Special Thanks"; Title=true; },
	{ Text="Mark Aanerud" },
	{ Text="Ray Araldi" },
	{ Text="Brenn Bondy" },
	{ Text="June Ha Kim" },
	{ Text="Ryan Monahan" },
	{ Text="Jennifer Putzier" },
};

local Y = 0;
for idx, p in ipairs(People2) do
	if p.Title and idx ~= 1 then Y = Y + 20; end
	p.Y = Y;
	if p.Title then Y = Y + 6; end
end;
Y = nil;

local text_start_padding = 25;
--[[
local TextCredits = Def.DynamicActorScroller {
	NumItemsToDraw = 30;
	TransformFunction = function( self, offset, itemIndex, numItems )
		self:y( offset*26 );
		if People2[itemIndex+1] then
			self:addy( People2[itemIndex+1].Y );
		end
	end;
	InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;setsecondsperitem,30);
	OnCommand = cmd(scrollwithpadding,text_start_padding,15);

	LoadFunction = function(self, item)
		if not self then
			return #People2;
		end

		local p = People2[item+1]
		local Name = self:GetChild("Name");
		Name:settext(p.Text);
		if p.Title then
			Name:diffuse(color("#FFFF80"));
			Name:zoom(1.0);
			Name:x(-134);
			Name:halign(0);
			Name:maxwidth(265);
		else
			Name:diffuse(color("#FFFFFF"));
			Name:zoom(.85);
			Name:x(130);
			Name:halign(1);
		end
	end;

	Def.ActorFrame { 
		LoadFont("_venacti 26px bold diffuse") .. {
			Name="Name";
			InitCommand=cmd(zoom,0.85;ztest,true);
		};
	};
};

t[#t+1] = TextCredits;
]]

local PreloadPictures = Def.ActorFrame { InitCommand=cmd(hidden,true); }
for p in ivalues(People) do
	PreloadPictures[#PreloadPictures+1] = LoadActor(p.Picture);
end;
t[#t+1] = PreloadPictures;


t[#t+1] = LoadActor( "../ScreenLogo background/_logo" ) .. {
	InitCommand=cmd(hibernate,1);
};


t[#t+1] = LoadActor( "thanks" ) .. {
	InitCommand=cmd(zoom,.85;x,SCREEN_CENTER_X-160;y,SCREEN_CENTER_Y-10;addx,-SCREEN_WIDTH;decelerate,0.5;addx,SCREEN_WIDTH;linear,1.5;addx,5;linear,0.5;addx,5;diffusealpha,0);
};

t[#t+1] = LoadActor( "top.png" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0;);
	OnCommand=cmd(addy,-90;decelerate,.5;addy,90);
};
t[#t+1] = LoadActor( "../_shared underlay/top frame" );
t[#t+1] = LoadActor( "../_shared underlay/top shadow" ) .. {
	InitCommand=cmd(valign,0;x,SCREEN_CENTER_X;y,SCREEN_TOP);
	OnCommand=cmd();
	OffCommand=cmd();
};

t[#t+1] = LoadActor( "bottom.png" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OnCommand=cmd(addy,90;decelerate,.5;addy,-90);
};
t[#t+1] = LoadActor( "../_shared underlay/bottom" ) .. {
	InitCommand=cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
	OnCommand=cmd();
	OffCommand=cmd();
};

t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	InitCommand=cmd(shadowlength,0;zoom,.8;x,SCREEN_CENTER_X;y,SCREEN_TOP+12;diffuse,color("#802626");settext,ScreenString("HeaderText"));
	OnCommand=cmd(diffusealpha,0;zoomx,0.5;zoomy,0.8;sleep,0.3;linear,0.3;diffusealpha,1;zoomx,.8);
	OffCommand=cmd(linear,0.3;diffusealpha,0;zoomx,0.5;zoomy,0.7);
};





t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,1.75);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,4.5);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,7.25);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,10);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,12.75);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,15.5);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,18.25);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,21);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,23.75);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,26.5);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,29.25);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,32);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,34.75);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,37.5);
};

return t;
