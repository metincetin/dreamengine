package dreamengine.plugins.renderer_2d.components;

import dreamengine.core.math.Vector2i;
import dreamengine.core.Time;
import kha.Image;

class AnimatedSprite extends Sprite {
	var frames:Array<Image>;

	var isPlaying = true;
	var time = 0.0;

	public var isLooped = true;
	public var animationPlayType:AnimationPlayType = Forward;

	var animationPlayState = 0;

	var cachedTime:Float;

	public var duration:Float = 3;

	public function new(frames:Array<Image>, ppu = 100, flip = false) {
		super(frames[0], flip);
		this.frames = frames;
		this.ppu = ppu;
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

	public function update() {
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
		setImage(frames[getFrameIndex()]);
	}

	function getFrameIndex() {
		var iF = (time * duration) / duration;
		iF = Math.min(1, iF);
		iF *= Math.max(0, frames.length - 1);
		var i:Int = Math.round(iF);
		return i;
	}
}

enum AnimationPlayType {
	Forward;
	Backwards;
	BackAndForth;
}
