package com.grinder.render;

import com.grinder.component.Layer;
import com.grinder.node.DisplayNode;

import ash.core.Entity;

class View extends com.haxepunk.Entity
{
	public var entity:Entity;

	public function new(entity:Entity)
	{
		super();

		this.entity = entity;

		var c = entity.get(Layer);
		if(c != null)
			this.layer = c.layer;

		begin();
		nodeUpdate();

		// trace("Created view from " + entity.name + " with position " + x + "," + y);
	}

	public function getComponent<T>(component:Class<T>): T
	{
		var instance:T = entity.get(component);
		if(instance == null)
			throw("Cannot get component " + Type.getClassName(component) + " for entity " + entity.name);
		return instance;
	}

	public function begin(): Void
	{
		// Override
	}

	public function nodeUpdate(): Void
	{
		// Override
	}
}