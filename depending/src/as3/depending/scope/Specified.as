package as3.depending.scope {
import as3.depending.Providing;
import as3.depending.provider.LazyValueProvider;
import as3.depending.provider.ValueProvider;
import as3.depending.provider.invokeProvider;

public class Specified {

    private var _scope:Scope;
    public function get scope():Scope {
        return _scope;
    }

    private var _provider:Providing;
    internal function setProvider(provider:Providing):void {
        _provider = provider
    }
    public function get provider():Providing {
        return _provider;
    }

    public function Specified(scope:Scope) {
        _scope = scope;
    }

    public function provide():Object {
        return invokeProvider(_provider, _scope);
    }

    public function asSingleton():void {
        if (provider is ValueProvider) {
            return;
        }
        setProvider(new LazyValueProvider(provider));
    }

    public function asEagerSingleton():void {
        if (provider is ValueProvider) {
            return;
        }
        setProvider(new ValueProvider(provide()));
    }
}
}
