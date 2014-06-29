package as3.depending.scope {
import as3.depending.Depending;
import as3.depending.Provider;
import as3.depending.Resolver;

public class Mapping {

    private var forType:Class;

    private var _resolver:Resolver;
    internal function get resolver():Resolver{
        return _resolver;
    }
    internal function set resolver(resolver:Resolver):void {
        this._resolver = resolver;
    }

    public function Mapping(forType:Class) {
        this.forType = forType;
    }

    private var provider:Provider;

    public function toType(implementing:Class):Mapping {
        provider = new TypeProvider(implementing);
        return this;
    }

    public function getValue():Object {
        if(provider == null){
            toType(forType);
        }
        var value:Object = provider.provide();
        if ((value is Depending)/* && !(provider is InstanceProvider)*/) {//TODO: avoid calling injection twice!
            Depending(value).fetchDependencies(resolver);
        }
        return value;
    }

    public function toInstance(value:Object):Mapping {
        provider = new InstanceProvider(value);
        return this;
    }
}
}
