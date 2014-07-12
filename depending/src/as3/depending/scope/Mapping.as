package as3.depending.scope {
import as3.depending.Depending;
import as3.depending.Provider;
import as3.depending.Resolver;

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

    private var _resolver:Resolver;
    internal function get resolver():Resolver {
        return _resolver;
    }

    public function Mapping(forType:Class, resolver:Resolver) {
        this.forType = forType;
        _resolver = resolver;
    }

    private var provider:Provider;

    public function toProvider(provider:Provider):Mapping {
        this.provider = provider;
        return this;
    }

    public function toType(implementing:Class):Mapping {
        provider = new TypeProvider(implementing);
        return this;
    }

    public function toInstance(value:Object):Mapping {
        resolveDepending(value);
        toResolvedInstance(value);
        return this;
    }

    public function toFactory(method:Function, ...params):Mapping {
        if(params.length == 0 && method.length == 1){
            params[0] = _resolver;
        }
        provider = new FactoryProvider(method, params);
        return this;
    }

    private var lazySingelton:Boolean;
    public function asSingleton(lazy:Boolean = true):Mapping {
        if(lazy){
            lazySingelton = true;
        }else{
            asEagerSingleton();
        }
        return this;
    }

    public function asEagerSingleton():Mapping {
        toResolvedInstance(getValue());
        return this;
    }

    public function getValue():Object {
        if (provider == null) {
            toType(forType);
        }
        var value:Object = provider.provide();
        if(!provider.providesResolved){
            resolveDepending(value);
        }
        if(lazySingelton){
            lazySingelton = false;
            toResolvedInstance(value);
        }
        return value;
    }

    private function resolveDepending(value:Object):void {
        if (value is Depending) {
            Depending(value).fetchDependencies(_resolver);
        }
    }

    private function toResolvedInstance(resolvedValue:Object):void {
        provider = new InstanceProvider(resolvedValue);
    }
}
}
