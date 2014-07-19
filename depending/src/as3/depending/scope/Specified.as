package as3.depending.scope {
import as3.depending.Provider;

public class Specified {

    private var _scope:Scope;
    public function get scope():Scope {
        return _scope;
    }

    private var _provider:Provider;
    internal function setProvider(provider:Provider):void {
        _provider = provider
    }
    public function get provider():Provider {
        return _provider;
    }

    public function Specified(scope:Scope) {
        _scope = scope;
    }

    public function provide():Object {
        return _provider.provide(_scope)
    }
}
}
