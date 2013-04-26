package com.grinder.render;

import com.grinder.component.Layer;
import com.grinder.component.ScrollFactor;

import ash.core.Entity;

class View extends com.haxepunk.Entity
{
	public var entity:Entity;

	public function new(entity:Entity)
	{
		super();

		this.entity = entity;
		updateLayer();

		begin();

		updateScrollFactor();
		nodeUpdate();

		// trace("Created view from " + entity.name + " with position " + x + "," + y);
	}

	public function updateScrollFactor(): Void
	{
		if(hasComponent(ScrollFactor))
		{
			if(graphic != null)
			{
				var amount = getComponent(ScrollFactor).amount;
				var graphic = cast(graphic, com.haxepunk.Graphic);
				if(amount != graphic.scrollX || amount != graphic.scrollY)
					graphic.scrollX = graphic.scrollY = amount;
			}
		}
	}

	public function updateLayer(): Void
	{
		if(hasComponent(Layer))
		{
			var newLayer = getComponent(Layer).layer;
			if(newLayer != this.layer)
				this.layer = newLayer;
		}
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