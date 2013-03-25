package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.TileImage;
import com.grinder.render.ImageView;
import ash.core.Node;

class ImageViewNode extends Node<ImageViewNode>
{
	public var position:GridPosition;
	public var tileImage:TileImage;
	public var view:ImageView;
}