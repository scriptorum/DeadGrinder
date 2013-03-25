package com.grinder.node;

import com.grinder.component.Repeating;
import com.grinder.component.Image;
import com.grinder.render.BackdropView;
import ash.core.Node;

class BackdropViewNode extends Node<BackdropViewNode>
{
	public var image:Image;
	public var repeating:Repeating;
	public var view:BackdropView;
}