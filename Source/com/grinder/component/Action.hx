package com.grinder.component;

import com.grinder.component.GridPosition;

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

	public var type:String;
	public var target:GridPosition;

	public function new(type:String, target:GridPosition = null)
	{
		this.type = type;
		this.target = target;
	}
}