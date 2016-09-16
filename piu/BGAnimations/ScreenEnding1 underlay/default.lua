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
t[#t+1] = LoadActor( "frame" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
	OnCommand=cmd(croptop,1;fadetop,1;sleep,.2;linear,.8;croptop,-1;fadetop,-1;);
	OffCommand=cmd(stoptweening;linear,0.3;cropbottom,1;fadebottom,1;);
};


local People = {
	{
		Name = "GLENN MAYNARD";
		Description = "Lead Programmer";
		Picture = "pic glenn";
	},
	{
		Name = "CHRIS DANFORD";
		Description = "Producer";
		Picture = "pic chris";
	},
	{
		Name = "KRISTINA PROCTOR";
		Description = "Content\nManager";
		Picture = "pic kristina";
	},
	{
		Name = "JASON DREAD";
		Description = "Game Content";
		Picture = "pic dread";
	},
	{
		Name = "NICK PSYHOGIOS";
		Description = "Course Design";
		Picture = "pic nick";
	},
	{
		Name = "GABRIEL MARCHAN";
		Description = "Game Content\nCourse Design";
		Picture = "pic gabe";
	},
	{
		Name = "DOMINICK RENZETTI";
		Description = "Graphic Design\nGame Content";
		Picture = "pic dom";
	},
	{
		Name = "ERIC HOLNIKER";
		Description = "Game Content";
		Picture = "pic eric";
	},
	{
		Name = "JASON BOLT";
		Description = "Theme\nGraphic Design";
		Picture = "pic jason";
	},
	{
		Name = "MARK CANNON";
		Description = "Game Content\nSoftware Development";
		Picture = "pic mark";
	},
	{
		Name = "RYAN MCKANNA";
		Description = "Graphic Design";
		Picture = "pic ryan";
	},
	{
		Name = "SEAN HANSON";
		Description = "Game Content";
		Picture = "pic sean";
	},
	{
		Name = "WESLEY SMITH";
		Description = "Game Content";
		Picture = "pic wes";
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

local fScrollSpeed = 1250;
local PictureCredits = Def.DynamicActorScroller {
	NumItemsToDraw = 6;
	TransformFunction = function( self, offset, itemIndex, numItems )
		self:y( offset*105 );
	end;
	InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;setsecondsperitem,fScrollSpeed/105);
	OnCommand = cmd(scrollwithpadding,3,3);

	LoadFunction = function(self, item)
		if not self then
			return #PeopleShuffled;
		end

		local p = PeopleShuffled[item+1]

		local Name = self:GetChild("Name");
		Name:settext(p.Name);

		local Description = self:GetChild("Description");
		Description:settext(p.Description);
		if string.find(p.Description, "\n") then
			Description:zoom(0.50);
		else
			Description:zoom(0.62);
		end

		local Picture = self:GetChild("Picture");
		Picture:Load( p.Picture );
		--local Picture2 = self:GetChild("Picture2");
		--Picture2:Load( p.Picture2 );
	end;
};

PictureCredits[#PictureCredits+1] = Def.ActorFrame { 
	LoadActor("picture mask") .. {
		InitCommand=cmd(zwrite,true;ztest,true;diffuse,color("#FF0000");blend,"BlendMode_NoEffect";zbias,0.25);
	};
	Def.Sprite {
		Name="Picture";
		InitCommand=cmd(x,-76;ztest,true;zoom,.7);
--[[	
		CodeMessageCommand=function(self, params)
			self:hidden(params.Name == "Down");
		end;]]
	};
--[[
	Def.Sprite {
		Name="Picture2";
		InitCommand=cmd(x,-145;ztest,true;hidden,true);
		CodeMessageCommand=function(self, params)
			self:hidden(params.Name == "Up");
		end;
	};
]]	LoadActor("picture frame") .. {
		InitCommand=cmd(ztest,true;zbias,0.75);
	};
	LoadFont("_venacti 26px bold diffuse") .. {
		Name="Name";
		InitCommand=cmd(x,40;y,-18;shadowlength,1.5;zoom,0.52;halign,0.5;ztest,true;diffuse,color("#b4e0fd"));
	};
	LoadFont("_venacti 26px bold diffuse") .. {
		Name="Description";
		InitCommand=cmd(x,40;y,11;shadowlength,2;halign,0.5;valign,0.5;ztest,true);
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
	{ Text="Chris Foy" }, -- steps
	{ Text="Blake Lowry" }, -- song graphics
	{ Text="Aja Williams" }, -- song graphics
	{ Text="Matt Ragsdale" }, -- content production -Kyle
	{ Text="Richard Woods" }, -- courses
	{ Text="Bill Shillito" }, -- steps

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
	{ Text="James Franzen" },
	{ Text="Tyler Bacon"; },
	{ Text="Ejvin Schytte"; },
	{ Text="Chevelle Abad"; },
	{ Text="Jim Bennington"; },
	{ Text="Pete Ellison"; },
	{ Text="Adrian Bruno"; },
	{ Text="8otB - Dunellen, NJ"; },
	{ Text="Boardwalk Bowl - Orlando, FL"; },
	{ Text="Big Al's - Vancouver, WA"; },
	{ Text="Power Play - Bellevue, WA"; },

	{ Text=""; Title=true; },
	{ Text=""; Title=true; },
	{ Text="Find us at"; Title=true; },
	{ Text="www.piupro.com" },
};

local Y = 0;
for idx, p in ipairs(People2) do
	if p.Title and idx ~= 1 then Y = Y + 20; end
	p.Y = Y;
	if p.Title then Y = Y + 6; end
end;
Y = nil;

local text_start_padding = 25;

local TextCredits = Def.DynamicActorScroller {
	NumItemsToDraw = 35;
	TransformFunction = function( self, offset, itemIndex, numItems )
		self:y( offset*26 );
		if People2[itemIndex+1] then
			self:addy( People2[itemIndex+1].Y );
		end
	end;
	InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;setsecondsperitem,fScrollSpeed/40);
	OnCommand = cmd(scrollwithpadding,60,80);

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
			Name:maxwidth(265/0.85);
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


local PreloadPictures = Def.ActorFrame { InitCommand=cmd(hidden,true); }
for p in ivalues(People) do
	PreloadPictures[#PreloadPictures+1] = LoadActor(p.Picture);
end;
t[#t+1] = PreloadPictures;



t[#t+1] = LoadActor( "top.png" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0;);
	OnCommand=cmd(addy,-90;decelerate,.5;addy,90);
};
t[#t+1] = LoadActor( "toplaser" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;valign,0;);
	OnCommand=cmd(diffusealpha,0;sleep,.7;linear,.3;diffusealpha,1);
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
t[#t+1] = LoadActor( "bottomlaser" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;valign,1;);
	OnCommand=cmd(diffusealpha,0;sleep,.7;linear,.3;diffusealpha,1);
};
t[#t+1] = LoadActor( "../_shared underlay/bottom" ) .. {
	InitCommand=cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
	OnCommand=cmd();
	OffCommand=cmd();
};

t[#t+1] = LoadActor(THEME:GetPathG("", "_credits text"));

t[#t+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_1;
	InitCommand=cmd(x,SCREEN_CENTER_X-170;y,SCREEN_BOTTOM-12);
};

t[#t+1] = Def.MemoryCardDisplay {
	PlayerNumber = PLAYER_2;
	InitCommand=cmd(x,SCREEN_CENTER_X+170;y,SCREEN_BOTTOM-12);
};

t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
	InitCommand=cmd(shadowlength,0;zoom,.8;x,SCREEN_CENTER_X;y,SCREEN_TOP+12;diffuse,color("#802626");settext,ScreenString("HeaderText"));
	OnCommand=cmd(diffusealpha,0;zoomx,0.5;zoomy,0.8;sleep,0.3;linear,0.3;diffusealpha,1;zoomx,.8);
	OffCommand=cmd(linear,0.3;diffusealpha,0;zoomx,0.5;zoomy,0.7);
};

return t;
