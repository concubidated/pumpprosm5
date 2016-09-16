function ScreenTitleBranch()
	-- Don't show the title menu (says "Press Start") if there are 0 credits
	-- and inserted and CoinMode is pay.
	if GAMESTATE:GetCoinsNeededToJoin() > GAMESTATE:GetCoins() and GAMESTATE:GetNumSidesJoined() == 0 then
		return THEME:GetMetric( "Common", "InitialScreen" )
	end

	if GameMode() == "multi" then return "ScreenTitleMenu" end
	if GAMESTATE:GetCoinMode() == "CoinMode_Home" then return "ScreenTitleMenu" end
	return "ScreenTitleJoin"
end

function GetTitleNextScreenOption() -- for going into regular gameplay
	if GameMode() == "arcade" then
		return "Normal";
	end
	if GameMode() == "multi" then
		return "MultiRegular";
	end
	error();
end

function GetEvaluationNextScreen()
	if( GAMESTATE:GetMultiplayer() ) then return "ScreenSelectMusicMultiplayer" end

	local sNextScreen = "ScreenProfileLoad";
	local sEndScreen = "ScreenEnterName";

	if GAMESTATE:IsEventMode() then
		Trace( "IsEventMode" )
		return sNextScreen
	end

	if not GAMESTATE:IsCourseMode() and GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() > 0 then
		Trace( "Another" )
		return sNextScreen
	end

	Trace( "End" )
	return sEndScreen
end


local AllPlayersFailedLastSong = false;

function GetGameplayNextScreen()
	-- Remember whether all players failed for use later on in SelectEndingScreen.  We
	-- need to do this here, because when we get to SelectEndingScreen players have already
	-- been unjoined and AllFailed() always returns true.
	AllPlayersFailedLastSong = STATSMAN:GetCurStageStats():AllFailed();

	Trace( "GetGameplayNextScreen: " )
	Trace( " Passed = "..tostring(Passed) )
	Trace( " IsCourseMode = "..tostring(GAMESTATE:IsCourseMode()) )
	Trace( " Event mode = "..tostring(IsEventMode()) )
	
	-- "x == false", not "not x", so we default to true if the preference doesn't exist (nil).
	if PREFSMAN:GetPreference("EnableScoring") == false then return GetEvaluationNextScreen() end

	local pm = GAMESTATE:GetPlayMode()
	if( GAMESTATE:GetMultiplayer() ) then return "ScreenEvaluationMultiplayer" end
	if( pm == "PlayMode_Regular" )  then return "ScreenEvaluationRegular" end
	if( pm == "PlayMode_Nonstop" )  then return "ScreenEvaluationRegular" end
	if( pm == "PlayMode_Oni" )  then return "ScreenEvaluationRegular" end
	assert( false, pm );
end

function GetGameplayPrevScreen()
	if IsPlayingWorkout() then return "ScreenOptionsCourseOverview" end
	return "ScreenSelectMusic"
end

function SelectEndingScreen()
	-- This is set by GetGameplayNextScreen().
	if AllPlayersFailedLastSong then
		return "ScreenGameOver"
	end

	if GAMESTATE:Env().EarnedEnding2 or GAMESTATE:Env().ForceEnding2 then 
		return "ScreenEnding2" 
	end
	return "ScreenEnding1"
end

function ScreenProfileSaveNextScreen()
	return "ScreenContinue"
end

function GetScreenContinueNextScreen()
	if GAMESTATE:GetNumPlayersEnabled() == 0 then
		return SelectEndingScreen();
	end

	if STATSMAN:GetStagesPlayed() == 0 then
		return "ScreenSelectPlayMode";
	end

	return "ScreenProfileLoad";
end

function ScreenOptionsManageGroupsNextScreen()
	return "ScreenSelectNumNoteFields"
end

function GetScreenSelectNumNoteFieldsNextScreen()
	if IsPlayingWorkout() then return "ScreenStage" end
	return "ScreenSelectMusicMultiplayer"
end

function GetScreenSelectNumNoteFieldsPrevScreen()
	if IsPlayingWorkout() then return "ScreenOptionsCourseOverview" end
	return ScreenTitleBranch();
end

function GetGameplayScreen()
	if IsPlayingWorkout() then return "ScreenGameplayMultiplayerWorkout" end
	if GAMESTATE:GetMultiplayer() then return "ScreenGameplayMultiplayer" end
	local st = GAMESTATE:GetCurrentStyle():GetStyleType()
	if st == "StyleType_TwoPlayersSharedSides" then return "ScreenGameplayShared" end
	return "ScreenGameplay"
end
