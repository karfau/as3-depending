package as3.depending.scope {
import as3.depending.Providing;
import as3.depending.provider.LazyValueProvider;
import as3.depending.provider.ProviderZero;
import as3.depending.provider.ProvidingSameInstance;
import as3.depending.provider.ValueProvider;
import as3.depending.provider.invokeProvider;

public class Specified implements ProviderZero {

    private var _scope:Scope;
    public function get scope():Scope {
        return _scope;
    }

    private var _providing:Providing;
    internal function setProviding(provider:Providing):void {
        _providing = provider
    }
    public function get providing():Providing {
        return _providing;
    }

    public function Specified(scope:Scope) {
        _scope = scope;
    }

    public function provide():Object {
        return invokeProvider(_providing, _scope);
    }

    public function asSingleton():ProvidingSameInstance {
        var valueProvider:ProvidingSameInstance = _providing as ProvidingSameInstance;
        if (valueProvider == null) {
            valueProvider = new LazyValueProvider(providing);
            setProviding(valueProvider);
        }
        return valueProvider;
    }

    public function asEagerSingleton():ValueProvider {
        var valueProvider:ValueProvider = _providing as ValueProvider;
        if (valueProvider == null) {
            valueProvider = new ValueProvider(provide());
            setProviding(valueProvider);
        }
        return valueProvider;
    }
}
}
