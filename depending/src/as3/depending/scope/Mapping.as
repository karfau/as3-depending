package as3.depending.scope {

public class Mapping {

    private var forType:Class;

    public function Mapping(forType:Class) {
        this.forType = forType;
    }

    private var typeToCreate:Class;
    private var value:Object;

    public function toType(implementing:Class):Mapping {
        typeToCreate = implementing;
        return this;
    }

    public function getValue():Object {
        if (value){
            return value;
        }
        if(typeToCreate == null){
            typeToCreate = forType;
        }
        return new typeToCreate();
    }

    public function toInstance(value:Object):Mapping {
        this.value = value;
        return this;
    }
}
}
