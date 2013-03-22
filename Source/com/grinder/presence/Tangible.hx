package com.grinder.presence;

import com.grinder.presence.Presence;
import com.grinder.Catalog;

// All behaviors must be imported here, until Haxe 3.0 allows wildcard imports
import com.grinder.behavior.BPlayer;
import com.grinder.behavior.BZombie;
import com.grinder.behavior.BInventory;
import com.grinder.behavior.BLocked;
import com.grinder.behavior.BClosed;

class Tangible extends Presence
{
	public var type(default,null):CatalogObject;
	public var curState:String;

	public function new(type:Dynamic, x:Int, y:Int)
	{
		super(x,y);

		if(Std.is(type, String))
			type = Catalog.getInstance().getObject(type);
		this.type = type;

		curState = type.getDefaultStateStr();
		var state = type.getState(curState);
		if(state == null)
		{
			trace("Tangible cannot load default state " + curState + " for instance of " + type.id);
			return;
		}

		if(state.behavior != null)
		{
			var clazzName = "com.grinder.behavior." + state.behavior;
			var clazz = Type.resolveClass(clazzName);	
			if(clazz != null)
				addBehavior(Type.createInstance(clazz, [this]));
			else trace("Tangible cannot identify behavior " + clazzName);	
		}
	}

	public function getState(): CatalogObjectState
	{
		return type.getState(curState);
	}

	public function setState(str:String): Void
	{
		curState = str;
	}

	public function getTileSet(): String 
	{
		return "img/catalog.png";
	}

	public function getTileSize(): Int // must overrde
	{	
		return 32;
	}
}