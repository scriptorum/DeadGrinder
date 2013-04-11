package com.grinder.component;

//
// To add items to a Carrier (aka "inventory"), create the item entity,
// then add to that item a Carried component, supplying an inventoryId
// matching this inventory's id. In contrast, a Carryable component
// is one that can be picked up, but it's not necessarily carried
// right now.
//

class Carrier
{
	public static inline var UNRESTRICTED = -1;
	public static var nextId:Int = 0;

	public var id:Int;
	public var maxWeight:Float;
	public var maxCount:Int;

	public function new(maxWeight:Float = UNRESTRICTED, maxCount:Int = UNRESTRICTED)
	{
		id = nextId++;
		this.maxWeight = maxWeight;
		this.maxCount = maxCount;
	}
}