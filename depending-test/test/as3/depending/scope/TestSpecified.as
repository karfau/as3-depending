package as3.depending.scope {
import as3.depending.examples.tests.Instance;
import as3.depending.provider.LazyValueProvider;
import as3.depending.provider.ProviderMock;
import as3.depending.provider.ProvidingSameInstance;
import as3.depending.provider.SameInstanceProviderMock;
import as3.depending.provider.ValueProvider;
import as3.depending.scope.impl.Invokes;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertNull;
import org.hamcrest.collection.array;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class TestSpecified {


    private var invokes:Invokes;
    private var scope:TestableScope;
    private var it:Specified;
    private var provider:ProviderMock;

    [Before]
    public function setUp():void {
        invokes = new Invokes();
        scope = new TestableScope(invokes);
        it = new Specified(scope);
        provider = new ProviderMock(invokes);
    }

    [Test]
    public function provide_invokes_provider_with_scope():void {
        it.setProviding(provider);
        assertThat(it.provide(), instanceOf(Instance));
        invokes.assertWasInvokedWith(provider.provide, array(scope))
    }

    [Test(expects="TypeError")]
    public function provide_returns_undefined_without_provider():void {
        assertNull('it.providing', it.providing);
        it.provide();
    }


    [Test]
    public function asSingleton_specifies_a_LazyValueProvider_wrapping_provider():void {
        it.setProviding(provider);

        var singletonProvider:ProvidingSameInstance = it.asSingleton();
        assertThat(it.providing, instanceOf(LazyValueProvider));

        it.provide();
        invokes.assertWasInvokedWith(provider.provide, array(strictlyEqualTo(scope)));

        it.asSingleton();//make sure the created LazyValueProvider is not wrapped again
        assertThat(it.providing, strictlyEqualTo(singletonProvider));

    }

    [Test]
    public function asSingleton_keeps_specified_SameInstanceProvider():void {
        var provider:ProvidingSameInstance = new SameInstanceProviderMock();
        it.setProviding(provider);

        it.asSingleton();

        assertThat(it.providing, strictlyEqualTo(provider));
    }

    [Test]
    public function asEagerSingleton_invokes_provider_and_specifies_ValueProvider_for_result():void {
        it.setProviding(provider);

        it.asEagerSingleton();
        invokes.assertWasInvokedWith(provider.provide, array(strictlyEqualTo(scope)));
        assertThat(it.providing, instanceOf(ValueProvider));
        assertThat(it.provide(), strictlyEqualTo(provider.lastProvided));

    }

    [Test]
    public function asEagerSingleton_invokes_LazyValueProvider_and_specifies_ValueProvider_for_result():void {
        var evilCase:LazyValueProvider = new LazyValueProvider(provider);
        it.setProviding(evilCase);

        it.asEagerSingleton();
        invokes.assertWasInvokedWith(provider.provide, array(strictlyEqualTo(scope)));
        assertThat(it.providing, instanceOf(ValueProvider));
        assertThat(it.provide(), strictlyEqualTo(provider.lastProvided));

    }

    [Test]
    public function asEagerSingleton_keeps_specified_ValueProvider():void {
        it.setProviding(ProviderMock.Null);

        it.asEagerSingleton();
        assertThat(it.providing, strictlyEqualTo(ProviderMock.Null));
    }

}
}
