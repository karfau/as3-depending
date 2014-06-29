package as3.depending.scope {
import as3.depending.Provider;

public class Mapping {

    private var forType:Class;

    public function Mapping(forType:Class) {
        this.forType = forType;
    }

    private var provider:Provider;

//    private var typeToCreate:Class;
    private var value:Object;

    public function toType(implementing:Class):Mapping {
        provider = new TypeProvider(implementing);
        return this;
    }

    public function getValue():Object {
        if (value){
            return value;
        }
        if(provider == null){
            toType(forType);
        }
        return provider.provide();
    }

    public function toInstance(value:Object):Mapping {
        this.value = value;
        return this;
    }
}
}
