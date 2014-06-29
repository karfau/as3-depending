package as3.depending.scope {

public class Mapping {

    private var typeToCreate:Class;

    public function toType(implementing:Class):Mapping {
        typeToCreate = implementing;
        return this;
    }

    public function getValue():Object {
        return new typeToCreate();
    }

}
}
