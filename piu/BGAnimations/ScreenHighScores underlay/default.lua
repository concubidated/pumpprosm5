local t = Def.ActorFrame {
};

t[#t+1] = LoadActor("frame") .. {
	InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomx,0);
	BeginCommand = cmd(decelerate,.1;zoomx,1;);
};
--[[
t[#t+1] = Def.Quad {
	InitCommand = cmd(valign,0;setsize,852,70;x,SCREEN_CENTER_X;y,SCREEN_TOP;zwrite,true;blend,"BlendMode_NoEffect");
};

t[#t+1] = LoadActor("bottom mask") .. {
	InitCommand = cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM+8;zwrite,true;blend,"BlendMode_NoEffect");
};
]]
return t;
