package as3.depending.scope {
import as3.depending.examples.tests.*;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
import org.hamcrest.collection.*;
import org.hamcrest.core.*;
import org.hamcrest.object.*;

public class TestMapping {

    private var mapping:Mapping;

    [Before]
    public function setUp():void {
        mapping = new Mapping(IDefinition);
        callsTo_factoryMethod = [];
    }


    [Test]
    public function getValue_returns_new_instance_of_mapped_type():void {
        mapping = new Mapping(DefinitionImpl);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                isA(DefinitionImpl),
                not(equalTo(mapping.getValue()))
        ));
    }

    [Test]
    public function toType_on_getValue_returns_new_instance():void {
        mapping.toType(DefinitionImpl);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                isA(DefinitionImpl),
                not(equalTo(mapping.getValue()))
        ));
    }

    [Test]
    public function toInstance_on_getValue_returns_instance():void {
        const singleton:IDefinition = new DefinitionImpl();
        mapping.toInstance(singleton);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                strictlyEqualTo(singleton),
                strictlyEqualTo(mapping.getValue())
        ));
    }

    [Test]
    public function toProvider_on_getValue_uses_provider():void {
        const provider:ProviderMock = new ProviderMock();
        mapping.toProvider(provider);

        mapping.getValue();

        assertThat(provider.callsTo_provide, 1);
    }

    private var callsTo_factoryMethod:Array;
    private function factoryMethodNoArgs():*{
        callsTo_factoryMethod.push([]);
        return undefined;
    }

    private function factoryMethodOneArgs(obj:Object):*{
        callsTo_factoryMethod.push([obj]);
        return undefined;
    }

    private function factoryMethodVarArgs(...args):*{
        callsTo_factoryMethod.push(args);
        return undefined;
    }

    [Test]
    public function toFactory_no_given_argument_but_with_length_1_on_getValue_calls_factory_method_with_resolver():void {
        mapping.resolver = new ResolverMock();
        mapping.toFactory(factoryMethodOneArgs);

        mapping.getValue();

        assertThat(callsTo_factoryMethod, array(array(mapping.resolver)));
    }

    [Test]
    public function toFactory_withNoArgument_on_getValue_calls_factory_method():void {

        mapping.toFactory(factoryMethodNoArgs);

        mapping.getValue();

        assertThat(callsTo_factoryMethod, array(array()));
    }

    [Test]
    public function toFactory_withArgument_on_getValue_calls_factory_method():void {

        mapping.toFactory(factoryMethodVarArgs,"first",2);

        mapping.getValue();

        assertThat(callsTo_factoryMethod, array(array("first",2)));
    }


    [Test]
    public function getValue_uses_resolver_to_inject_to_provided_Depending_instance():void {
        mapping.resolver = new ResolverMock();
        mapping.toType(DependingDefinitionMock);

        var value:DependingDefinitionMock = DependingDefinitionMock(mapping.getValue());

        assertThat(value.callsTo_fetchDependencies, array(
                array(strictlyEqualTo(mapping.resolver))
        ));
    }
}
}
