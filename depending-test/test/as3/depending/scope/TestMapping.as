package as3.depending.scope {
import as3.depending.Resolver;
import as3.depending.examples.tests.*;
import as3.depending.provider.*;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
import org.hamcrest.Matcher;
import org.hamcrest.collection.*;
import org.hamcrest.core.*;
import org.hamcrest.object.*;

public class TestMapping {

    private var mapping:Mapping;
    private var resolver:Resolver;

    private function get scope():Scope {
        return Scope(resolver);
    }

    private var invokes:Invokes;

    [Before]
    public function setUp():void {
        DependingDefinitionMock.lastInstance = null;
        resolver = new ResolverDummy();
        mapping = new Mapping(IProtocol, resolver);
        invokes = new Invokes();
        DependingDefinitionMock.invokes = invokes;
    }

    [Test]
    public function toType_specifies_TypeProvider():void {
        mapping.toType(ProtocolImpl);

        assertThat(mapping.providing, instanceOf(TypeProvider));
    }

    [Test]
    public function toProvider_on_getValue_uses_provider():void {
        const provider:ProviderMock = new ProviderMock(invokes);
        mapping.toProviding(provider);

        invokes.assertNoInvokes(provider.provide);

        mapping.getValue();

        invokes.assertWasInvokedWith(provider.provide, array(resolver));
    }

    [Test]
    public function toValue_specifies_ValueProvider():void {
        const valueProvider:ProviderZero = mapping.toValue(null);
        assertThat(valueProvider, equalToSpecifiedValueProvider());
    }

    [Test]
    public function toInstance_specifies_ValueProvider():void {
        const valueProvider:ProviderZero = mapping.toInstance(null);
        assertThat(valueProvider, equalToSpecifiedValueProvider());
    }

    private function equalToSpecifiedValueProvider():Matcher {
        return allOf(strictlyEqualTo(mapping.providing), instanceOf(ValueProvider));
    }

    [Test]
    public function toInstance_injects_into_Depending():void {
        var depending:DependingDefinitionMock = new DependingDefinitionMock();
        mapping.toInstance(depending);

        invokes.assertWasInvokedWith(depending.fetchDependencies, array(resolver));
    }

    [Test]
    public function toFactory_specifies_FactoryProvider():void {
        mapping.toFactory(dummy);

        assertThat(mapping.providing, instanceOf(FactoryProvider));
    }

    private function dummy():void {

    }

    [Test]
    public function asEagerSingleton_specifies_ValueProvider():void {
        var providerMock:ProviderMock = new ProviderMock(invokes);

        const valueProvider:ProviderZero = mapping.toProviding(providerMock).asEagerSingleton();
        assertThat(valueProvider, equalToSpecifiedValueProvider());
    }

    [Test]
    public function asSingleton_specifies_TypeProvider_when_provider_is_not_specified():void {
        mapping = new Mapping(ProtocolImpl,resolver);
        mapping.asSingleton();

        assertThat(mapping.getValue(), instanceOf(ProtocolImpl));
    }

    [Test]
    public function asEagerSingleton_specifies_TypeProvider_when_provider_is_not_specified():void {
        mapping = new Mapping(ProtocolImpl,resolver);
        mapping.asEagerSingleton();

        assertThat(mapping.getValue(), instanceOf(ProtocolImpl));
    }

    [Test]
    public function asEagerSingleton_invokes_current_provider():void {
        var providerMock:ProviderMock = new ProviderMock(invokes);

        mapping.toProviding(providerMock).asEagerSingleton();

        invokes.assertWasInvokedWith(providerMock.provide, array(resolver));
    }

    [Test]
    public function asEagerSingleton_invokes_LazyValueProvider():void {
        const providerMock:ProviderMock = new ProviderMock(invokes);
        var evilCase:LazyValueProvider = new LazyValueProvider(providerMock);

        assertThat(mapping.toProviding(evilCase).asEagerSingleton(), equalToSpecifiedValueProvider());

        invokes.assertWasInvokedWith(providerMock.provide, array(resolver));
    }


    [Test]
    public function asEagerSingleton_keeps_specified_ValueProvider():void {
        mapping.toProviding(ProviderMock.Null);

        mapping.asEagerSingleton();

        assertThat(mapping.providing, strictlyEqualTo(ProviderMock.Null));
    }

    [Test]
    public function asSingleton_specifies_LazyValueProvider():void {
        var providerMock:ProviderMock = new ProviderMock(invokes);

        var singletonProvider:SameInstanceProviding = mapping.toProviding(providerMock).asSingleton();

        assertThat(mapping.providing, isA(LazyValueProvider));

        mapping.asSingleton();

        assertThat(mapping.providing, strictlyEqualTo(singletonProvider));
    }

    [Test]
    public function asSingleton_keeps_specified_SameInstanceProvider():void {
        var provider:SameInstanceProviding = new SameInstanceProviderMock();
        mapping.toProviding(provider);

        mapping.asSingleton();

        assertThat(mapping.providing, strictlyEqualTo(provider));
    }


    [Test]
    public function toProvider_specifies_when_resolver_is_Scope():void {
        resolver = new TestableScope(invokes);
        mapping = new Mapping(ProtocolImpl, scope);
//        invokes.assertNoInvokes(scope.specify);

        const provider:ProviderMock = new ProviderMock();
        mapping.toProviding(provider);

        invokes.assertWasInvokedWith(scope.specify, anything(), array(ProtocolImpl, provider))
    }


}
}
