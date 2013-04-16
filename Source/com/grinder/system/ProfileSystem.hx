
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.ObjectMap;

class Profile
{
	public var startTime:Int = -1;
	public var totalTime:Int = 0;	
	public var totalCalls:Int = 0;
	public function new() {}
}

class ProfileSystem extends System
{
	public static var stats:ObjectMap<Profile,String>;

	public var system:System;
	public var profile:Profile; // pass this to the second ProfileSystem
	public var closer:Bool = false;

	// Pass in the tile size being used, or leave as 1 if CameraFocusNode is using GridPosition instead of Position
	public function new(system:System, profile:Profile = null)
	{
		super();
		this.system = system;

		if(profile == null)
		{
			this.profile = new Profile();
			closer = true;

			if(stats == null)
				stats = new ObjectMap<Profile,String>();

			if(!stats.exists(this.profile))
				stats.set(this.profile, Type.getClassName(Type.getClass(system)));
		}
		else this.profile = profile;
	}

	override public function update(_)
	{		
		switch(closer)
		{
			case false: // opening profile
			profile.startTime = nme.Lib.getTimer();

			case true: // closing profile
			if(profile.startTime < 0)
				return; // Profile not opened yet

			var endTime = nme.Lib.getTimer();
			profile.totalTime += (endTime - profile.startTime);
			profile.totalCalls++;
			profile.startTime = -1;
		}
	}

	public static function dump()
	{
		for(profile in stats.keys())
		{
			trace(stats.get(profile) + ": " + profile.totalTime / 1000 + 
				" overall, " + (profile.totalTime / 1000 / profile.totalCalls) + " per call");
		}
	}
}