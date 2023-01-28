package dreamengine.plugins.dreamui.styling;

class Selector {
	public var type:String;
	public var id:String;
	public var classes = new Array<String>();
	public var descendingSelectors = new Array<Selector>();
    public var directChildSelectors = new Array<Selector>();

	public function new(string:String) {

        var descending = StringTools.trim(string).split(" ");

        singleParse(descending[0]);

        if (descending.length > 1){
            for(i in 1...descending.length){
                var selectorString = descending[i];
                var descendingSelector = new Selector(selectorString);

                descendingSelectors.push(descendingSelector);
            }
        }

	
    }

	function singleParse(string:String) {

        var parserType:SelectorParserType = Type;
        var currentValue = "";

		for (i in 0...string.length) {
			var c = string.charAt(i);
			var end = false;

			var newType = parserType;

			if (c == ".") {
				newType = Class;
				end = true;
			}
			if (c == "#") {
				newType = Id;
				end = true;
			}

			if (end) {
				setValueForSelector(parserType, currentValue);
				currentValue = "";
				parserType = newType;
			} else {
				currentValue += c;
			}
		}
		setValueForSelector(parserType, currentValue);
    }

	function setValueForSelector(parserType:SelectorParserType, value:String, inheriting = false) {
		if (value.length > 0) {
			switch (parserType) {
				case Class:
					classes.push(value);
				case Id:
					id = value;
				case Type:
					type = value;
			}
		}
	}
}

enum SelectorParserType {
	Type;
	Id;
	Class;
}
