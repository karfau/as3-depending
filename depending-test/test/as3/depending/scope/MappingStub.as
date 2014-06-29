package as3.depending.scope {
internal class MappingStub extends Mapping {

    public var testValue:Object;

    function MappingStub(forType:Class) {
        super(forType);
    }

    override public function getValue():Object {
        return testValue;
    }
}
}
