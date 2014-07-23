package as3.depending.scope {
import as3.depending.Providing;
import as3.depending.provider.LazyValueProvider;
import as3.depending.provider.SameInstanceProviding;
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

    public function asSingleton():SameInstanceProviding {
        var valueProvider:SameInstanceProviding = _provider as SameInstanceProviding;
        if (valueProvider == null) {
            valueProvider = new LazyValueProvider(provider);
            setProvider(valueProvider);
        }
        return valueProvider;
    }

    public function asEagerSingleton():ValueProvider {
        var valueProvider:ValueProvider = _provider as ValueProvider;
        if (valueProvider == null) {
            valueProvider = new ValueProvider(provide());
            setProvider(valueProvider);
        }
        return valueProvider;
    }
}
}
