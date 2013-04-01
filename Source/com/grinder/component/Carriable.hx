package com.grinder.component;

//
// See Carrier.hx
//

class Carriable
{
	public var weight:Float;
	public var quantity:Int;

	// Supports quantity if you like stacking
	public function new(weight:Float, quantity:Int = 1)
	{
		this.weight = weight;
		this.quantity = quantity;
	}
}