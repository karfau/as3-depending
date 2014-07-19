package as3.depending.scope {
import as3.depending.scope.impl.*;

internal class TestableScope extends Scope {
    private var invokes:Invokes;

    public function TestableScope(invokes:Invokes) {
        this.invokes = invokes;
    }
    override protected function createMapping(type:Class):Mapping {
        return new TestableMapping(invokes);
    }

    override public function specify(identity:Object, ...specification):Specified {
        var args:Array = [identity].concat(specification);
        invokes.invoke(specify, args);
        return null;
    }
}
}

