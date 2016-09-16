if not MK6 then
	return LoadFont("_venacti 26px bold diffuse") .. {
		Text = "No MK6";
	--	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+204;shadowlength,0;zoom,0.75);
	};
end

local function MakePanelMarkers(center)
	local xOffset = {
		0,
		-14, 14,
		0
	};
	local yOffset = {
		-11,
		0, 0,
		11
	};
	if center then
		xOffset = {
			0,
			-12, 12,
			0
		};
		yOffset = {
			-12,
			0, 0,
			12
		};
	end

	local t = Def.ActorFrame { };

	local Names = {
		"Up",
		"Left", "Right",
		"Down"
	};
	for sensor = 1,4 do
		local SensorFrame = Def.ActorFrame {
			Name = tostring(sensor);
			InitCommand = function(self)
				self.Index = Names[sensor];
				self.HasBeenPressed = false;
			end;
			ShowCommand = function(self, params)
				local PartToShow;
				if params.State == "None" then
					PartToShow = "None"
				elseif params.State == "Active" then
					PartToShow = "Active"
					self.HasBeenPressed = true;
				elseif self.HasBeenPressed then
					PartToShow = "Pressed"
				else
					PartToShow = "Unpressed"
				end

				self:playcommand("ShowPart", {Part = PartToShow})
			end;
		};
		t[#t+1] = SensorFrame

		function MakeMarker(Part)
			return LoadActor("marker " .. Part) .. {
				InitCommand = function(self)
					local x = xOffset[sensor];
					self:x(x);

					local y = yOffset[sensor];
					self:y(y);
				end;
				ShowPartCommand = function(self, params)
					self:visible(params.Part == Part)
				end
			}
		end
		SensorFrame[#SensorFrame+1] = MakeMarker("Pressed");
		SensorFrame[#SensorFrame+1] = MakeMarker("Unpressed");
		SensorFrame[#SensorFrame+1] = MakeMarker("Active");
	end;
	return t;
end;


local t = Def.ActorFrame { };
t[#t+1] = LoadActor("pad") .. { InitCommand=cmd(x,-60); };
t[#t+1] = LoadActor("pad") .. { InitCommand=cmd(x,60); };

local xOffset = {
	-26, 26,
	0,
	-26, 26
};
local yOffset = {
	-23, -23,
	0,
	23, 23
};

for panel = 1,10 do
	t[#t+1] = MakePanelMarkers(panel == 3 or panel == 8) .. {
		Name = tostring(panel);
		InitCommand = function(self)
			self.Index = panel;

			local x = 60;
			if panel <= 5 then x = -x; end
			local idx = (panel-1)%5 + 1;
			x = x + xOffset[idx];
			self:x(x);

			local y = 0;
			y = y + yOffset[idx];
			self:y(y);
		end;
	};
end

local sensors = {};
local function Update(self)
	local t = MK6.GetInputs();
	local Jump = MK6.GetType() == "MK6Mode_Jump"

	local Sensors = { "Right", "Left", "Down", "Up" };
	for panel = 1,10 do
		for sensor = 1,4 do
			local s = Sensors[sensor];
			local visible = t[panel][sensor]
			local State
			if Jump and (Sensors[sensor] ~= "Left" and Sensors[sensor] ~= "Right") then
				State = "None"
			elseif t[panel][sensor] then
				State = "Active"
			else
				State = "Inactive"
			end
			sensors[panel][s]:playcommand("Show", {State = State})
		end
	end
end

t.InitCommand = function(self)
	local c = self:GetChildren();
	-- For each arrow:
	for PanelName, PanelActor in pairs(c) do
		if PanelActor.Index then
			-- For each sensor in the arrow:
			local SensorActors = PanelActor:GetChildren();
			sensors[PanelActor.Index] = {};
			for SensorName, SensorActor in pairs(SensorActors) do
				sensors[PanelActor.Index][SensorActor.Index] = SensorActor;
			end
		end
	end
	self:SetUpdateFunction( Update );
end;

return t;
