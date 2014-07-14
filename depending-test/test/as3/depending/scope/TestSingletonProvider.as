package as3.depending.scope {
import as3.depending.scope.impl.ProviderMock;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.object.strictlyEqualTo;

public class TestSingletonProvider {

    private var provider:SingletonProvider;
    private var contained:ProviderMock;



    [Before]
    public function setUp():void {
        contained = new ProviderMock();
        provider = new SingletonProvider(contained);
    }


    [Test]
    public function creation_does_not_invoke_contained_provider():void {
        assertThat(contained.callsTo_provide, strictlyEqualTo(0));
    }

    [Test]
    public function provide_delegates_to_contained_provider():void {
        provider.provide();
        assertThat(contained.callsTo_provide, strictlyEqualTo(1));
    }

    [Test]
    public function provide_returns_singleton():void {
        const first:Object = provider.provide();
        assertThat(provider.provide(), strictlyEqualTo(first));
        assertThat(contained.callsTo_provide, strictlyEqualTo(1));
    }

    [Test]
    public function providesResolved_delegates_to_contained_provider():void {
        contained.isProvidingResolved = true;
        assertTrue(provider.providesResolved);
        contained.isProvidingResolved = false;
        assertFalse(provider.providesResolved);
    }

}
}
