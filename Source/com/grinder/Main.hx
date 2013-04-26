package com.grinder;

import com.grinder.service.InputService;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.grinder.world.GameWorld;

// TODO Add pushWorld, which will create a world stack. Then you could popWorld() to return to the previous world.
// TODO Add world transitions: fade out, fade in, crossfade, etc.

class Main extends Engine
{
	private var progress:Int = 1;

	public function new()
	{
		super(800, 450);
	}

	override public function init()
	{
		#if debug
		#if flash
			if (flash.system.Capabilities.isDebugger)
		#end
				HXP.console.enable();
		#end

		// #if (flash9 || flash10)
		// 	haxe.Log.trace = function(v,?pos) { untyped __global__["trace"](pos.className+"#"+pos.methodName+"("+pos.lineNumber+"):",v); }
		// #elseif flash
		// 	haxe.Log.trace = function(v,?pos) { flash.Lib.trace(pos.className+"#"+pos.methodName+"("+pos.lineNumber+"): "+v); }
		// #end

		InputService.init();
		nextWorld();
	}

	public function nextWorld()
	{
		switch(++progress)
		{
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