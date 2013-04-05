package com.grinder.render;

import com.grinder.component.Layer;
import com.grinder.node.DisplayNode;
import com.grinder.component.ScrollFactor;

import ash.core.Entity;

class View extends com.haxepunk.Entity
{
	public var entity:Entity;
	public var parameters:Dynamic;

	public function new(entity:Entity, parameters:Dynamic = null)
	{
		super();

		this.entity = entity;
		this.parameters = parameters;

		var c = entity.get(Layer);
		if(c != null)
			this.layer = c.layer;
		trace("View created. " + (c == null ? "Using default layer." : "Using supplied Layer:" + c.layer));

		begin();

		if(hasComponent(ScrollFactor))
		{
			var graphic = cast(graphic, com.haxepunk.Graphic);
			graphic.scrollX = graphic.scrollY = getComponent(ScrollFactor).amount;
		}

		nodeUpdate();

		// trace("Created view from " + entity.name + " with position " + x + "," + y);
	}

	public function hasComponent<T>(component:Class<T>): Bool
	{
		return entity.has(component);
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