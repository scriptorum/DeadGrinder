
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.ObjectMap;

import com.haxepunk.HXP;

enum ProfileType { opener; closer; dual; }

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

	public var system:System; // Required if using bookends (opener + closer)
	public var profile:Profile; // If using two ProfileSystems as bookends, pass this to the second ProfileSystem (the closer)
	public var type:ProfileType; // Use dual if profiling time between calls (just one ProfileSystem)

	public function new(system:System = null, profile:Profile = null)
	{
		super();
		this.system = system;

		if(profile == null)
		{
			this.profile = new Profile();
			type = (system == null ? ProfileType.dual : ProfileType.opener);

			if(stats == null)
				stats = new ObjectMap<Profile,String>();

			if(!stats.exists(this.profile))
			{
				var name = (system == null ? "Total" : Type.getClassName(Type.getClass(system)));
				stats.set(this.profile, name);
			}
		}
		else 
		{
			this.profile = profile;
			type = ProfileType.closer;
		}
	}

	override public function update(_)
	{	
		switch(type)
		{
			case ProfileType.dual:
			if(profile.startTime >= 0)
				closeProfile();
			openProfile();

			case ProfileType.opener: // opening profile
			openProfile();

			case ProfileType.closer: // closing profile
			closeProfile();
		}
	}

	private function openProfile(): Void
	{
		profile.startTime = nme.Lib.getTimer();
	}

	private function closeProfile(): Void
	{
		if(profile.startTime < 0)
			return; // Profile not opened yet

		var endTime = nme.Lib.getTimer();
		profile.totalTime += (endTime - profile.startTime);
		profile.totalCalls++;
		profile.startTime = -1;
	}

	public static function dump()
	{
		for(profile in stats.keys())
		{
			trace(stats.get(profile) + ": " + 
				format(profile.totalTime / 1000) + 
				" sec overall, " + profile.totalCalls + 
				" calls, " + 
				format(profile.totalTime / profile.totalCalls) + 
				"ms/call, " +
				format(profile.totalCalls / profile.totalTime * 1000) +
				" calls/sec");
		}
	}

	public static function format(time:Float): String
	{
		// return cast time;
		return cast HXP.round(time, 2);
	}
}