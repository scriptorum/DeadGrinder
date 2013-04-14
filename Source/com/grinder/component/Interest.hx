package com.grinder.component;

import com.grinder.component.GridPosition;

class Interest
{
	public var target:GridPosition;
	public var amount:Int;

	public function new(target:GridPosition, amount:Int = 100)
	{
		this.target = target;
		this.amount = amount;
	}

	public function copy(interest:Interest): Void
	{
		if(interest == null)
			throw "Cannot copy null Interest component";	
		this.target = interest.target;
		this.amount = interest.amount;
	}
}