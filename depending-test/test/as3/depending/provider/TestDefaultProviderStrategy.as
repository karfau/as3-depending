package as3.depending.provider {
import as3.depending.Provider;
import as3.depending.examples.tests.*;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
import org.hamcrest.object.*;

public class TestDefaultProviderStrategy {

    private var strategy:DefaultProviderStrategy;

    [Before]
    public function setUp():void {
        strategy = new DefaultProviderStrategy();
    }

    [Test]
    public function creates_ValueProvider_for_null():void {
        const value:Object = null;
        const provider:Provider = strategy.createProviderFor(value);
        assertThat(provider, instanceOf(ValueProvider));
        assertThat(provider.provide(), strictlyEqualTo(value));
    }

    [Test]
    public function creates_ValueProvider_for_instance():void {
        const value:Instance = new Instance();
        const provider:Provider = strategy.createProviderFor(value);
        assertThat(provider, instanceOf(ValueProvider));
        assertThat(provider.provide(), strictlyEqualTo(value));
    }

    [Test]
    public function creates_TypeProvider_for_Class_value():void {
        const provider:Provider = strategy.createProviderFor(Instance);
        assertThat(provider, instanceOf(TypeProvider));
        assertThat(provider.provide(), instanceOf(Instance));
    }

    [Test]
    public function creates_FactoryProvider_for_Function_value():void {
        var invoke:Invokes = new Invokes();
        const provider:Provider = strategy.createProviderFor(invoke.noParameters);
        assertThat(provider, instanceOf(FactoryProvider));
        invoke.assertNoInvokes(invoke.noParameters);
        provider.provide();
        invoke.assertInvokes(invoke.noParameters, 1)
    }

}
}
