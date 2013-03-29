package com.grinder.component;

class Collision
{
	public static inline var GENERIC:String = "You can't go that way.";
	public static inline var PERSON:String = "They are in your way.";
	public static inline var SHEER:String = "You walk into a wall.";
	public static inline var CLOSED:String = "You walk into a closed door.";
	public static inline var LOCKED:String = "You walk into a closed door.";
	public static inline var CREATURE:String = "It blocks your path.";

	public var type:String;

	public function new(type:String)
	{
		this.type = type;
	}
}