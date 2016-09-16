if not Diags then
	return LoadFont("_venacti 26px bold diffuse") .. {
		Text = "No diags";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;shadowlength,0);
	};
end

local fYSpacing = 18;
local fXSpacing = 300;
function LocationGenerator()
	local XPos = 0
	local YPos = 0
	function f()
		RetX = XPos
		RetY = YPos
		YPos = YPos + 1
		RetX = (XPos * fXSpacing) + (SCREEN_CENTER_X-150)
		RetY = (YPos * fYSpacing) + (SCREEN_CENTER_Y-166)

		if YPos == 5 then
			XPos = XPos + 1
			YPos = 0
		end
		return RetX, RetY
	end
	return f
end
PosGen = LocationGenerator()

local t = Def.ActorFrame { };
local fX, fY = PosGen()

if GameMode() == "multi" then
	local fX, fY = PosGen()
	t[#t+1] = LoadFont("_venacti 15px bold") .. {
		Text = "Licensed pads:";
		InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0);
	};
	t[#t+1] = LoadFont("_venacti 15px bold") .. {
		Name = "Pads";
		InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0);
	};
end

if GameMode() == "multi" then
	local fX, fY = PosGen()
	t[#t+1] = LoadFont("_venacti 15px bold") .. {
		Text = "Dance pad receiver:";
		InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0);
	};
	t[#t+1] = LoadFont("_venacti 15px bold") .. {
		Name = "WirelessReceiver";
		InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0);
	};
end


local c;
local iPads = 32;
if WirelessLicensing then
	iPads = WirelessLicensing.GetLicensedPads();
end
local function Update(self)
	if c.Pads and WirelessLicensing then
		c.Pads:settext( tostring(WirelessLicensing.GetLicensedPads()) );
	end
	if c.WirelessReceiver and Diags.IsWirelessServerOpen then
		local open = Diags.IsWirelessServerOpen();
		c.WirelessReceiver:settext( open and "Connected" or "Not connected" );
	end
end

t.InitCommand = function(self)
	c = self:GetChildren();
	self:SetUpdateFunction( Update );
end

if GameMode() == "arcade" then
	t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. {
		Text = "Sensors";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+150-54;shadowlength,0;zoom,0.75);
	};
	t[#t+1] = LoadActor("sensors") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+150);
	};
end

if GameMode() == "multi" then
	local cols = 6;
	local rows = 7;
	local fX, fY = PosGen()
	for i = 1,iPads do
		local index = i-1;
		local col = math.mod(index,cols);
		local colOffset = scale( col, 0, cols-1, -(cols-1)/2, (cols-1)/2 );
		local row = math.floor( index/cols );
		local rowOffset = scale( row, 0, rows-1, -(rows-1)/2, (rows-1)/2 )
		local posX = SCREEN_CENTER_X - 18 + colOffset*106;
		local posY = fY + 200 + rowOffset*34;
		if col == 0  or  col == 5 then
			posY = posY-10;
		end;
		local a = Def.WirelessDiagnostics {
			InitCommand=cmd(x,posX+54;y,posY);
			BeginCommand=cmd(SetPad,index);

			InactiveCommand=cmd(hidden,true);
			ActiveCommand=cmd(hidden,false);
			LoadFont("WirelessDiagnostics", "text") .. {
				InitCommand=cmd(shadowlength,0;x,-4);
				BatteryCommand=function(self, params)
					local Text = { [-1] = "I", [0] = "J", "K", "L", "M" };
					self:settext(Text[params.Level]);
				end;
			};
		};

		local Packets = LoadFont("WirelessDiagnostics", "text") .. {
			InitCommand=cmd(settext,"A";shadowlength,0;diffusealpha,1;x,-28);
		};
		Packets.RecentlyLostPacketsCommand = function(self, params)
			Trace(params.Packets)
			if params.Packets < 2 then
				self:settext("A");
			elseif params.Packets < 3 then
				self:settext("B");
			else
				self:settext("C");
			end
		end
		a[#a+1] = Packets;

		t[#t+1] = a;
		local a = Def.ControllerStateDisplay {
			InitCommand=cmd(x,posX;y,posY;LoadMultiPlayer,"ControllerStateDisplay",MultiPlayer[i]);
		};
		t[#t+1] = a;
	end
end

return t;
