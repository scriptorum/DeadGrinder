package com.grinder.component;

class Collision
{
	public static inline var GENERIC:String = "You can't go that way.";
	public static inline var PERSON:String = "Someone is in your way.";
	public static inline var SHEER:String = "You smack right into the wall.";
	public static inline var CLOSED:String = "The door is closed.";
	public static inline var LOCKED:String = "That seems to be locked.";
	public static inline var CREATURE:String = "It's blocking your way!";

	public var type:String;

	public function new(type:String)
	{
		this.type = type;
	}
}