package as3.depending.scope {
internal class TestableScope extends Scope {
    public function TestableScope() {
        super();
    }

    override internal function createMapping(type:Class):Mapping {
        return new MappingStub(type);
    }
}
}

