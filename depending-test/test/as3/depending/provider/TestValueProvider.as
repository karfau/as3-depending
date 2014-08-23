package as3.depending.provider {
import as3.depending.examples.tests.IProtocol;
import as3.depending.examples.tests.Instance;

import org.flexunit.asserts.assertTrue;

public class TestValueProvider {

    //noinspection JSFieldCanBeLocal
    private var it:ValueProvider;

    [Test]
    public function type_for_null_is_null():void {
        it = ProviderMock.Null;
        assertTrue(it.type === null);
    }

    [Test]
    public function type_for_value():void {
        it = new ValueProvider(new Instance());
        assertTrue(it.type === Instance);
    }

    [Test]
    public function type_for_class_value():void {
        it = new ValueProvider(IProtocol);
        assertTrue(it.type === Class);
    }
}
}
