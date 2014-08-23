package as3.depending.scope {
import as3.depending.examples.tests.IProtocol;
import as3.depending.provider.ProviderMock;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.object.strictlyEqualTo;

public class TestIdentifierMap {

    private var it:IdentifierMap;

    [Before]
    public function setUp():void {
        it = new IdentifierMap();
    }

    [Test]
    public function has_returns_false_initially():void {
        assertFalse(it.has(null));
        assertFalse(it.has(IProtocol));
    }

    [Test]
    public function get_returns_null_initially():void {
        assertNull(it.get(null));
        assertNull(it.get(IProtocol));
    }

    [Test]
    public function set_stores_Providing():void {

        it.set(null, ProviderMock.Null);

        assertThat('stored value', it.get(null), strictlyEqualTo(ProviderMock.Null));
        assertTrue('has returns', it.has(null));
        assertFalse('hasSpecified returns', it.hasSpecified(null));
    }

    [Test]
    public function hasSpecified_returns_false_initially():void {
        assertFalse(it.hasSpecified(null));
        assertFalse(it.hasSpecified(IProtocol));
    }

    [Test]
    public function hasSpecified_returns_true_when_set_stored_Specified():void {

        const specified:Specified = new Specified(null);
        it.set(null, specified);

        assertThat('stored value', it.get(null), strictlyEqualTo(specified));
        assertTrue('hasSpecified returns', it.hasSpecified(null));
    }

    [Test]
    public function has_returns_true_when_Providing_null():void {
        it.set(null, null);
        assertTrue('has returns', it.has(null));
    }
}
}
