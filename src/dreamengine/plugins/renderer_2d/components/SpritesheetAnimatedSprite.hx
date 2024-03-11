package dreamengine.plugins.renderer_2d.components;

import dreamengine.core.math.Vector2;
import dreamengine.core.Time;
import dreamengine.core.math.Rect;
import kha.Image;
import dreamengine.core.math.Vector2i;
import dreamengine.plugins.renderer_2d.components.AnimatedSprite.AnimationPlayType;

class SpritesheetAnimatedSprite extends Sprite {
	var isPlaying = true;
	var time:Float = 0;
	var cachedTime = 0.0;
	var animationPlayType: AnimationPlayType = Forward;
	var animationPlayState = 0;
	var isLooped = true;
	var duration: Float;
	var columnRowCount:Vector2i;
	var cellSize:Vector2i;


	public function new(image:Image, cellSize:Vector2i, columnRowCount: Vector2i, frameDuration:Float, ppu:Float = 100, flipped = false){
		super(image, ppu, flipped);

		this.columnRowCount = columnRowCount;
		this.cellSize = cellSize;

        duration = frameDuration;

		setRegion(Rect.create(
			0,0, image.width / cellSize.x, image.height / cellSize.y
		));
	}
	public function getIsPlaying() {
		return isPlaying;
	}

	public function play() {
		isPlaying = false;
	}

	public function pause() {
		isPlaying = false;
	}

	public function stop() {
		isPlaying = false;
		time = 0;
		setCurrentFrame();
	}

	public function update():Void {
		// FIXME deltaTime does not work here for some reason?
		var delta = Time.getTime() - cachedTime;
		switch (animationPlayType) {
			case Backwards:
				delta = -delta;
			case BackAndForth:
				if (animationPlayState == 1) {
					delta = -delta;
				}
			case _:
		}
		time += delta;
		cachedTime = Time.getTime();
		setCurrentFrame();

		switch (animationPlayType) {
			case Backwards:
				if (time <= 0) {
					if (isLooped) {
						restart();
					} else {
						stop();
					}
				}
			case Forward:
				if (time >= 1) {
					if (isLooped) {
						restart();
					} else {
						stop();
					}
				}
			case BackAndForth:
				if (time <= 0 || time >= 1) {
					if (isLooped) {
						restart();
					} else {
						stop();
					}
				}
		}
	}

	public function restart() {
		switch (animationPlayType) {
			case Forward:
				time = 0;
			case Backwards:
				time = 1;
			case BackAndForth:
				if (animationPlayState == 0) {
					animationPlayState = 1;
					time = 1;
				} else {
					animationPlayState = 0;
					time = 0;
				}
		}
	}

	function setCurrentFrame() {
		var i = getFrameIndex();

		var rowIndex = i / columnRowCount.y;
		var columnIndex = i % columnRowCount.y;
		setRegion(Rect.create(
			cellSize.x * rowIndex,
			cellSize.y * columnIndex,
			cellSize.x,
			cellSize.y
		));
	}

	public function getFrameIndex() {
		var iF = (time * duration) / duration;
		iF = Math.min(1, iF);
		iF *= Math.max(0, columnRowCount.x * columnRowCount.y - 1);
		var i:Int = Math.round(iF);

		return i;
	}

	override function getSpriteSize():Vector2 {
		var aspect = cellSize.x / cellSize.y;
		var ppu = getPPUScale();

		var r = new Vector2(1 / (cellSize.x *0.05), 1 / (cellSize.y * 0.05) * aspect);

		return r;
	}
}