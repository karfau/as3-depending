package as3.depending.scope {
import as3.depending.scope.impl.Invokes;
import as3.depending.scope.impl.ProviderMock;
import as3.depending.scope.impl.ResolverMock;

import org.flexunit.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.strictlyEqualTo;

public class TestLazyValueProvider {

    private var provider:LazyValueProvider;
    private var contained:ProviderMock;
    private var invokes:Invokes;
    private var resolver:ResolverMock;

    [Before]
    public function setUp():void {
        invokes = new Invokes();
        contained = new ProviderMock(invokes);
        provider = new LazyValueProvider(contained);
        resolver = new ResolverMock()
    }

    [Test]
    public function creation_does_not_invoke_contained_provider():void {
        invokes.assertNoInvokes(contained.provide);
    }

    [Test]
    public function provide_delegates_to_contained_provider():void {
        provider.provide(resolver);
        invokes.assertWasInvokedWith(contained.provide, array(resolver));
    }

    [Test]
    public function provide_returns_singleton():void {
        const first:Object = provider.provide();
        assertThat(provider.provide(), strictlyEqualTo(first));
        invokes.assertInvokes(contained.provide, 1);
    }

}
}
