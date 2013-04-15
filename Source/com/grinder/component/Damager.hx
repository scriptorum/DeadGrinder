package com.grinder.component;

import com.grinder.component.Damage;

class Damager
{
	public static inline var SLASHING:String = "slashing";
	public static inline var BLUNT:String = "blunt";

	public var amount:Int;
	public var variableAmount:Int;
	public var type:String;

	public function new(amount:Int, variableAmount:Int = 0, type:String = BLUNT)
	{
		this.amount = amount;
		this.variableAmount = variableAmount;
		this.type = type;
	}

	// Randomizes an amount of damage within the range specified
	public function rand(): Int
	{
		if(variableAmount < 0)
			return amount - Std.random(Math.floor(Math.abs(variableAmount)));
		else if(variableAmount == 0)
			return amount;
		return amount + Std.random(variableAmount);
	}

	public function getDamage(): Damage
	{
		return new Damage(this.rand());
	}
}