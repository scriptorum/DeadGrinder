package com.grinder.component;

import ash.core.Entity;
import com.grinder.component.GridPosition;

class Prey
{
	public var entity:Entity; // prey target
	public var position:GridPosition; // target's position
	public var interest:Int; // how much interest from 0-100 the hunter has for this entity

	public function new(entity:Entity, position:GridPosition, interest:Int = 100)
	{
		this.entity = entity;
		this.position = position;
		this.interest = interest;
	}

	public function copy(prey:Prey): Void
	{
		if(prey == null)
			throw "Cannot copy null Prey component";	
		this.entity = prey.entity;
		this.position = prey.position;
		this.interest = prey.interest;
	}
}