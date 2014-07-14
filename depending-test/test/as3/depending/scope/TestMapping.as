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
    public function getValue_returns_new_instance_of_mapped_type():void {
        mapping = new Mapping(ProtocolImpl, resolver);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                instanceOf(ProtocolImpl),
                not(equalTo(mapping.getValue()))
        ));
    }

    [Test]
    public function toType_on_getValue_returns_new_instance():void {
        mapping.toType(ProtocolImpl);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                instanceOf(ProtocolImpl),
                not(equalTo(mapping.getValue()))
        ));
    }

    [Test]
    public function toProvider_on_getValue_uses_provider():void {
        const provider:ProviderMock = new ProviderMock();
        mapping.toProvider(provider);

        mapping.getValue();

        assertThat(provider.callsTo_provide, 1);
    }

    private function factoryMethodVarArgs(...args):*{
        invokes.invoke(factoryMethodVarArgs, args);
        return undefined;
    }

    [Test]
    public function toFactory_withArgument_on_getValue_calls_factory_method():void {

        mapping.toFactory(factoryMethodVarArgs,"first",2);

        mapping.getValue();

        invokes.assertInvokes(factoryMethodVarArgs,
                array("first",2)
        );
    }


    [Test]
    public function getValue_uses_resolver_to_inject_to_provided_Depending_instance():void {
        mapping.toType(DependingDefinitionMock);

        var value:DependingDefinitionMock = DependingDefinitionMock(mapping.getValue());

        assertSingleInvokeOf_fetchDependencies_on(value);
    }

    [Test]
    public function asEagerSingleton_uses_resolver_to_inject_to_provided_Depending_instance():void {
        mapping.toType(DependingDefinitionMock).asEagerSingleton();
        assert_asEagerSingleton();
    }

    [Test]
    public function asSingleton_lazy_on_getValue_uses_resolver_to_inject_to_provided_Depending_instance():void {
        mapping.toType(DependingDefinitionMock).asSingleton();

        assertNull(DependingDefinitionMock.lastInstance);

        var value:DependingDefinitionMock = DependingDefinitionMock(mapping.getValue());

        assertThat(value, strictlyEqualTo(mapping.getValue()));
        assertSingleInvokeOf_fetchDependencies_on(value);
    }

    private function assert_asEagerSingleton():void {
        invokes.assertInvokes(DependingDefinitionMock.lastInstance.fetchDependencies,
                array(strictlyEqualTo(mapping.resolver))
        );

        var value:DependingDefinitionMock = DependingDefinitionMock(mapping.getValue());


        assertThat(value, strictlyEqualTo(mapping.getValue()));
        assertSingleInvokeOf_fetchDependencies_on(value);
    }


    private function assertSingleInvokeOf_fetchDependencies_on(value:DependingDefinitionMock):void {
        invokes.assertInvokes(value.fetchDependencies,
                array(strictlyEqualTo(mapping.resolver))
        );
    }



}
}
