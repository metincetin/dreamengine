package dreamengine.plugins.dreamui.utils;

class UIXMLElementTypes {
    static var types = new Map<String, Class<Element>>();

    static public function registerType(name:String, type:Class<Element>){
        types.set(name, type);        
    }
    static public function getType(name:String){
        return types.get(name);
    }
}