package com.grinder.node;

import ash.core.Node;

import com.grinder.component.CameraFocus;
import com.grinder.component.GridPosition;

class CameraFocusNode extends Node<CameraFocusNode>
{
	public var position:GridPosition;
	public var cameraFocus:CameraFocus;
}