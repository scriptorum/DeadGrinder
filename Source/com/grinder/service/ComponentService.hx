package com.grinder.service;

import com.grinder.component.GridPosition;
import com.grinder.component.TileImage;
import com.grinder.component.CameraFocus;

class ComponentService
{
	public static function getComponent(id:String, ?args:Array<Dynamic> = null): Dynamic
	{
		var qualifiedName = "com.grinder.component." + id;
		var clazz = Type.resolveClass(qualifiedName);
		if(clazz == null)
			throw "Cannot find component " + id;
		return Type.createInstance(clazz, args == null ? [] : args);
	}
}