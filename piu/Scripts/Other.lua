OtherPlayer = { [PLAYER_1]=PLAYER_2, [PLAYER_2]=PLAYER_1 };

-- This transforms both the judgement and the combo.  Don't move them
-- separately here, or we'll throw off the pulsing animation.
function JudgmentTransformCommand( self, params )
	local y = -16;
	if params.bReverse then
		y = y + 30;
	end;

	if params.bCentered then
		if params.bReverse then
			y = y - 130
		else
			y = y + 130
		end
	end
	
	self:y( y )
end

function SetGameplayMods()
	if GAMESTATE:IsCourseMode() then
		GAMESTATE:ApplyGameCommand( "stagemod,FailImmediate" );

		if not IsGauntlet() then
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				GAMESTATE:ApplyStageModifiers(pn, "overhead");
			end
		end
	else
		if IsRoutine() then
			GAMESTATE:ApplyGameCommand( "stagemod,FailOff" );
		else
			GAMESTATE:ApplyGameCommand( "stagemod,FailEndOfSong" );
		end

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			-- Force C110 for Beginner steps.  In Routine (where all steps are Medium), force
			-- C110 for 1-3 meter songs.
			local steps = GAMESTATE:GetCurrentSteps(pn);
			local ForceCMod = false;
			if steps:GetDifficulty() == "Difficulty_Beginner" then ForceCMod = true; end
			if IsRoutine() and steps:GetMeter() < 4 then ForceCMod = true; end
			if ForceCMod then
				GAMESTATE:ApplyGameCommand( "stagemod,C110", pn );
			end
		end
	end
end

function BeginScreenEvaluation()
	-- Store whether any player has earned the good ending.  We have to do this here, since
	-- by the time we get to SelectEndingScreen we've unjoined players and don't have this
	-- information anymore.
	local grade = STATSMAN:GetBestFinalGrade()
	GAMESTATE:Env().EarnedEnding2 = Grade:Compare( grade, "Grade_Tier03" ) < 0;
end

function GetScoreKeeperClass()
	local st = GAMESTATE:GetCurrentStyle():GetStyleType()
	if st == "StyleType_TwoPlayersSharedSides" then
		return "ScoreKeeperShared"
	else
		return "ScoreKeeperNormal"
	end
end

function IsRoutine()
	return GAMESTATE:GetCurrentStyle() and GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersSharedSides";
end

function IsGauntlet()
	return GAMESTATE:GetPlayMode() == "PlayMode_Oni";
end

function SingleLifeMeter()
	local style = GAMESTATE:GetCurrentStyle();
	return style and (style:GetStyleType() == "StyleType_OnePlayerTwoSides" or style:GetStyleType() == "StyleType_TwoPlayersSharedSides");
end


function GetPlayerType()
	if IsGauntlet() then
		return "PlayerGauntlet"
	end
	if IsRoutine() then
		return "PlayerShared"
	end

	return "Player"
end

function WideScale(AR4_3, AR16_10) return scale( SCREEN_WIDTH, 640, 852, AR4_3, AR16_10 ); end
function StepsPaneScale(side_of_panes_cut_off, sides_of_panes_not_cut_off) return scale( math.min(SCREEN_WIDTH,700), 640, 700, side_of_panes_cut_off, sides_of_panes_not_cut_off ); end

function TextBannerSetTitle(self, params)
	if params.Song then
		self:settext( params.Song:GetDisplayFullTitle() );
	end
	self:diffuse(color("#802626"));
end

function GameMode()
	return "arcade";
end

function SetPlayingWorkout()
	GAMESTATE:Env().Workout = 1;
end

function IsPlayingWorkout()
	return GAMESTATE:Env().Workout == 1
end

function Set3NoteFields()
	GAMESTATE:SetNumMultiplayerNoteFields(3);
end

function Set2NoteFields()
	GAMESTATE:SetNumMultiplayerNoteFields(2);
end

function Set1NoteField()
	GAMESTATE:SetNumMultiplayerNoteFields(1);
end

function GetPlayerX( player_index )
	if GAMESTATE:GetNumMultiplayerNoteFields() == 1 then
		return SCREEN_CENTER_X;
	elseif GAMESTATE:GetNumMultiplayerNoteFields() == 2 then
		return SCREEN_CENTER_X + scale(player_index,0,1,-1,1) * (105*SCREEN_WIDTH/640);
	else
		return SCREEN_CENTER_X + scale(player_index,0,2,-1,1) * (190*SCREEN_WIDTH/640);
	end
end

function GetPlayerDividerX( player_index )
	assert( player_index < GAMESTATE:GetNumMultiplayerNoteFields() );
	return (GetPlayerX(player_index) + GetPlayerX(player_index + 1)) / 2;
end

function GetPlayerZoom( player_index )
	local zoom = 0.85;
	if GAMESTATE:GetNumMultiplayerNoteFields() == 3 then
		zoom = 0.7 * SCREEN_WIDTH/640;
	elseif GAMESTATE:GetNumMultiplayerNoteFields() == 2 then
		zoom = 0.8 * SCREEN_WIDTH/640;
	end
	return zoom;
end

function ShowTitleIcons()
	return true
end

function ShowDifficultyBadge()
	return false
end

function ShowPremiumBadge()
	return true
end

function ShowUnlocksBadge()
	return true
end


function FormatPercentScore2( percent )
	return string.format("%0.2f",percent*100);
end

function SetRandomSong()
	local t = {
		"Pump It Up Pro 2/Cowgirl",
		"Pump It Up Pro 2/In The Night",
		"Pump It Up Pro 2/Oh Oh Oh Sexy Vampire",
		"Pump It Up Pro 2/Rave Until The Night Is Over",
	};
	
	local s = SONGMAN:FindSong( t[ math.random(1,#t) ] )
	GAMESTATE:SetPreferredSong( s )
	Trace( tostring(s) );
end



function GetMultiplayerItemPositionInfo( itemIndex, numItems )
	local numColumns
	if numItems > 16 then numColumns = 4 else numColumns = 2 end
	local maxItemsPerCol = math.ceil( numItems/numColumns )
	local minItemsPerCol = math.floor( numItems/numColumns )
	local remainder = math.mod( numItems, numColumns )

	local numItemsInCol = 0
	local colIndex = 0
	local itemIndexInCol = 0
	local curItem = 0
	for i = 0,numColumns-1 do
		if i < remainder then numItemsInCol = maxItemsPerCol else numItemsInCol = minItemsPerCol end
		--Trace( 'itemIndex ' .. itemIndex .. '  curItem ' .. curItem .. '  numItemsInCol ' .. numItemsInCol );
		if itemIndex >= curItem and itemIndex < curItem+numItemsInCol then
			itemIndexInCol = itemIndex - curItem
			colIndex = i
			break
		end
		curItem = curItem + numItemsInCol
	end

	local half
	if colIndex < numColumns/2 then half = -1 else half = 1 end

	local shift = 0
	if numColumns >= 4 then 
		shift = math.mod(colIndex,2)*2-1	   -- -1 or +1
	end
	
	return numColumns, maxItemsPerCol, minItemsPerCol, remainder, numItemsInCol, colIndex, itemIndexInCol, half, shift
end

function MultiplayerItemPositionJoined( self, itemIndex, numItems, xSpacing, ySpacing, halfSpacing )

	local numColumns, maxItemsPerCol, minItemsPerCol, remainder, numItemsInCol, colIndex, itemIndexInCol, half, shift = GetMultiplayerItemPositionInfo( itemIndex, numItems )

	local x = math.floor( half*halfSpacing + shift*xSpacing/2 )
	local y = math.floor( (itemIndexInCol-(numItemsInCol-1)/2)*ySpacing + (shift*half*-1)*5 )

	self:stoptweening();
	if self:GetZoom() == 0 then
		self:x( x )
		self:y( y )
	end
	self:linear( 0.2 )
	self:x( x )
	self:y( y )
	self:zoom( 1 )
	self:playcommand( 'BeginReposition' )
	self:playcommand( 'SetColor' )
	if half == -1 then self:playcommand('LeftHalf') else self:playcommand('RightHalf') end
	if numItems > 16 then self:playcommand('Small') else self:playcommand('Large') end

	xSpacing = nil
	ySpacing = nil
end

function ScreenGameplayMultiplayerItemPositionJoined( self, itemIndex, numItems )
	local xSpacing = 50
	local ySpacing = 35
	local halfSpacing = 260
	MultiplayerItemPositionJoined( self, itemIndex, numItems, xSpacing, ySpacing, halfSpacing )
end

function ScreenSelectMusicMultiplayerItemPositionJoined( self, itemIndex, numItems )
	local xSpacing = 50
	local ySpacing = 35
	local halfSpacing = 226
	MultiplayerItemPositionJoined( self, itemIndex, numItems, xSpacing, ySpacing, halfSpacing )
end

function ScreenEvaluationMultiplayerItemPositionJoined( self, itemIndex, numItems )
	local xSpacing = 150
	local ySpacing = 34
	local halfSpacing = 160
	MultiplayerItemPositionJoined( self, itemIndex, numItems, xSpacing, ySpacing, halfSpacing )
end

-- used to make the correct transition play coming out of gameplay
local transitioning_from = nil;
function GetTransitioningFrom()
	--Warn( "IsTransitioningFromCleared " .. (transitioning_from_cleared and "true" or "false") );
	Trace(string.format("GetTransitioningFrom() = %s", tostring(transitioning_from)));
	return transitioning_from;
end
function SetTransitioningFrom(str)
	Trace(string.format("SetTransitioningFrom(%s)", tostring(str)));
	transitioning_from = str;
end

function ShowGoodCleared()
	local stats = STATSMAN:GetCurStageStats();
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local grade = stats:GetPlayerStageStats(pn):GetGrade();
		if grade == "Grade_Tier01" or grade == "Grade_Tier02" then
			return true;
		end
	end
	return false;
end

function Shuffle(t)
	for x=1,#t do
		local idx = math.random(x,#t);
		local swap = t[x];
		t[x] = t[idx];
		t[idx] = swap;
	end
end;

function PlayerHasAFullCombo(pn)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
	local tns = pss:GetLargestFullComboTapNoteScore();
	return tns;
end;

function AnyHumanPlayerHasAFullCombo()
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		if PlayerHasAFullCombo(pn) then return true; end;
	end
	return false;
end;

function EveryHumanPlayerHasAFullCombo()
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		if not PlayerHasAFullCombo(pn) then return false; end;
	end
	return true;
end

function TimerSecondsFader(actor,order)
	local rotation = math.random(-3000,3000)/100
	if SCREENMAN:GetTopScreen():GetChild("MenuTimer"):GetSeconds() < order then
		actor:accelerate(1)
		actor:diffusealpha(0)
		actor:zoom(.7)
		actor:rotationz(rotation)
	end
	if SCREENMAN:GetTopScreen():GetChild("MenuTimer"):GetSeconds() > order then
		actor:stoptweening()
		actor:diffusealpha(1)
	end
end
	
function ForceEnding2()
	local Path = THEME:GetPathS( "ScreenTitleMenu", "ForceEnding2" )
	SOUND:PlayOnce( Path )
	GAMESTATE:Env().ForceEnding2 = true;
	MESSAGEMAN:Broadcast( "ForceEnding2" )
end		
		
if not Helpers then
	Helpers = {
		IsSlowGPU=function() return false end;
		ReadStateFile=function() return "" end;
	};
end

function GetRoutineNoteSkin(pn)
	if Helpers.IsSlowGPU() then
		if pn == PLAYER_1 then
			return "2DRoutineP1"
		else
			return "2DRoutineP2"
		end
	else
		if pn == PLAYER_1 then
			return "RoutineP1"
		else
			return "RoutineP2"
		end
	end
end

function GetDefaultNoteSkin()
	if Helpers.IsSlowGPU() then
		return "rhythm"
	else
		return "3drhythm"
	end
end

function GetNoteSkinsToHide()
	if Helpers.IsSlowGPU() then
		return "default,routinep1,routinep2,3drhythm,3drhythm2,3dclassic,2droutinep1,2droutinep2"
	else
		return "default,routinep1,routinep2,rhythm,3drhythm2,classic,2droutinep1,2droutinep2"
	end
end
	
local LastSeenPlayerProfileLoadCount = { [PLAYER_1]=0, [PLAYER_2]=0 };

-- Return true if a new player profile has been loaded for the specified
-- player since the last call.
function IsNewPlayerProfileLoaded(pn)
	if not GAMESTATE:IsHumanPlayer(pn) then return false end
	if not PROFILEMAN:IsPersistentProfile(pn) then return false end
	if PROFILEMAN:LastLoadWasTamperedOrCorrupt(pn) then return false end

	local Count = PROFILEMAN:GetTimesPlayerProfileLoaded(pn);
	Trace("IsNewPlayerProfileLoaded(" .. pn .. "): " .. tostring(Count) .. ", " .. tostring(LastSeenPlayerProfileLoadCount[pn]));
	if Count == LastSeenPlayerProfileLoadCount[pn] then
		return false
	end
	LastSeenPlayerProfileLoadCount[pn] = Count
	return true
end

-- If the description is of the form abc_def, then the second part
-- is the steps author.  This mirrors the logic in StepsDisplay::SetInternal.
Steps.GetDescriptionOrig = Steps.GetDescription
function Steps:GetDescription()
	if self:GetDifficulty() ~= "Difficulty_Edit" then
		-- This isn't an edit.  Return the localized difficulty instead.
		local cd = StepsOrTrailToCustomDifficulty(self);
		return CustomDifficultyToLocalizedString( cd );
	end

	local sDesc = self:GetDescriptionOrig();
	sDesc = string.gsub(sDesc, "_.*", "")
	return sDesc;
end

function Steps:GetCredit()
	local sDesc = self:GetDescriptionOrig();
	sDesc = string.gsub(sDesc, ".*_", "")
	return sDesc;
end

function Trail:GetCredit()
	return self:GetDescription()
end

-- Trail:GetDescription mirrors Steps:GetDescription for non-edits: return
-- the localized difficulty.
function Trail:GetDescription()
	local cd = StepsOrTrailToCustomDifficulty(self);
	return CustomDifficultyToLocalizedString( cd );
end

