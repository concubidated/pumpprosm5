local CREDITS_PRESS_START = THEME:GetString("ScreenSystemLayer","CreditsPressStart");
local CREDITS_INSERT_CARD = THEME:GetString("ScreenSystemLayer","CreditsInsertCard");
local CREDITS_CARD_TOO_LATE = THEME:GetString("ScreenSystemLayer","CreditsCardTooLate");
local CREDITS_CARD_NO_NAME = THEME:GetString("ScreenSystemLayer","CreditsCardNoName");
local CREDITS_CARD_READY = THEME:GetString("ScreenSystemLayer","CreditsCardReady");
local CREDITS_CARD_CHECKING = THEME:GetString("ScreenSystemLayer","CreditsCardChecking");
local CREDITS_CARD_REMOVED = THEME:GetString("ScreenSystemLayer","CreditsCardRemoved");
local CREDITS_FREE_PLAY = THEME:GetString("ScreenSystemLayer","CreditsFreePlay");
local CREDITS_CREDITS = THEME:GetString("ScreenSystemLayer","CreditsCredits");
local CREDITS_INSERT_COIN = THEME:GetString("ScreenSystemLayer","CreditsInsertCoin");
local CREDITS_PLEASE_WAIT = THEME:GetString("ScreenSystemLayer","CreditsPleaseWait");
local CREDITS_MAX = THEME:GetString("ScreenSystemLayer","CreditsMax");
local CREDITS_NOT_PRESENT = THEME:GetString("ScreenSystemLayer","CreditsNotPresent");
local CREDITS_LOAD_FAILED = THEME:GetString("ScreenSystemLayer","CreditsLoadFailed");
local CREDITS_LOADED_FROM_LAST_GOOD_APPEND = THEME:GetString("ScreenSystemLayer","CreditsLoadedFromLastGoodAppend");

function GetCreditsMessage(pn)
	local bJoinOnly = THEME:GetMetric("ScreenSystemLayer", "CreditsJoinOnly");
	if bJoinOnly and GAMESTATE:PlayersCanJoin() then
		return "";
	end

	local bShowMemoryCardMessage;
	local Screen = SCREENMAN:GetTopScreen();
	if Screen and Screen:GetScreenType() == "ScreenType_SystemMenu" then
		bShowMemoryCardMessage = false;
	elseif MEMCARDMAN:GetCardLocked(pn) then
		bShowMemoryCardMessage = GAMESTATE:IsPlayerEnabled(pn);
	else
		bShowMemoryCardMessage = GAMESTATE:IsSideJoined(pn);
	end
	if bShowMemoryCardMessage then
		local mcs = MEMCARDMAN:GetCardState(pn);
		local profile = PROFILEMAN:GetProfile(pn);
		if mcs == "MemoryCardState_NoCard" then
			-- this is a local machine profile
			if PROFILEMAN:LastLoadWasFromLastGood(pn) then
				return profile:GetDisplayNameOrHighScoreName() .. CREDITS_LOADED_FROM_LAST_GOOD_APPEND;
			elseif PROFILEMAN:LastLoadWasTamperedOrCorrupt(pn) then
				return CREDITS_LOAD_FAILED.GetValue();
			-- Prefer the name of the profile over the name of the card.
			elseif PROFILEMAN:IsPersistentProfile(pn) then
				return profile:GetDisplayNameOrHighScoreName();
			elseif GAMESTATE:PlayersCanJoin() then
				return CREDITS_INSERT_CARD;
			else
				return "PLAYER " .. (pn == PLAYER_1 and "1" or "2")
			end
		elseif mcs == "MemoryCardState_Error" then
			return THEME:GetString( "ScreenSystemLayer", "CreditsCard" .. MEMCARDMAN:GetCardError(pn) );
		elseif mcs == "MemoryCardState_TooLate" then return CREDITS_CARD_TOO_LATE;
		elseif mcs == "MemoryCardState_Checking" then return CREDITS_CARD_CHECKING;
		elseif mcs == "MemoryCardState_Removed" then return CREDITS_CARD_REMOVED;
		elseif mcs == "MemoryCardState_Ready" then
			-- If the profile failed to load and there was no usable backup...
			if PROFILEMAN:LastLoadWasTamperedOrCorrupt(pn) and not PROFILEMAN:LastLoadWasFromLastGood(pn) then
				return CREDITS_LOAD_FAILED;
			end

			-- If there is a local profile loaded, prefer it over the name of the memory card.
			if PROFILEMAN:IsPersistentProfile(pn) then
				local s = profile:GetDisplayNameOrHighScoreName();
				if s == "" then
					s = CREDITS_CARD_NO_NAME;
				end
				if PROFILEMAN:LastLoadWasFromLastGood(pn) then
					s = s .. CREDITS_LOADED_FROM_LAST_GOOD_APPEND;
				end
				return s;
			elseif not MEMCARDMAN:IsNameAvailable(pn) then
				return CREDITS_CARD_READY;
			elseif MEMCARDMAN:GetName(pn) ~= "" then
				return MEMCARDMAN:GetName(pn);
			else
				return CREDITS_CARD_NO_NAME;
			end
		end
	else
		-- bShowCreditsMessage
		local CoinMode = GAMESTATE:GetCoinMode();
		if CoinMode == "CoinMode_Home" then
			if GAMESTATE:PlayersCanJoin() then
				return CREDITS_PRESS_START;
			else
				return CREDITS_NOT_PRESENT;
			end

		elseif CoinMode == "CoinMode_Pay" then
			local CoinsPerCredit = PREFSMAN:GetPreference("CoinsPerCredit");
			local iCredits = GAMESTATE:GetCoins() / CoinsPerCredit;
			local iCoins = GAMESTATE:GetCoins() % CoinsPerCredit;
			local sCredits = "";

			if GAMESTATE:PlayersCanJoin() then
				if GAMESTATE:EnoughCreditsToJoin() then
					sCredits = CREDITS_PRESS_START;
				else
					sCredits = CREDITS_INSERT_COIN;
				end
			else
				sCredits = CREDITS_PLEASE_WAIT;
			end	
			
			-- Hide the credit count when it's zero.  "INSERT COIN" takes more space
			-- than "[] TO JOIN", so this reduces the maximum length.
			if iCredits >= 1 or CoinsPerCredit == 1 then
				sCredits = sCredits .. string.format("  %d", iCredits);
			end
			if iCredits >= 20 then
				sCredits = sCredits .. "  " .. CREDITS_MAX;
			elseif CoinsPerCredit > 1 then
				sCredits = sCredits .. string.format("  %d/%d", iCoins, CoinsPerCredit );
			end
			return sCredits;
		elseif CoinMode == "CoinMode_Free" then
			if GAMESTATE:PlayersCanJoin() then
				return CREDITS_PRESS_START;
			else
				return CREDITS_NOT_PRESENT;
			end
		end
		
	end
end
