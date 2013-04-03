package com.grinder.component;

class Equipper
{
	public var types:Hash<Int>; // type => max equippable for this type

	public function new(typeObj:Dynamic = null)
	{
		this.types = new Hash<Int>();
		if(typeObj != null)
		{
			for(type in Reflect.fields(typeObj))
				types.set(type, Reflect.getProperty(typeObj, type));
		}
	}

	public function addType(type:String, limit:Int): Void
	{
		types.set(type, limit);
	}

	public function getLimit(type:String): Int
	{
		return types.get(type);
	}
}