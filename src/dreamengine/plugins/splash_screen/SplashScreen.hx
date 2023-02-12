package dreamengine.plugins.splash_screen;

import dreamengine.core.math.Vector2;
import dreamengine.core.math.Mathf;
import dreamengine.device.Screen;
import kha.Assets;
import kha.Image;
import dreamengine.core.Time;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

typedef SplashScreenSettings = {
    var splashImagePaths:Array<String>;
    var loadAndWaitAllAssets:Bool;
    var durationPerImages: Float;
    var splashImageSize: Float;
}

class SplashScreen implements IPlugin{
    
    var settings:SplashScreenSettings;

    var loadedSplashImages = new Array<Image>();

    var time = 0.0;

    var onReady:Void->Void;

    var engine:Engine;

    public function new(settings:SplashScreenSettings, onReady:Void->Void){
        this.settings = settings;
        this.onReady = onReady;
    }
    
	public function initialize(engine:Engine) {
        loadedSplashImages.resize(settings.splashImagePaths.length);
        for(i in 0...settings.splashImagePaths.length){
            var path = settings.splashImagePaths[i];
            Assets.loadImage(path, function(image){
                loadedSplashImages[i] = image;
            });
        }
        engine.registerRenderEvent(onRender);
        engine.registerLoopEvent(onLoop);

        this.engine = engine;
        if (settings.loadAndWaitAllAssets){
            Assets.loadEverything(function(){});
        }
    }

    function onLoop(){ 
        time += Time.getDeltaTime();
        if (time >= settings.durationPerImages * settings.splashImagePaths.length && kha.Assets.progress >= 1){
            engine.pluginContainer.removePlugin(this);
            if (onReady!= null) 
            {
                onReady();
            }
        }
    }

    function onRender(framebuffer:Framebuffer){
        var graphics = framebuffer.g2;

        graphics.begin(true, Black);
        var curImageIndex = Std.int(Math.min(loadedSplashImages.length - 1, time / settings.durationPerImages));
        var img = loadedSplashImages[curImageIndex];
        if (img != null){
            var resolution = Screen.getResolution();
            var size = new Vector2(settings.splashImageSize, settings.splashImageSize);
            size.y *= img.width / img.height;
            graphics.drawScaledImage(img, resolution.x * 0.5 - size.x * 0.5, resolution.y * 0.5 - size.y* 0.5, size.x, size.y);
        }
        graphics.end();

    }

	public function finalize() {
        engine.unregisterLoopEvent(onLoop);
        engine.unregisterRenderEvent(onRender);
    }

	public function getName():String {
        return "splash";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
        return [];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
        return null;
	}
}