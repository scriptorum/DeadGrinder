package com.grinder.component;

import com.grinder.render.View;

// Wraps a HaxePunk entity
class Display
{
	public var view:View;

	public function new(view:View)
	{
		this.view = view;
	}
}