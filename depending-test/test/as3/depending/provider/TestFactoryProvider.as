package as3.depending.provider {
import as3.depending.Resolver;
import as3.depending.examples.tests.Instance;
import as3.depending.scope.impl.Invokes;
import as3.depending.scope.impl.ResolverDummy;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertTrue;
import org.flexunit.asserts.fail;
import org.hamcrest.collection.array;
import org.hamcrest.core.describedAs;
import org.hamcrest.core.throws;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class TestFactoryProvider {

    //noinspection JSFieldCanBeLocal
    private var provider:FactoryProvider;
    private var resolver:Resolver;
    private var invokes:Invokes;

    [Before]
    public function setUp():void {
        resolver = new ResolverDummy();
        invokes = new Invokes();
    }

    [After]
    public function tearDown():void {
        provider = null;
    }

    [Test(expects="ArgumentError")]
    public function creation_fails_without_factory():void {
        provider = new FactoryProvider(null);
    }

    [Test]
    public function creation_fails_for_factory_with_two_arguments_parameters_count_mismatch():void {
        var factory:Function = invokes.twoParameters;
        assertCreationFails(factory, null);
        assertCreationFails(factory, []);
        assertCreationFails(factory, [1]);
        assertCreationFails(factory, [1, 2, 3]);
        invokes.assertNoInvokes(factory);
    }

    [Test]
    public function creation_fails_for_factory_with_one_argument_parameters_count_mismatch():void {
        var factory:Function = invokes.oneParameter;
        assertCreationFails(factory, [1, 2]);
        assertCreationFails(factory, [1, 2, 3]);
        invokes.assertNoInvokes(factory);
    }

    private function assertCreationFails(factory:Function, parameters:Array):void {
        assertThat(function ():void {
            new FactoryProvider(factory, parameters);
        }, describedAs("creation to fail when factory has %0 arguments,\n and parameters is %1",
                throws(instanceOf(ArgumentError)),
                factory.length, parameters
        ));
    }
    private function notCalled(...args):void{
        fail("should not be called but was called with ["+args.join(', ')+"]");
    }

    [Test]
    public function argumentList_null():void {
        assertTrue(FactoryProvider.argumentList(resolver, null, notCalled)===null);
    }
    [Test]
    public function argumentList_empty():void {
        const params:Array = [];
        assertTrue(FactoryProvider.argumentList(resolver, params, notCalled)===params);
    }
    [Test]
    public function argumentList_uses_parameterMapper():void {
        var instance:Instance = new Instance();
        assertThat(
                FactoryProvider.argumentList(resolver, [null, Resolver, instance], parameterMapper),
                array(
                        strictlyEqualTo("null"),
                        strictlyEqualTo(Object(Resolver).toString()),
                        strictlyEqualTo(instance.toString())
                ));
        invokes.assertWasInvokedWith(parameterMapper,
                array(resolver, null),
                array(resolver, Resolver),
                array(resolver, instance)
        );

    }
    private function parameterMapper(resolver:Resolver, identifier:Object):* {
        invokes.invoke(parameterMapper, resolver, identifier);
        return identifier == null ? "null" : identifier.toString();
    }


    [Test]
    public function provide_uses_argumentList_to_replace_Resolver():void {
        provider = new FactoryProvider(invokes.oneParameter, [Resolver]);
        provider.provide(resolver);
        invokes.assertWasInvokedWith(invokes.oneParameter, array(resolver));
    }

    [Test]
    public function provide_uses_argumentList_to_replace_ResolverDummy_in_list():void {
        var instance:Instance = new Instance();
        provider = new FactoryProvider(invokes.variableParameters, [instance, ResolverDummy, Instance, null]);
        provider.provide(resolver);
        invokes.assertWasInvokedWith(invokes.variableParameters, array(
                strictlyEqualTo(instance),
                strictlyEqualTo(resolver),
                strictlyEqualTo(Instance),
                strictlyEqualTo(null)
        ));
    }

    [Test]
    public function provide_with_factory_without_parameters():void {
        const factory:Function = invokes.noParameters;
        provider = new FactoryProvider(factory);

        invokes.assertNoInvokes(factory);

        provider.provide(null);
        invokes.assertWasInvokedWith(factory, array());

        provider.provide(null);
        invokes.assertWasInvokedWith(factory, array(), array());
    }

    [Test]
    public function provide_with_factory_like_provider():void {
        const factory:Function = invokes.oneParameter;
        provider = new FactoryProvider(factory);

        invokes.assertNoInvokes(factory);

        provider.provide(resolver);
        invokes.assertWasInvokedWith(factory, array(resolver));

        provider.provide(resolver);
        invokes.assertWasInvokedWith(factory, array(resolver), array(resolver));
    }

    [Test]
    public function provide_with_factory_with_one_specified_parameter():void {
        const factory:Function = invokes.oneParameter;
        const parameter:Instance = new Instance();
        provider = new FactoryProvider(factory,[parameter]);

        invokes.assertNoInvokes(factory);

        provider.provide(resolver);
        invokes.assertWasInvokedWith(factory, array(parameter));

        provider.provide(resolver);
        invokes.assertWasInvokedWith(factory, array(parameter), array(parameter));
    }

    [Test]
    public function provide_with_variable_factory_with_two_specified_parameters_is_not_adding_resolver():void {
        const factory:Function = invokes.variableParameters;
        const parameters:Array = [new Instance(),"first",2];
        provider = new FactoryProvider(factory, parameters);

        invokes.assertNoInvokes(factory);

        provider.provide(resolver);
        invokes.assertWasInvokedWith(factory, array(parameters));

        provider.provide(resolver);
        invokes.assertWasInvokedWith(factory, array(parameters), array(parameters));
    }

}
}
