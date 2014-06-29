package as3.depending.scope {

public class Mapping {

    private var typeToCreate:Class;
    private var value:Object;

    public function toType(implementing:Class):Mapping {
        typeToCreate = implementing;
        return this;
    }

    public function getValue():Object {
        if (typeToCreate)
            return new typeToCreate();
        if (value)
            return value;
        return null;
    }

    public function toInstance(value:Object):Mapping {
        this.value = value;
        return this;
    }
}
}
