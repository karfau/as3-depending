package as3.depending.scope {
import as3.depending.Depending;
import as3.depending.Provider;
import as3.depending.Resolver;

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
        provider = new InstanceProvider(value);
        return this;
    }

    public function toFactory(method:Function, ...params):Mapping {
        if(params.length == 0 && method.length == 1){
            params[0] = _resolver;
        }
        provider = new FactoryProvider(method, params);
        return this;
    }

    public function getValue():Object {
        if (provider == null) {
            toType(forType);
        }
        var value:Object = provider.provide();
        if ((value is Depending)/* && !(provider is InstanceProvider)*/) {//TODO: avoid calling injection twice!
            Depending(value).fetchDependencies(_resolver);
        }
        return value;
    }
}
}
