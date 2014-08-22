package as3.depending.scope.impl {
import as3.depending.scope.*;

public class TestableMapping extends Mapping {

    private var invokes:Invokes;

    public function TestableMapping(forType:Class, invokes:Invokes) {
        super(forType, null);
        this.invokes = invokes;
    }

    override public function getValue():Object {
        invokes.invoke(getValue);
        return undefined;
    }
}
}
