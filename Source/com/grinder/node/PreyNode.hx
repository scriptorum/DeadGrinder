package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Prey;
import com.grinder.component.GridPosition;

class PreyNode extends Node<PreyNode>
{
	public var prey:Prey; // prey target
	public var position:GridPosition; // position of hunter
}