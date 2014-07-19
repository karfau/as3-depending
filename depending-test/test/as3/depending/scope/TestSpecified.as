package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.examples.tests.Instance;
import as3.depending.provider.LazyValueProvider;
import as3.depending.provider.ProviderMock;
import as3.depending.scope.impl.Invokes;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;

import org.hamcrest.collection.array;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class TestSpecified {


    private var invokes:Invokes;
    private var scope:TestableScope;
    private var it:Specified;
    private var provider:Provider;

    [Before]
    public function setUp():void {
        invokes = new Invokes();
        scope = new TestableScope(invokes);
        it = new Specified(scope);
        provider = new ProviderMock(invokes);
    }

    [Test]
    public function provide_invokes_provider_with_scope():void {
        it.setProvider(provider);
        assertThat(it.provide(), instanceOf(Instance));
        invokes.assertWasInvokedWith(provider.provide, array(scope))
    }

    [Test(expects="TypeError")]
    public function provide_returns_undefined_without_provider():void {
        assertNull('it.provider',it.provider);
        it.provide();
    }


    [Test]
    public function asSingleton_specifies_a_LazyValueProvider_wrapping_provider():void {
        it.setProvider(provider);

        it.asSingleton();
        assertThat(it.provider, instanceOf(LazyValueProvider));

        it.provide();
        invokes.assertWasInvokedWith(provider.provide, array(strictlyEqualTo(scope)))
    }

    [Test]
    public function asSingleton_keeps_specified_ValueProvider():void {
        it.setProvider(ProviderMock.Null);

        it.asSingleton();
        assertThat(it.provider, strictlyEqualTo(ProviderMock.Null));
    }

}
}
