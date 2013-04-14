package com.grinder.component;

class Sound
{
	public static var MOAN = {  };

	public var type:String;
	public var volume:Int;

	public function new(type:String, volume:Int = 100)
	{
		this.type = type;
		this.volume = volume;
	}
}