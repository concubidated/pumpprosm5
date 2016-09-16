local Icons = Def.ActorScroller {
	SecondsPerItem = 1;
	NumItemsToDraw = 10;
	OnCommand=cmd(x,SCREEN_LEFT+50;y,SCREEN_TOP+40);
	TransformFunction = function( self, offset, itemIndex, numItems )
		self:x(66*itemIndex)
	end;
}


Icons[#Icons+1] = Def.ActorFrame { 
	LoadActor( "badge" ) .. {
		InitCommand=cmd();
	};
	LoadFont("_venacti silver numbers 40px bold") .. {
		InitCommand=cmd(x,2;y,-10;settext,PREFSMAN:GetPreference("SongsPerPlay");shadowlength,0;zoomy,0.7;);
	};
	LoadFont("_venacti 15px silver") .. {
		InitCommand=cmd(y,10;settext,PREFSMAN:GetPreference("SongsPerPlay") > 1 and "ROUNDS" or "ROUND";zoom,0.80;shadowlength,1;maxwidth,126;);
	};
};

if ShowDifficultyBadge() then 
	Icons[#Icons+1] = Def.ActorFrame { 
		InitCommand=cmd(playcommand,"SetFilling");
		SetFillingCommand=function(self)
				for i = 1,5 do
					local bOn = i <= GetLifeDifficulty();
					local barFilling = self:GetChild( "BarFilling" .. i );
					barFilling:visible( bOn );
				end
			end;
		LoadActor( "badge" ) .. {
			InitCommand=cmd();
		};
		LoadActor( "blackbar") .. { InitCommand=cmd(x,-20;valign,1;y,3;zoomtowidth,6;zoomtoheight,10;); };
		LoadActor( "blackbar") .. { InitCommand=cmd(x,-10;valign,1;y,3;zoomtowidth,6;zoomtoheight,14;); };
		LoadActor( "blackbar") .. { InitCommand=cmd(x,0;valign,1;y,3;zoomtowidth,6;zoomtoheight,18;); };
		LoadActor( "blackbar") .. { InitCommand=cmd(x,10;valign,1;y,3;zoomtowidth,6;zoomtoheight,22;); };
		LoadActor( "blackbar") .. { InitCommand=cmd(x,20;valign,1;y,3;zoomtowidth,6;zoomtoheight,26;); };
		LoadActor( "bar") .. { Name="BarFilling1"; InitCommand=cmd(x,-20;valign,1;y,2;zoomtowidth,4;zoomtoheight,8;); }; 
		LoadActor( "bar") .. { Name="BarFilling2"; InitCommand=cmd(x,-10;valign,1;y,2;zoomtowidth,4;zoomtoheight,12;); };
		LoadActor( "bar") .. { Name="BarFilling3"; InitCommand=cmd(x,0;valign,1;y,2;zoomtowidth,4;zoomtoheight,16;); };
		LoadActor( "bar") .. { Name="BarFilling4"; InitCommand=cmd(x,10;valign,1;y,2;zoomtowidth,4;zoomtoheight,20;); };
		LoadActor( "bar") .. { Name="BarFilling5"; InitCommand=cmd(x,20;valign,1;y,2;zoomtowidth,4;zoomtoheight,24;); };
		LoadFont("_venacti 15px silver") .. {
			InitCommand=cmd(y,10;settext,"DIFFICULTY";zoomx,0.6;zoomy,0.65;shadowlength,0;maxwidth,126;);
		};5
	};	
end

if ShowPremiumBadge() and PREFSMAN:GetPreference("Premium") == "Premium_2PlayersFor1Credit" then 
	Icons[#Icons+1] = Def.ActorFrame { 
		LoadActor( "badge" ) .. {
			InitCommand=cmd();
		};
		LoadFont("_venacti silver numbers 40px bold") .. {
			InitCommand=cmd(x,1;y,-10;settext,"x2";shadowlength,1;zoomx,.8;zoomy,0.7;);
		};
		LoadFont("_venacti 15px silver") .. {
			InitCommand=cmd(y,10;settext,"PREMIUM";zoom,0.75;shadowlength,0;maxwidth,126;);
		};
	};
end

if ShowUnlocksBadge()  and  UNLOCKMAN:GetNumUnlocks() > 0 then
	local unlocksT = Def.ActorFrame { 
		LoadActor( "badge" );
		LoadFont("_venacti 15px silver") .. {
			InitCommand=cmd(y,10;zoom,.7;shadowlength,0;settext,"UNLOCKS";maxwidth,126;);
		};
	};
	local function GetShownUnlocks()
		local TotalUnlocks = UNLOCKMAN:GetNumUnlocks();
		local Shown = 0;
		for i = 0,TotalUnlocks-1 do
			if UNLOCKMAN:GetUnlockEntry(i):GetSong() then
				Shown = Shown + 1;
			end
		end
		return Shown
	end
	local ShownUnlocks = GetShownUnlocks();
	local Offset = 0;
	for i = 0,UNLOCKMAN:GetNumUnlocks()-1 do
		local XSpacing = 10;
		local XPos = {
			scale(0, 0, 2, -XSpacing*2/2, XSpacing*2/2),
			scale(1, 0, 2, -XSpacing*2/2, XSpacing*2/2),
			scale(2, 0, 2, -XSpacing*2/2, XSpacing*2/2),
			scale(0, 0, 3, -XSpacing*3/2, XSpacing*3/2),
			scale(1, 0, 3, -XSpacing*3/2, XSpacing*3/2),
			scale(2, 0, 3, -XSpacing*3/2, XSpacing*3/2),
			scale(3, 0, 3, -XSpacing*3/2, XSpacing*3/2),
			scale(0, 0, 2, -XSpacing*2/2, XSpacing*2/2),
			scale(1, 0, 2, -XSpacing*2/2, XSpacing*2/2),
			scale(2, 0, 2, -XSpacing*2/2, XSpacing*2/2),
		};
		local YSpacing = 10;
		local YPos = {
			-YSpacing, -YSpacing, -YSpacing, 0, 0, 0, 0, YSpacing, YSpacing, YSpacing
		};

		if UNLOCKMAN:GetUnlockEntry(i):GetSong() then
			local index = Offset;
			local unlockX = XPos[Offset+1];
			local unlockY = YPos[Offset+1]-10;
			local bLocked = UNLOCKMAN:GetUnlockEntry(index):IsLocked();
			unlocksT[#unlocksT+1] = LoadActor( "unlock icon") .. { InitCommand=cmd(pause;x,unlockX;y,unlockY;setstate,bLocked and 0 or 1) };

			Offset = Offset + 1;
		end
	end
	Icons[#Icons+1] = unlocksT;
end



local t = Def.ActorFrame {
};
if ShowTitleIcons() then
	t[#t+1] = Icons;
end


return t;
