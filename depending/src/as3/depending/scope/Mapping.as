package as3.depending.scope {
import as3.depending.*;
import as3.depending.provider.*;

/**
 * A Mapping instance is responsible for creating instances of the given type,
 * with fully resolved dependencies using the method getValue().
 *
 * To do this it offers a fluid API to configure the correct Providing
 * and uses the given resolver to resolve additional dependencies.
 *
 * If no Providing has been configured a Mapping will try to invoke the constructor for the given type.
 * If the given type is an interfaces this results in a VerifyError with errorCode 1001.
 */
public class Mapping {

    private var forType:Class;

    private var resolver:Resolver;
    internal function getResolver():Resolver {
        return resolver;
    }

    public function Mapping(forType:Class, resolver:Resolver) {
        this.forType = forType;
        this.resolver = resolver;
    }

    private var _providing:Providing;

    public function get providing():Providing {
        return _providing;
    }

    public function toProviding(providing:Providing):Mapping {
        if(resolver is Scope){
            Scope(resolver).specify(forType, providing);
        }
        this._providing = providing;
        return this;
    }

    public function toType(implementing:Class):Mapping {
        return toProviding(new TypeProvider(implementing));
    }

    public function toInstance(instance:Object):ValueProvider {
        resolveDepending(instance);
        return toValue(instance);
    }

    public function toValue(value:Object):ValueProvider {
        const valueProvider:ValueProvider = new ValueProvider(value);
        toProviding(valueProvider);
        return valueProvider;
    }

    public function toFactory(method:Function, ...params):Mapping {
        return toProviding(new FactoryProvider(method, params));
    }

    public function asSingleton():SameInstanceProviding {
        ensureProvider();
        var lazyValueProvider:SameInstanceProviding = _providing as SameInstanceProviding;
        if(lazyValueProvider == null){
            lazyValueProvider = new LazyValueProvider(_providing);
            toProviding(lazyValueProvider);
        }
        return lazyValueProvider;
    }

    public function asEagerSingleton():ValueProvider {
        var valueProvider:ValueProvider = _providing as ValueProvider;
        if(valueProvider == null){
            valueProvider = toValue(getValue())
        }
        return valueProvider;
    }

    public function getValue():Object {
        ensureProvider();
        var value:Object = invokeProvider(_providing, resolver);
        return value;
    }

    private function ensureProvider():void {
        if (_providing == null) {
            toType(forType);
        }
    }

    private function resolveDepending(value:Object):void {
        if (value is Depending) {
            Depending(value).fetchDependencies(resolver);
        }
    }

}
}
