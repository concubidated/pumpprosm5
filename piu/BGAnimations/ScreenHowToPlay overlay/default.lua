local BPM = 128;
local BPS = BPM/60;

-- returns the seconds elapsed in 'num' beats
local function beats(num)
	return num/BPS
end

local t = Def.ActorFrame {};

-- Gameplay overlay: life bar, progress bar
t[#t+1] = LoadActor( THEME:GetPathB("ScreenGameplay","overlay") );

-- Intro overlay
t[#t+1] = Def.ActorFrame {
		LoadActor( THEME:GetPathG("ScreenHowToPlay","intro1") ) .. { 
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;); 
			OnCommand=cmd(addx,-SCREEN_WIDTH*1.5;decelerate,0.5;x,SCREEN_CENTER_X-10;linear,3;addx,20;accelerate,0.5;addx,SCREEN_WIDTH*1.5-10);
		};

		LoadActor( THEME:GetPathG("ScreenHowToPlay","intro2") ) .. { 
			InitCommand=cmd(x,SCREEN_CENTER_X+140;y,SCREEN_CENTER_Y;); 
			OnCommand=cmd(diffusealpha,0;sleep,4.15;diffusealpha,1;sleep,10;linear,0.5;diffusealpha,0;);
		};	
		LoadActor("spawn") .. { 
			InitCommand=cmd(x,SCREEN_CENTER_X+140;y,SCREEN_CENTER_Y;); 
			OnCommand=cmd(hibernate,3.5);
		};

		LoadActor( THEME:GetPathG("ScreenHowToPlay","intro3") ) .. { 
			InitCommand=cmd(x,SCREEN_CENTER_X+140;y,SCREEN_CENTER_Y;); 
			OnCommand=cmd(diffusealpha,0;sleep,15.5;diffusealpha,1;);
		};	
		LoadActor("spawn") .. { 
			InitCommand=cmd(zoomx,-1;x,SCREEN_CENTER_X+140;y,SCREEN_CENTER_Y;); 
			OnCommand=cmd(hibernate,15);
		};
	};

-- Bubble that follows the first arrow
t[#t+1] = LoadActor( THEME:GetPathG("ScreenHowToPlay","focus") ) .. { 
		InitCommand=cmd(x,SCREEN_CENTER_X-210;y,SCREEN_CENTER_Y+4;diffuseblink;zoom,0.85);
		OnCommand=cmd(addy,SCREEN_CENTER_Y+55;sleep,beats(10.6);linear,beats(5.5);addy,-445;sleep,beats(4.5);linear,beats(0.5);diffusealpha,0);
	};

-- "Step!" text when the first arrow hits
t[#t+1] = LoadActor( THEME:GetPathG("ScreenHowToPlay","step") ) .. { 
			InitCommand=cmd(x,SCREEN_CENTER_X-170;y,SCREEN_CENTER_Y-110);
			OnCommand=cmd(diffusealpha,0;sleep,beats(16);diffusealpha,1;sleep,beats(4.5);linear,(0.5);diffusealpha,0);
		};

-- Bubble that follows the second arrow
t[#t+1] = LoadActor( THEME:GetPathG("ScreenHowToPlay","focus") ) .. { 
		InitCommand=cmd(x,SCREEN_CENTER_X-210;y,SCREEN_CENTER_Y+4;diffuseblink;zoom,0.85);
		OnCommand=cmd(addy,SCREEN_CENTER_Y+55;sleep,beats(26.6);linear,beats(5.5);addy,-445;sleep,beats(4.5);linear,beats(0.5);diffusealpha,0);
	};

-- "Wait/Ready/Step" text that follows the second arrow
t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X-170;y,SCREEN_CENTER_Y);
		OnCommand=cmd(addy,SCREEN_CENTER_Y+65;sleep,beats(26.5);linear,beats(5.5);addy,-445);

		LoadActor( THEME:GetPathG("ScreenHowToPlay","wait") ) .. { 
			InitCommand=cmd(halign,0); 
			OnCommand=cmd(diffusealpha,1;sleep,beats(29);decelerate,beats(0.75);diffusealpha,0);
		};	
		LoadActor( THEME:GetPathG("ScreenHowToPlay","ready") ) .. { 
			InitCommand=cmd(halign,0); 
			OnCommand=cmd(diffusealpha,0;sleep,beats(30);diffusealpha,1;sleep,beats(1);decelerate,beats(0.75);diffusealpha,0);
		};	
		LoadActor( THEME:GetPathG("ScreenHowToPlay","step") ) .. { 
			InitCommand=cmd(halign,0); 
			OnCommand=cmd(diffusealpha,0;sleep,beats(32);diffusealpha,1;sleep,beats(2.5);linear,beats(0.5);diffusealpha,0);
		};
	};

-- Global overlay
t[#t+1] = LoadActor( THEME:GetPathB("","_join attract overlay") );

return t;