package as3.depending.scope {
import as3.depending.scope.impl.*;

internal class TestableScope extends Scope {
    public function TestableScope() {
        super();
    }

    override internal function createMapping(type:Class):Mapping {
        return new MappingStub(type);
    }
}
}

