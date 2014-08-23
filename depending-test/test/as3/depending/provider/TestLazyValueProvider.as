package as3.depending.provider {
import as3.depending.examples.tests.Instance;
import as3.depending.scope.impl.Invokes;
import as3.depending.scope.impl.ResolverDummy;

import org.flexunit.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;

public class TestLazyValueProvider {

    private var provider:LazyValueProvider;
    private var contained:ProviderMock;
    private var invokes:Invokes;
    private var resolver:ResolverDummy;

    [Before]
    public function setUp():void {
        invokes = new Invokes();
        contained = new ProviderMock(invokes);
        provider = new LazyValueProvider(contained);
        resolver = new ResolverDummy();
    }

    [Test]
    public function creation_does_not_invoke_contained_provider():void {
        invokes.assertNoInvokes(contained.provide);
    }

    [Test(expects="ArgumentError")]
    public function creation_fails_without_provider():void {
        provider = new LazyValueProvider(null);
    }

    [Test]
    public function provide_delegates_to_contained_provider():void {
        provider.provide(resolver);
        invokes.assertWasInvokedWith(contained.provide, array(resolver));
    }

    [Test]
    public function provide_returns_singleton():void {
        const first:Object = provider.provide(resolver);
        assertThat(provider.provide(null), strictlyEqualTo(first));
        invokes.assertInvokes(contained.provide, 1);
    }

    [Test]
    public function type_is_fetched_from_ProvidingTyped():void {
        provider = new LazyValueProvider(new TypeProvider(Instance));
        assertThat(provider.type, strictlyEqualTo(Instance));
    }

    [Test]
    public function type_is_fetched_from_value_after_provide():void {
        provider = new LazyValueProvider(new FactoryProvider(createInstance));
        assertThat(provider.type, nullValue());
        provider.provide(resolver);
        assertThat(provider.type, strictlyEqualTo(Instance));
    }

    private function createInstance():Instance {
        return new Instance();
    }
}
}
