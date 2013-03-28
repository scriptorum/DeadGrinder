package com.grinder.service;

import com.grinder.component.Action;
import com.grinder.component.Collision;
import com.grinder.component.State;
import com.grinder.component.Size;
import com.grinder.component.GridSize;
import com.grinder.component.GridVelocity;
import com.grinder.component.Velocity;
import com.grinder.component.Position;
import com.grinder.component.GridPosition;
import com.grinder.component.Tile;
import com.grinder.component.TiledImage;
import com.grinder.component.Grid;
import com.grinder.component.Display;
import com.grinder.component.Image;
import com.grinder.component.CameraFocus;
import com.grinder.component.Repeating;
import com.grinder.component.Layer;
import com.grinder.component.Doorway;
import com.grinder.component.Health;
import com.grinder.component.InputControl;
import com.grinder.component.Inventory;
import com.grinder.component.Orientation;

class ComponentService
{
	public static function getComponent(id:String, ?args:Array<Dynamic> = null): Dynamic
	{
		var qualifiedName = "com.grinder.component." + id;
		var clazz = Type.resolveClass(qualifiedName);
		if(clazz == null)
			throw "Cannot find component " + id;

		try
		{
			return Type.createInstance(clazz, (args == null ? [] : args));
		} catch(msg:String)
		{
			throw("Cannot create component " + id + " with args " + args);
		}
	}
}

