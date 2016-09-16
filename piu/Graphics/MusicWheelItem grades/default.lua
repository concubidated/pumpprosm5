-- This actor is duplicated.  Upvalues will not be duplicated.

local grades = {
	Grade_Tier01 = cmd(hidden,false;setstate,0;glowshift); -- SS
	Grade_Tier02 = cmd(hidden,false;setstate,1;stopeffect); -- S
	Grade_Tier03 = cmd(hidden,false;setstate,2;stopeffect); -- passed
	Grade_Failed = cmd(hidden,false;setstate,3;stopeffect);
	        None = cmd(hidden,false;setstate,4;stopeffect); -- not played
	       Empty = cmd(hidden,true); -- n/a
};

local t = LoadActor( "grades" ) .. {
	InitCommand=cmd(pause;effectclock,"timerglobal");
	SetGradeCommand=function(self, params)
		local c;
		if not params.NumTimesPlayed then
			c = grades["Empty"];
		elseif not params.NumTimesPlayed or params.NumTimesPlayed == 0 then
			c = grades["None"];
		else
			c = grades[params.Grade or "Grade_Failed"] or grades.Grade_Tier03;
		end
		c(self);
	end;
};

return t;

-- (c) 2007 Glenn Maynard
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
