package com.grinder.component;

class Equipment
{
	public static inline var WEAPON:String = "weapon";
	public static inline var ARMOR:String = "armor";

	public var type:String;

	public function new(type:String)
	{
		this.type = type;
	}
}