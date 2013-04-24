package com.grinder.render;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.grinder.component.GridPosition;
import com.grinder.component.Animation;

class AnimationView extends View
{
	private var animation:Animation = null;
	private var gx:Int = -1;
	private var gy:Int = -1;

	override public function begin()
	{
		nodeUpdate();
	}

	private function setAnim()
	{
		animation = getComponent(Animation);
		if(animation == null)
		{
			graphic = null;
			return;
		}

		var cbFunc:CallbackFunction = (animation.looping ? null : animationFinished);
		var spritemap = new Spritemap(HXP.getBitmap(animation.tiledImage.imagePath),
			animation.tiledImage.tileSize.width, 
			animation.tiledImage.tileSize.height, 
			cbFunc);
		spritemap.add("main", animation.frames, animation.speed, animation.looping);
		spritemap.play("main");
		graphic = spritemap;
	}

	private function animationFinished(): Void
	{
		entity.remove(Animation);
	}

	override public function nodeUpdate()
	{
		// Change/update animation
		var curAnim = getComponent(Animation);
		if(curAnim != animation)
			setAnim();

		var gpos = getComponent(GridPosition);
		if(gpos.x != gx || gpos.y != gy)
		{
			var tileSize = curAnim.tiledImage.tileSize;
			gx = gpos.x;
			gy = gpos.y;
			x = gx * tileSize.width;
			y = gy * tileSize.height;
		}

		updateScrollFactor();
	}
}