package dreamengine.core;

import haxe.Json;

class Project{
    public var path:String;
    public var name:String;
    public var version:String;
    public var packageName:String;

    public function new(){}

    // public static function loadFromPath(path:String): Project{
    //     var pr = new Project();
    //     pr.path = path;
        
    //     if (FileSystem.exists(path)){
    //         var content = Json.parse(File.getContent(path));
    //         pr.name = content.name;
    //         pr.version = content.version;
    //         pr.packageName = content.packageName;
    //         return pr;
    //     }
    //     throw "Project not found in given path";
    //     return null;
    // }
}