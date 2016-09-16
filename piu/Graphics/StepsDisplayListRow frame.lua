return Def.ActorFrame {
	-- Nest in a sub ActorFrame so that the Set command doesn't conflict with the one loaded from metrics.
	Def.ActorFrame {
		SetCommand=function(self,param)
				local Steps = param.Steps;
				local StepsType;
				if Steps then
					StepsType = Steps:GetStepsType();
				end
				--Trace( StepsType );
				self:GetChild("IconSingle"):visible( StepsType == "StepsType_Pump_Single" );
				self:GetChild("IconHalfdouble"):visible( StepsType == "StepsType_Pump_Halfdouble" );
				self:GetChild("IconDouble"):visible( StepsType == "StepsType_Pump_Double" or StepsType == "StepsType_Pump_Routine" );
			end;
		LoadActor( THEME:GetPathG("","_StepsType icon single") ) .. {
			Name="IconSingle";
			InitCommand=cmd(x,100;y,2;;visible,false);
		};
		LoadActor( THEME:GetPathG("","_StepsType icon halfdouble") ) .. {
			Name="IconHalfdouble";
			InitCommand=cmd(x,100;y,2;visible,false);
		};
		LoadActor( THEME:GetPathG("","_StepsType icon double") ) .. {
			Name="IconDouble";
			InitCommand=cmd(x,100;y,2;visible,false);
		};
		LoadActor( THEME:GetPathG("","_white translucent") ) .. {
			InitCommand=cmd(zoomtowidth,240;y,16;zoomtoheight,1);
		};
	};
};
