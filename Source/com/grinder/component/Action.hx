package com.grinder.component;

import ash.core.Entity;

class Action
{
	public static inline var OPEN:String = "open";
	public static inline var CLOSE:String = "close";
	public static inline var LOCK:String = "lock";
	public static inline var UNLOCK:String = "unlock";
	public static inline var EXAMINE:String = "examine";
	public static inline var ATTACK:String = "attack";
	public static inline var TAKE:String = "take";
	public static inline var DROP:String = "drop";
	public static inline var EQUIP:String = "equip";
	public static inline var INVENTORY:String = "inventory";
	public static inline var EAT:String = "eat";
	public static inline var WIELD:String = "wield";
	public static inline var UNWIELD:String = "unwield";

	public var type:String;
	public var source:Entity;

	public function new(type:String, source:Entity = null)
	{
		this.type = type;
		this.source = source;
	}
}