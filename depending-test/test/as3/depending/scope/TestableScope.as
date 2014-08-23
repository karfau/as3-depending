package as3.depending.scope {
import as3.depending.scope.impl.*;

internal class TestableScope extends Scope {
    private var invokes:Invokes;

    public function TestableScope(invokes:Invokes) {
        this.invokes = invokes;
    }

    override public function specify(identifier:Object, value:* = undefined):Specified {
        invokes.invoke(specify, [identifier, value]);
        return null;
    }
}
}

