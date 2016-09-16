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
		Name = "DOMINICK RENZETTI";
		Description = "graphic design";
		Picture = "pic dom";
	},
	{
		Name = "GABRIEL MARCHAN";
		Description = "game content\ncourse design";
		Picture = "pic gabe";
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
		Picture = "pic mark";
	},
	{
		Name = "JASON DREAD";
		Description = "game content";
		Picture = "pic dread";
	},
	{
		Name = "RYAN MCKANNA";
		Description = "graphic design";
		Picture = "pic ryan";
	},
	{
		Name = "SEAN HANSON";
		Description = "game content";
		Picture = "pic sean";
	},
	{
		Name = "NICK PSYHOGIOS";
		Description = "course design";
		Picture = "pic nick";
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

local fScrollSpeed = 45;
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

local PreloadPictures = Def.ActorFrame { InitCommand=cmd(hidden,true); }
for p in ivalues(People) do
	PreloadPictures[#PreloadPictures+1] = LoadActor(p.Picture);
end;
t[#t+1] = PreloadPictures;


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





t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,2.1);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,5.2);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,8.3);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,11.4);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,14.5);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,17.6);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,20.7);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,23.8);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,26.9);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,30);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,33.1);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,36.2);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,39.3);
};
t[#t+1] = LoadActor( "spawn" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;hibernate,42.4);
};


t[#t+1] = Def.Quad{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color('#00000000'));
	OnCommand=cmd(zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;diffusealpha,0;sleep,43.5;linear,3;diffusealpha,1;);
};


t[#t+1] = LoadActor( "../ScreenLogo background/_logo" ) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X-140;y,SCREEN_CENTER_Y+90;zoom,0.45;hibernate,1);
};


t[#t+1] = LoadActor( "thanks" ) .. {
	InitCommand=cmd(zoom,.85;x,SCREEN_CENTER_X-160;y,SCREEN_CENTER_Y-10;addx,-SCREEN_WIDTH;decelerate,0.5;addx,SCREEN_WIDTH;linear,1.5;addx,5;linear,0.5;addx,5;diffusealpha,0);
};

return t;
