package dreamengine.core;

import haxe.ds.Option;
import dreamengine.core.Plugin.IPlugin;

class PluginContainer implements IPlugin {
	var plugins:Array<IPlugin> = new Array<IPlugin>();
	var engine:Engine;

	public function new(engine:Engine) {
		this.engine = engine;
	}

	public function addPlugin(plugin:IPlugin) {
		for (dependency in plugin.getDependentPlugins()) {
			if (hasPlugin(dependency))
				continue;
			var p = plugin.handleDependency(dependency);
			if (p == null) {
				throw new haxe.Exception(('Dependency of ${plugin.getName()}, ${p.getName()} is not loaded nor handled in plugins handleDependency function. Load the dependency before the plugin or handle dependency creation in handleDependency function.'));
			}
			trace('Creating ${p.getName()} as dependant plugin of ${plugin.getName()}');

			addPlugin(p);
		}
		plugins.push(plugin);
		plugin.initialize(engine);
		trace('Plugin loaded: "${plugin.getName()}"');
	}

	public function removePlugin(plugin:IPlugin) {
		plugins.remove(plugin);
		plugin.finalize();
	}

	public function hasPlugin(type:Class<IPlugin>):Bool {
		for (p in plugins) {
			if (Std.isOfType(p, type)) {
				return true;
			}
		}
		return false;
	}

	public function getPlugin(name:String):Option<IPlugin> {
		for (plugin in plugins) {
			if (plugin.getName() == name) {
				return Some(plugin);
			}
		}
		return None;
	}

	public function initialize(engine:Engine) {
		for (plugin in plugins) {
			plugin.initialize(engine);
		}
	}

	public function finalize() {
		for (plugin in plugins) {
			plugin.finalize();
		}
	}

	public function getName():String {
		return "plugin_container";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>) {
		return null;
	}
}
