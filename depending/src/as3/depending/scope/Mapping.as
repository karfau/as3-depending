package as3.depending.scope {
import as3.depending.*;
import as3.depending.provider.*;

/**
 * A Mapping instance is responsible for creating instances of the given type, with fully resolved dependencies using the method getValue().
 *
 * To do this it offers a fluid API to configure the correct Provider
 * and uses the given resolver to resolve additional dependencies.
 *
 * If no Provider has been configured a Mapping will try to invoke the constructor for the given type.
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

    private var _provider:Provider;

    public function get provider():Provider {
        return _provider;
    }

    public function toProvider(provider:Provider):Mapping {
        if(resolver is Scope){
            Scope(resolver).specify(forType, provider);
        }
        this._provider = provider;
        return this;
    }

    public function toType(implementing:Class):Mapping {
        return toProvider(new TypeProvider(implementing));
    }

    public function toInstance(instance:Object):Mapping {
        resolveDepending(instance);
        toValue(instance);
        return this;
    }

    public function toValue(value:Object):void {
        toProvider(new ValueProvider(value));
    }

    public function toFactory(method:Function, ...params):Mapping {
        return toProvider(new FactoryProvider(method, params));
    }

    public function asSingleton():Provider {
        if(_provider is ValueProvider){
            return _provider;
        }
        toProvider(new LazyValueProvider(_provider));
        return _provider;
    }

    public function asEagerSingleton():Provider {
        if(_provider is ValueProvider){
            return _provider;
        }
        toValue(getValue());
        return _provider;
    }

    public function getValue():Object {
        if (_provider == null) {
            toType(forType);
        }
        var value:Object = _provider.provide(resolver);
        return value;
    }

    private function resolveDepending(value:Object):void {
        if (value is Depending) {
            Depending(value).fetchDependencies(resolver);
        }
    }

}
}
