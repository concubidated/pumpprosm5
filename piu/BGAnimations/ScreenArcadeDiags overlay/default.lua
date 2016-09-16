if not Diags then
	return LoadFont("_venacti 26px bold diffuse") .. {
		Text = "No diags";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;shadowlength,0);
	};
end

local fYSpacing = 18;
local fXSpacing = 275;
function LocationGenerator(XPos, YPos)
	function f()
		RetX = XPos
		RetY = YPos
		YPos = YPos + 1
		RetX = (XPos * fXSpacing) + (SCREEN_CENTER_X-150)
		RetY = (YPos * fYSpacing) + (SCREEN_CENTER_Y-165)
		return RetX, RetY
	end
	return f
end
local t = Def.ActorFrame { };

local ethernet = Def.ActorFrame { Name = "Ethernet"; };
local modem = Def.ActorFrame { Name = "Modem"; };
t[#t+1] = ethernet;
t[#t+1] = modem;


local PosGen = LocationGenerator(0, 8)

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Connection:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "ethernet_link"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "IP address:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Name = "IP"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "Netmask:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Name = "Netmask"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "DNS server:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Name = "DNSServer"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "Router IP:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Name = "Router"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "DHCP server:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Name = "DHCPServer"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "MAC address:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Name = "MAC"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "Link TX:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 26px bold monospace numbers") .. { Name = "ethernet_traffic_tx"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

local fX, fY = PosGen()
ethernet[#ethernet+1] = LoadFont("_venacti 15px bold") .. { Text = "Link RX:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
ethernet[#ethernet+1] = LoadFont("_venacti 26px bold monospace numbers") .. { Name = "ethernet_traffic_rx"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

PosGen() -- separator

if false then

local PosGen = LocationGenerator(1, 8)
local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "GSM modem:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_found"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "SIM card:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_simcard_state"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Service:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_service"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Network:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_network"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Signal quality:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_signal"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Cell TX:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 26px bold monospace numbers") .. { Name = "modem_traffic_tx"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Cell RX:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 26px bold monospace numbers") .. { Name = "modem_traffic_rx"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Mode:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_network_mode"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Device:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_hardware_id"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Firmware:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_firmware"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "IMSI:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "modem_imsi"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };
end

local PosGen = LocationGenerator(0, 0)
local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Serial:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. {
	InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;playcommand,"Set";);
	SetCommand=function(self)
			local s = GetSerialNumber and GetSerialNumber() or "(no serial)";
			self:settext( s );
		end
};

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Revision:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;settext,"r"..GetRevision();); }; 

if GameMode() == "multi" then
	-- This label was renamed from "Wireless pad receiver" in 1.0, to avoid confusion
	-- with the other wireless information on this screen.
	local fX, fY = PosGen()
	t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Dance pad receiver:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
	t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "WirelessReceiver"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

        local fX, fY = PosGen()
	t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Licensed pads:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
	t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "Pads"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };
end

if false then
local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Uploader:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "Network"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };
end

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Diagnostics:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 15px bold") .. { Name = "Diagnostics"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "CPU type:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. { Name = "cpu_info"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "GPU:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. { Name = "gpu"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Memory:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. { Name = "mem_info"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

local fX, fY = PosGen()
t[#t+1] = LoadFont("_venacti 15px bold") .. { Text = "Motherboard:"; InitCommand=cmd(x,fX;y,fY;halign,1;shadowlength,0); };
t[#t+1] = LoadFont("_venacti 26px bold diffuse") .. { Name = "motherboard"; InitCommand=cmd(x,fX+10;y,fY;halign,0;shadowlength,0;zoom,0.6); };

PosGen() -- separator

local default_if_empty = function(s, default)
	if s == nil or s == "" then
		return default
	else
		return s
	end
end

local c;
local function Update(self)
	local linked_device = Helpers.ReadStateFile("dhcp-connected-device");
	if linked_device == "" then
		linked_device = nil
	end
	if linked_device == "eth0" then
		c.ethernet_link:settext( "Ethernet link" );
	elseif linked_device == "usb0" then
		c.ethernet_link:settext( "USB link" );
	else
		c.ethernet_link:settext( "No link" );
	end

if false then
	local modem_found = Helpers.ReadStateFile("diags-modem-found") == "1";
	if modem_found then
		-- If the PPP device is actually online, say "online".  Otherwise, say "detected".
		if Diags.GetIPAddress("ppp0") then
			c.modem_found:settext( "online" );
		else
			c.modem_found:settext( "detected" );
		end
	else
		c.modem_found:settext( "not detected" );
	end

	local modem_hardware_id = Helpers.ReadStateFile("diags-modem-hardware-id");
	c.modem_hardware_id:settext( modem_hardware_id );

	local modem_firmware = Helpers.ReadStateFile("diags-modem-firmware-version");
	c.modem_firmware:settext( modem_firmware );

	local modem_simcard_state = Helpers.ReadStateFile("diags-modem-sim");
	if modem_simcard_state == "invalid/locked SIM" then
		-- The card reports "invalid" when it's actually just initializing the card.  Don't
		-- show it as "invalid".
		c.modem_simcard_state:settext( "initializing" );

	else
		c.modem_simcard_state:settext( modem_simcard_state );
	end

	local modem_network_mode = Helpers.ReadStateFile("diags-modem-network-mode");
	c.modem_network_mode:settext( modem_network_mode );

	local modem_service = Helpers.ReadStateFile("diags-modem-service");
	c.modem_service:settext( modem_service );

	local modem_network = Helpers.ReadStateFile("diags-modem-network");
	local modem_network_state = Helpers.ReadStateFile("diags-modem-network-state");
	if modem_network_state == "registered" then
		c.modem_network:settext( modem_network );
	elseif modem_network_state == "roaming" then
		c.modem_network:settext( modem_network_state .. " (" .. modem_network .. ")" );
	else
		c.modem_network:settext( modem_network_state );
	end

	local modem_imsi = Helpers.ReadStateFile("diags-modem-imsi")
	c.modem_imsi:settext( modem_imsi );

	local modem_signal = Helpers.ReadStateFile("diags-modem-signal-strength")
	modem_signal = tonumber(modem_signal)
	local strength = "";
	if modem_signal ~= nil then
		if modem_signal <= -95 then strength = "poor";
		elseif modem_signal <= -85 then strength = "average";
		elseif modem_signal <= -75 then strength = "good";
		else strength = "strong";
		end
		c.modem_signal:settext( modem_signal .. " dBm (" .. strength .. ")" );
	else
		c.modem_signal:settext( "" );
	end

	c.modem_traffic_tx:settext( default_if_empty(Helpers.ReadStateFile("diags-modem-bytes-up"), "") );
	c.modem_traffic_rx:settext( default_if_empty(Helpers.ReadStateFile("diags-modem-bytes-down"), "") );
end

	-- Group the uncommon errors together; these generally only happen during testing.
	local errors = "";
	if not Diags.NetworkInterfaceExists("eth0") then
		errors = errors .. "eth0-missing ";
	end

	local missing_modules = Helpers.ReadStateFile("diags-missing-modules");
	if missing_modules ~= "" then
		errors = errors .. "modules:" .. missing_modules .. "; ";
	end

	local memory_bytes = tonumber(Helpers.ReadStateFile("info-memory"));
	if memory_bytes and memory_bytes < 512*1024*1024 then
		errors = errors .. "insufficient-memory; "
	end

	local hdd_read_errors = Helpers.ReadStateFile("ata-eh-count");
	if hdd_read_errors ~= "" then
		errors = errors .. "hdd-errors (" .. hdd_read_errors ..")"
	end

	c.Diagnostics:settext(default_if_empty(errors, "none"))
	if linked_device then
		ethernet.IP:settext( default_if_empty(Diags.GetIPAddress(linked_device), "none") );
	else
		ethernet.IP:settext( "none" );
	end
	ethernet.Netmask:settext( default_if_empty(Helpers.ReadStateFile("dhcp-status-netmask"), "none") );
	ethernet.Router:settext( default_if_empty(Helpers.ReadStateFile("dhcp-status-routers"), "none") );
	ethernet.DHCPServer:settext( default_if_empty(Helpers.ReadStateFile("dhcp-status-server"), "none") );
	ethernet.DNSServer:settext( default_if_empty(Helpers.ReadStateFile("dhcp-status-nameservers"), "none") );
	ethernet.MAC:settext( default_if_empty(Diags.GetHardwareAddress(), "none") );

	-- These won't go away automatically when the network goes does.  Only show them if we have
	-- a link, so they show and hide like the other fields in this section.
	if linked_device then
		path = "/sys/class/net/" .. linked_device .. "/statistics/"
		ethernet.ethernet_traffic_tx:settext( default_if_empty(Helpers.ReadFile(path .. "tx_bytes"), "") );
		ethernet.ethernet_traffic_rx:settext( default_if_empty(Helpers.ReadFile(path .. "rx_bytes"), "") );
	else
		ethernet.ethernet_traffic_tx:settext( "" );
		ethernet.ethernet_traffic_rx:settext( "" );
	end

	if c.Network then
		local s = Diags.GetUploaderNetworkStatus();
		local strings = {
			down = "inactive",
			unreachable = "Server unreachable",
			online = "Checking...",
			dns_failed="DNS error",
			auth_failed="Authentication error",
			unknown="Unknown error",
			failed="System error",
			success="Online",
		}
		local status = Diags.GetUploaderNetworkStatus()
		c.Network:settext( strings[status] or "Unknown" );
	end

	if c.cpu_info and Helpers.GetCPUInfo then
		local Model, Family = Helpers.GetCPUInfo();
		if Model == nil then
			c.cpu_info:settext( "(unknown)" );
		else
			c.cpu_info:settext( string.format("%i/%i", Family, Model) );
		end
	end

	if c.gpu and Helpers.GetGPU then
		local GPU = Helpers.GetGPU() or "(unknown)";
		c.gpu:settext( GPU );
	end

	if c.mem_info then
		local memory_desc = Helpers.ReadStateFile("info-memory-desc");
		c.mem_info:settext( memory_desc );
	end

	if c.motherboard then
		local sMotherboard = Helpers.ReadFile("/sys/devices/virtual/dmi/id/board_name");
		c.motherboard:settext( sMotherboard );
	end

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
	ethernet = c.Ethernet:GetChildren();
	modem = c.Modem:GetChildren();
	self:SetUpdateFunction( Update );
end

return t;
