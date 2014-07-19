package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.provider.LazyValueProvider;
import as3.depending.provider.ValueProvider;

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

    public function asSingleton():void {
        if (provider is ValueProvider) {
            return;
        }
        setProvider(new LazyValueProvider(provider));
    }
}
}
