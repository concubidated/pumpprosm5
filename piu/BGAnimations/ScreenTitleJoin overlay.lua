return Def.ActorFrame {
	Def.Actor {
		CodeMessageCommand=function(self, params)
			if params.Name == "ForceEnding2" then
				ForceEnding2()
			end
		end;
	};
	LoadActor( THEME:GetPathB("ScreenTitleMenu","overlay") );
	LoadActor( THEME:GetPathB("","_join attract overlay") );
};

