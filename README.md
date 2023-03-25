# dreamengine

Highly extensible, data driven game-engine.

## Installation

**Make sure that node and haxe are installed.**

### dreamengine-cli

dreamengine-cli is preferred way for setting up dream engine and projects. See [dreamengine-cli](https://github.com/metincetin/dreamengine_cli)

To install the CLI, run following commands

```bash
haxelib install dreamengine-cli
haxelib run dreamengine-cli setup
```

You will be prompted for root privilages. After entering your password dreamengine command will be available in your path.

Having installed the cli, you can use 

```bash
dreamengine new myGame
cd myGame && dreamengine install
```
new project will be set up in `myGame` folder and install dependencies for dream project.


## Hello World

A Main class is generated inside `src/` folder. To make a running game, use Engine.start() inside main function.

```haxe
static function main(){
    Engine.start((engine)->{
        trace("Hello, world!");
    });
}
```

Run `node Kha/make --run` that will compile and run the game for your platform.

You can use `node Kha/make debug-html5 && node Kha/make --server` which will build your game for web, and set a server up.  

You can also use Kode Studio or Kha extension for visual studio code, then launch the project with Run>Start Debugging from the IDE.   
