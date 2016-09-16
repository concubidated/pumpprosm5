-- sleep for a tiny bit of time so that ScreenStage draws once before the next screen is prepared
return Def.Actor { StartTransitioningCommand=cmd(sleep,0.1;) }
