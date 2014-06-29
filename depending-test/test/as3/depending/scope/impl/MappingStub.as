package as3.depending.scope.impl {
import as3.depending.scope.*;

public class MappingStub extends Mapping {

    public var testValue:Object;

    function MappingStub(forType:Class) {
        super(forType);
    }

    override public function getValue():Object {
        return testValue;
    }
}
}
