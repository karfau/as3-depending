package as3.depending.scope {

public class Specified {

    private var _scope:Scope;
    public function get scope():Scope {
        return _scope;
    }

    public function Specified(scope:Scope) {
        _scope = scope;
    }
}
}
