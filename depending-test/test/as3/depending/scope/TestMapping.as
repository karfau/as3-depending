package as3.depending.scope {
import as3.depending.Resolver;
import as3.depending.examples.tests.*;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertNull;
import org.hamcrest.collection.*;
import org.hamcrest.core.*;
import org.hamcrest.object.*;

public class TestMapping {

    private var mapping:Mapping;
    private var resolver:Resolver;
    private var invokes:Invokes;

    [Before]
    public function setUp():void {
        DependingDefinitionMock.lastInstance = null;
        resolver = new ResolverMock();
        mapping = new Mapping(IProtocol, resolver);
        invokes = new Invokes();
        DependingDefinitionMock.invokes = invokes;
    }

    [Test]
    public function getValue_defines_TypeProvider_when_provider_is_not_defined():void {
        mapping = new Mapping(ProtocolImpl, resolver);

        assertNull(mapping.provider);

        mapping.getValue();

        assertThat(mapping.provider, instanceOf(TypeProvider));
    }

    [Test]
    public function toType_defines_TypeProvider():void {
        mapping.toType(ProtocolImpl);

        assertThat(mapping.provider, instanceOf(TypeProvider));
    }

    [Test]
    public function toProvider_on_getValue_uses_provider():void {
        const provider:ProviderMock = new ProviderMock(invokes);
        mapping.toProvider(provider);

        invokes.assertNoInvokes(provider.provide);

        mapping.getValue();

        invokes.assertWasInvokedWith(provider.provide, array(resolver));
    }

    [Test]
    public function toValue_defines_ValueProvider():void {
        mapping.toValue(null);

        assertThat(mapping.provider, isA(ValueProvider));
    }

    [Test]
    public function toInstance_defines_ValueProvider():void {
        mapping.toInstance(null);

        assertThat(mapping.provider, isA(ValueProvider));
    }

    [Test]
    public function toInstance_injects_into_Depending():void {
        var depending:DependingDefinitionMock = new DependingDefinitionMock();
        mapping.toInstance(depending);

        invokes.assertWasInvokedWith(depending.fetchDependencies, array(resolver));
    }

    [Test]
    public function toFactory_defines_FactoryProvider():void {
        mapping.toFactory(null);

        assertThat(mapping.provider, instanceOf(FactoryProvider));
    }

    [Test]
    public function asEagerSingleton_defines_ValueProvider():void {
        var providerMock:ProviderMock = new ProviderMock(invokes);

        mapping.toProvider(providerMock).asEagerSingleton();

        assertThat(mapping.provider, isA(ValueProvider));
    }

    [Test]
    public function asEagerSingleton_invokes_current_provider():void {
        var providerMock:ProviderMock = new ProviderMock(invokes);

        mapping.toProvider(providerMock).asEagerSingleton();

        invokes.assertWasInvokedWith(providerMock.provide, array(resolver));
    }


    [Test]
    public function asEagerSingleton_keeps_defined_ValueProvider():void {
        mapping.toInstance(null);

        var valueProvider:ValueProvider = ValueProvider(mapping.provider);

        mapping.asEagerSingleton();

        assertThat(mapping.provider, strictlyEqualTo(valueProvider));
    }

    [Test]
    public function asSingleton_defines_LazyValueProvider():void {
        var providerMock:ProviderMock = new ProviderMock(invokes);

        mapping.toProvider(providerMock).asSingleton();

        assertThat(mapping.provider, isA(LazyValueProvider));
    }

    [Test]
    public function asSingleton_keeps_defined_ValueProvider():void {
        mapping.toInstance(null);

        var valueProvider:ValueProvider = ValueProvider(mapping.provider);

        mapping.asSingleton();

        assertThat(mapping.provider, strictlyEqualTo(valueProvider));
    }

}
}
