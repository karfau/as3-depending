package as3.depending.scope.impl {
import as3.depending.scope.*;

public class TestableMapping extends Mapping {

    private var invokes:Invokes;

    public function TestableMapping(invokes:Invokes) {
        super(null, null);
        this.invokes = invokes;
    }

    override public function getValue():Object {
        invokes.invoke(getValue);
        return undefined;
    }
}
}
