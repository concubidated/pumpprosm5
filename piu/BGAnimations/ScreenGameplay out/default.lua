local t = Def.ActorFrame {
	StartTransitioningClearedCommand = function(self) SetTransitioningFrom("Cleared"); end;
	StartTransitioningFailedCommand = function(self) SetTransitioningFrom("Failed"); end;
};

if GAMESTATE:IsDemonstration() then
	t[#t+1] = Def.ActorFrame {
		Def.Quad {
			InitCommand=cmd(stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM;diffuse,color(#000000);diffusealpha,1);
			OnCommand=cmd(sleep,1.5;diffusealpha,0);
		};
	};
else
	t[#t+1] = LoadActor(THEME:GetPathG("", "_cleared")) .. {
		InitCommand=cmd(visible,false;);
		StartTransitioningClearedCommand = cmd(sleep,AnyHumanPlayerHasAFullCombo() and 3 or 0;queuecommand,"TweenOn");
		TweenOnCommand = cmd(visible,true);
	};

	t[#t+1] = Def.Actor {
		-- HACK: After a sleep,0 above, Transition will receive
		-- an update where GetTweenTimeLeft is 0, and send the
		-- transition-finished message, since tween time doesn't
		-- include time for commands that havn't been executed
		-- yet.  Sleep briefly.
		StartTransitioningClearedCommand=cmd(sleep,0.1);
	};
	t[#t+1] = LoadActor(THEME:GetPathG("", "_failed")) .. {
		StartTransitioningFailedCommand = cmd(visible,true;playcommand,"TweenOn");
		StartTransitioningClearedCommand = cmd(visible,false);
	};
end

t[#t+1] = Def.Actor {
	StartTransitioningCommand=function(self)
		DispenseTicketsForStage();
	end;
};

return t;
