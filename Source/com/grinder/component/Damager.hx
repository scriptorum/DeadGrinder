package com.grinder.component;

class Damager
{
	public static inline var SLASHING:String = "slashing";
	public static inline var BLUNT:String = "blunt";

	public var amount:Int;
	public var type:String;

	public function new(amount:Int, type:String = BLUNT)
	{
		this.amount = amount;
		this.type = type;
	}
}