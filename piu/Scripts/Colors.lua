GameCustomDifficultyColors = {
	Easy		= color("#04fe04"), -- green
	Normal		= color("#fefb04"), -- yellow
	Hard		= color("#fe7704"), -- orange
	Crazy		= color("#fe0a04"), -- red
	HalfDouble	= color("#b04aff"), -- purple
	Freestyle	= color("#ff2998"), -- pink
	Nightmare	= color("#04c6fe"), -- blue
	Routine		= color("#04feba"), -- cyan
	Progressive	= color("#30f0c8"), -- teal
	Gauntlet	= color("#C34AFF"), -- purple
};

function PlayerColor( pn )
	if pn == PLAYER_1 then return color("#fefb04") end	-- orange
	if pn == PLAYER_2 then return color("#10fe04") end	-- green
	return color("1,1,1,1")
end

function MultiPlayerColor( mp )
	local index = MultiPlayer:Reverse()[mp];
	index = math.mod( index, 8 )
	if index == 0 then return color("#FF8080") end
	if index == 1 then return color("#80AAFF") end
	if index == 2 then return color("#80FF80") end
	if index == 3 then return color("#FFFF80") end
	if index == 4 then return color("#B080FF") end
	if index == 5 then return color("#80FFE3") end
	if index == 6 then return color("#FFBF00") end
	if index == 7 then return color("#FF80B6") end
	return color("#FFFFFF")
end

-- (c) 2005 Chris Danford
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

