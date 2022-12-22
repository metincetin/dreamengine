package dreamengine.plugins.renderer_2d.components;

import dreamengine.plugins.renderer_base.components.Transform;
import kha.graphics2.Graphics;
import dreamengine.core.math.Vector.Vector3;
import dreamengine.core.Time;
import dreamengine.plugins.ecs.Component;

class Particle {
	public var time = 0.0;
    public var localPosition = new Vector3();
    public var localRotation = 0.0;
    public var scale = 1.0;
    public var opacity = 1.0;

    public var velocity = new Vector3();
    public var angularVelocity = 2.0;

	public function new() {}
}

class ParticleEmitter extends Component {
	public var duration = 2.0;
	public var timeScale = 1.0;
	public var particleLifetime = 2.0;
	public var loop = false;
	public var size:Float = 8.0;

	public var particlePerSecond = 8;

	var particles = new Array<Particle>();

	var particleCreationCounter = 0.0;

    var removeQueue = new Array<Particle>();

	public function update(transform:Transform, g2:Graphics) {
        var deltaTime = Time.getDeltaTime();
		particleCreationCounter += deltaTime * particlePerSecond;
		var particleToCreate = Std.int(particleCreationCounter);
		for (i in 0...particleToCreate) {
            var particle = new Particle();
            particle.localPosition = new Vector3(Math.random() * 25, Math.random() * 25);
            particle.velocity = new Vector3(3,-17,0);
            particles.push(particle);
        }
		particleCreationCounter -= particleToCreate;

        for(p in particles){
            var timeNormalized = p.time / particleLifetime;
            p.time += deltaTime;
            p.scale = 1 - timeNormalized;
            p.opacity = 1 - timeNormalized;
            p.localRotation += p.angularVelocity * deltaTime;
            p.localPosition.add(p.velocity.scaled(deltaTime));
            render(size, transform, p, g2);
            if (p.time >= particleLifetime){
                removeQueue.push(p);
            }
        }
        for(p in removeQueue){
            particles.remove(p);
        }
        untyped removeQueue.length = 0;
	}
    function render(size:Float, transform:Transform, particle:Particle, g2:Graphics){
        var pos = transform.getPosition();
        g2.pushTranslation(pos.x, pos.y);
        g2.pushRotation(particle.localRotation, pos.x + particle.localPosition.x, pos.y + particle.localPosition.y);
        g2.pushOpacity(particle.opacity);
        g2.drawRect(particle.localPosition.x - size * 0.5, particle.localPosition.y - size * 0.5, size * particle.scale, size * particle.scale);
        g2.popOpacity();
        g2.popTransformation();
        g2.popTransformation();
    }
}
