-- Example usage:
--
-- local pieces = {
-- 	LoadActor("Actor 1") .. { Name = "P1" };
-- 	LoadActor("Actor 2") .. { Name = "P2" };
-- 	LoadActor("Actor 3") .. { Name = "P3" };
-- };
-- local tween = {
-- 	{ Label = "Start" };
-- 	{ Delay=0.3 },			-- wait 0.3s before continuing
-- 	{ Interval=0.2 },		-- 0.2s between each
-- 	{ Name="P1", alpha=0 };		-- fade to 0
-- 	{ Name="P2", alpha=0.1 };	-- fade to 0.1
-- 	{ Name="P3", alpha=0.2 };	-- fade to 0.2
-- };
-- LoadActor("sequential tween", pieces) .. {
-- 	OnCommand=cmd(RunTween, tween);
-- };
-- 
-- The actual tweening is a bit special-cased for the cleared/failed animation.
-- I'll generalize it as needed.

local actors, max_tweens = ...

local function MakeTweenHelpers(max_tweens)
	if max_tweens == nil then max_tweens = 50 end

	local tween_helpers = Def.ActorFrame {
		Name = "TweenHelpers";
	};
	for i=1,max_tweens do
		tween_helpers[#tween_helpers+1] = Def.Actor { Name=i; };
	end

	return tween_helpers;
end

local function RunTween(self, Tween)
	local TweenHelpers = self:GetChild("TweenHelpers")
	local frame = self:GetChild("TweeningActors")

	local sleep = 0
	local interval = 0
	local DelayLabels = {}
	local NextTweenHelper = 1;
	for t in ivalues(Tween) do
		if t.Interval then interval = t.Interval end

		if t.Label then
			DelayLabels[t.Label] = sleep;
		end
		if t.Goto then
			sleep = DelayLabels[t.Goto];
			assert(sleep ~= nil, t.Label);
		end
		if t.Delay then
			sleep = sleep + t.Delay
		end
		if t.Name then
			local tween = TweenHelpers:GetChild(NextTweenHelper);
			assert(tween ~= nil);
			NextTweenHelper = NextTweenHelper + 1;

			local hex = frame:GetChild(t.Name);
			local TweenFunction = t.Tween;
			tween:addcommand("Run", function() TweenFunction(hex) end);

			tween:sleep(sleep);
			tween:queuecommand("Run");

			sleep = sleep+interval
		end
	end
end

local t = Def.ActorFrame {
	MakeTweenHelpers(max_tweens);

	InitCommand = function(self)
		self.actors = self:GetChild("TweeningActors");
		self.RunTween = RunTween;
	end;
};
local TweeningActors = Def.ActorFrame {
	Name = "TweeningActors";
};
for a in ivalues(actors) do
	TweeningActors[#TweeningActors+1] = a;
end
t[#t+1] = TweeningActors;
return t;

