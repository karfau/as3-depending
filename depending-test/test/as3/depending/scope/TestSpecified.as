package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.examples.tests.Instance;
import as3.depending.provider.ProviderMock;
import as3.depending.scope.impl.Invokes;

import org.flexunit.assertThat;

import org.hamcrest.collection.array;
import org.hamcrest.object.instanceOf;

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
}
}
