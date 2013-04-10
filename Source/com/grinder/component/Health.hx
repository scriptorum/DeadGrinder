
package com.grinder.component;

class Health
{
	public var amount:Int;
	public var max:Int;

	public function new(amount:Int = 100, max:Int = 100)
	{
		this.amount = amount;
		this.max = max;
	}
}