package as3.depending.examples.factory {
public class Inspector {

    private var _name:String;
    public function get name():String {
        return _name;
    }

    public function Inspector(name:String) {
        this._name = name;
    }
}
}
