package com.grinder;

import com.grinder.InputMan;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.grinder.world.IntroWorld;
import com.grinder.world.GameWorld;

// TODO Add pushWorld, which will create a world stack. Then you could popWorld() to return to the previous world.
// TODO Add world transitions: fade out, fade in, crossfade, etc.

class Main extends Engine
{
	public static inline var FRAME_RATE:Int = 30;
	private var progress:Int = 1;

	public function new()
	{
		super(800, 450, FRAME_RATE, false);
	}

	override public function init()
	{
		#if debug
		#if flash
			if (flash.system.Capabilities.isDebugger)
		#end
				HXP.console.enable();
		#end

		InputMan.init();
		nextWorld();
	}

	public function nextWorld()
	{
		switch(++progress)
		{
			case 1: HXP.world = new IntroWorld();
			case 2: HXP.world = new GameWorld();
			// Change progression here
			default: trace("WTF");
		}
	}

	public static function Main()
	{
		new Main();
	}
}