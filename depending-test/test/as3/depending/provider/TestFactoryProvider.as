package as3.depending.provider {
import as3.depending.examples.tests.Instance;
import as3.depending.scope.impl.Invokes;
import as3.depending.scope.impl.ResolverDummy;

import org.hamcrest.collection.array;

public class TestFactoryProvider {

    //noinspection JSFieldCanBeLocal
    private var provider:FactoryProvider;
    private var resolver:ResolverDummy;
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

    [Test]
    public function provide_with_factory_without_parameters():void {
        const factory:Function = invokes.noParameters;
        provider = new FactoryProvider(factory);

        invokes.assertNoInvokes(factory);

        provider.provide();
        invokes.assertWasInvokedWith(factory, array());

        provider.provide();
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
