package as3.depending.scope.impl {
import as3.depending.Resolver;
import as3.depending.scope.*;

public class MappingStub extends Mapping {

    public var testValue:Object;


    public function MappingStub(forType:Class, resolver:Resolver) {
        super(forType, resolver);
    }

    override public function getValue():Object {
        return testValue;
    }
}
}
