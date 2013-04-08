package com.grinder.component;

import ash.core.Entity;

// Added to an inventory entity to hold onto a list of entities from which the menu is generated.
// Create the list of entities by scanning all entities that are Carried, restricting by Equipment if 
// filtering by weapon or armor or food etc. 

class Inventory
{
	public var equipmentType:String;
	public var entities:Array<Entity>;
	public var selected:Int;
	public var changed:Bool = true;

	public function new(entities:Array<Entity>, equipmentType:String = null, selected:Int = 0)
	{
		this.entities = entities;
		this.equipmentType = equipmentType;
		this.selected = selected;
		this.changed = true;
	}
}