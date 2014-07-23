package as3.depending.provider {
import as3.depending.Resolver;
import as3.depending.examples.tests.Instance;
import as3.depending.scope.impl.Invokes;
import as3.depending.scope.impl.ResolverDummy;

import org.flexunit.assertThat;
import org.flexunit.asserts.fail;
import org.hamcrest.core.throws;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class Test_invokeProvider {

    public static var shouldProvide:*;

    private var invokes:Invokes;
    private var resolver:Resolver;

    [Before]
    public function setUp():void {
        invokes = new Invokes();
        resolver = new ResolverDummy();
        shouldProvide = undefined;
    }

    [Test]
    public function invokeProvider_returns_a_typed_value():void {
        function providerThatReturnsUndefined():* {
            //this is not conform to the spec, but we can not enforce it on functions without any interface contract
            return undefined;
        }
        //so we make sure that at least the result we get from invokeProvider conforms with the standard
        //by converting the undefined to null, because the provider didn't throw and ActionScript would also convert
        var result:* = invokeProvider(providerThatReturnsUndefined, null);
        if(result === undefined){
            //when this fails the return type of invokeProvider has been changed to * change it back to Object
            //read the above comments for why this test exists
            fail("invokeProvider needs to return a typed value");
        }
    }

    [Test]
    public function invokeProvider_first_argument_can_NOT_be_an_Object():void {
        assertThat(
                function ():void {
                    invokeProvider({}, null);
                },
                throws(instanceOf(TypeError))
        );
    }

    [Test]
    public function invokeProvider_first_argument_can_NOT_be_null():void {
        assertThat(
                function ():void {
                    invokeProvider(null, null);
                },
                throws(instanceOf(TypeError))
        );
    }



    private function expectingProviderFunction(expected:Resolver):Object {
        invokes.invoke(expectingProviderFunction, expected);
        return shouldProvide;
    }

    [Test]
    public function a_provider_is_a_function_that_can_expect_a_resolver_as_first_argument():void {
        invokeProvider(expectingProviderFunction, resolver);
        invokes.assertWasInvokedWith(expectingProviderFunction, [resolver]);
    }

    [Test]
    public function for_a_provider_that_expects_a_resolver_resolver_is_a_required_argument():void {
        assertThat(
                function ():void {
                    invokeProvider(expectingProviderFunction, null);
                },
                throws(instanceOf(ArgumentError))
        );
        invokes.assertNoInvokes(expectingProviderFunction);
    }

    [Test]
    public function invoking_with_a_provider_that_expects_a_resolver_returns_a_value():void {
        shouldProvide = new Instance();
        assertThat(invokeProvider(expectingProviderFunction, resolver), strictlyEqualTo(shouldProvide));
    }

    private function expectingProviderFunctionThrowing(expected:Resolver):Object {
        invokes.invoke(expectingProviderFunctionThrowing, expected);
        throw new CustomError();
    }
    [Test]
    public function a_provider_that_expects_a_resolver_must_not_catch_errors():void {
        assertThat(
                function ():void {
                    invokeProvider(expectingProviderFunctionThrowing, resolver);
                },
                throws(instanceOf(CustomError))
        );
        invokes.assertInvokes(expectingProviderFunctionThrowing, 1);
    }

    private function providerZeroFunction():Object {
        invokes.invoke(providerZeroFunction);
        return shouldProvide;
    }


    [Test]
    public function a_provider_is_a_function_that_expects_zero_arguments():void {
        invokeProvider(providerZeroFunction, resolver);
        invokes.assertWasInvokedWith(providerZeroFunction, []);
    }

    [Test]
    public function for_a_provider_that_expects_zero_arguments_resolver_is_NOT_a_required_argument():void {
        invokeProvider(providerZeroFunction, null);
        invokes.assertWasInvokedWith(providerZeroFunction, []);
    }

    [Test]
    public function invoking_with_a_provider_that_expects_zero_arguments_returns_a_value():void {
        shouldProvide = new Instance();
        assertThat(invokeProvider(providerZeroFunction, null), strictlyEqualTo(shouldProvide));
    }

    private function providerZeroFunctionThrowing():Object {
        invokes.invoke(providerZeroFunctionThrowing);
        throw new CustomError();
    }
    [Test]
    public function a_provider_that_expects_zero_arguments_must_not_catch_errors():void {
        assertThat(
                function ():void {
                    invokeProvider(providerZeroFunctionThrowing, null);
                },
                throws(instanceOf(CustomError))
        );
        invokes.assertInvokes(providerZeroFunctionThrowing, 1);
    }
    private var providerZero:ProviderZeroMock;


    [Test]
    public function provider_can_be_a_Providing_that_expects_zero_arguments():void {
        providerZero = new ProviderZeroMock(invokes);
        invokeProvider(providerZero, resolver);
        invokes.assertWasInvokedWith(providerZero.provide, []);
    }

    [Test]
    public function for_a_Providing_that_expects_zero_arguments_resolver_is_NOT_a_required_argument():void {
        providerZero = new ProviderZeroMock(invokes);
        invokeProvider(providerZero, null);
        invokes.assertWasInvokedWith(providerZero.provide, []);
    }

    [Test]
    public function invoking_with_a_Providing_that_expects_zero_arguments_returns_a_value():void {
        providerZero = new ProviderZeroMock(invokes);
        shouldProvide = new Instance();
        assertThat(invokeProvider(providerZero, null), strictlyEqualTo(shouldProvide));
    }

    [Test]
    public function a_Providing_that_expects_zero_arguments_must_not_catch_errors():void {
        providerZero = new ProviderZeroMockThrowing(invokes);
        assertThat(
                function ():void {
                    invokeProvider(providerZero, null);
                },
                throws(instanceOf(CustomError))
        );
        invokes.assertInvokes(providerZero.provide, 1);
    }


    private var providerExpecting:ProviderExpectingMock;

    [Test]
    public function provider_can_be_a_Providing_that_expects_a_resolver():void {
        providerExpecting = new ProviderExpectingMock(invokes);
        invokeProvider(providerExpecting, resolver);
        invokes.assertWasInvokedWith(providerExpecting.provide, [resolver]);
    }

    [Test]
    public function for_a_Providing_that_expects_a_resolver_resolver_is_a_required_argument():void {
        providerExpecting = new ProviderExpectingMock(invokes);
        assertThat(
                function ():void {
                    invokeProvider(providerExpecting, null);
                },
                throws(instanceOf(ArgumentError))
        );
        invokes.assertNoInvokes(providerExpecting.provide);
    }

    [Test]
    public function invoking_with_a_Providing_that_expects_a_resolver_returns_a_value():void {
        providerExpecting = new ProviderExpectingMock(invokes);
        shouldProvide = new Instance();
        assertThat(invokeProvider(providerExpecting, resolver), strictlyEqualTo(shouldProvide));
    }

    [Test]
    public function a_Providing_that_expects_a_resolver_must_not_catch_errors():void {
        providerExpecting = new ProviderExpectingMockThrowing(invokes);
        assertThat(
                function ():void {
                    invokeProvider(providerExpecting, resolver);
                },
                throws(instanceOf(CustomError))
        );
        invokes.assertInvokes(providerExpecting.provide, 1);
    }

    private var providerLegacy:ProviderMock;

    [Test]
    public function provider_can_be_a_Provider():void {
        providerLegacy = new ProviderMock(invokes);
        invokeProvider(providerLegacy, resolver);
        invokes.assertWasInvokedWith(providerLegacy.provide, [resolver]);
    }

    [Test]
    public function for_a_Provider_resolver_is_a_required_argument():void {
        providerLegacy = new ProviderMock(invokes);
        assertThat(
                function ():void {
                    invokeProvider(providerLegacy, null);
                },
                throws(instanceOf(ArgumentError))
        );
        invokes.assertNoInvokes(providerLegacy.provide);
    }

    [Test]
    public function invoking_with_a_Provider_returns_a_value():void {
        providerLegacy = new ProviderMock(invokes);
        assertThat(invokeProvider(providerLegacy, resolver), strictlyEqualTo(providerLegacy.lastProvided));
    }

    [Test]
    public function a_Provider_must_not_catch_errors():void {
        providerLegacy = ProviderMock.Failing(invokes);
        assertThat(
                function ():void {
                    invokeProvider(providerLegacy, resolver);
                },
                throws(instanceOf(CustomError))
        );
        invokes.assertInvokes(providerLegacy.provide, 1);
    }
}
}

import as3.depending.Resolver;
import as3.depending.provider.CustomError;
import as3.depending.provider.ProviderExpecting;
import as3.depending.provider.ProviderZero;
import as3.depending.provider.Test_invokeProvider;
import as3.depending.scope.impl.Invokes;

class ProviderZeroMock implements ProviderZero{
    private var _invokes:Invokes;
    public function ProviderZeroMock(invokes:Invokes) {
        _invokes = invokes;
    }

    public function provide():Object {
        _invokes.invoke(provide);
        return Test_invokeProvider.shouldProvide;
    }
}
class ProviderZeroMockThrowing extends ProviderZeroMock{

    function ProviderZeroMockThrowing(invokes:Invokes) {
        super(invokes);
    }

    override public function provide():Object {
        super.provide();
        throw new CustomError();
    }
}

class ProviderExpectingMock implements ProviderExpecting{
    private var _invokes:Invokes;

    public function ProviderExpectingMock(invokes:Invokes) {
        _invokes = invokes;
    }

    public function provide(resolver:Resolver):Object {
        _invokes.invoke(provide, resolver);
        return Test_invokeProvider.shouldProvide;
    }
}
class ProviderExpectingMockThrowing extends ProviderExpectingMock{

    function ProviderExpectingMockThrowing(invokes:Invokes) {
        super(invokes);
    }

    override public function provide(resolver:Resolver):Object {
        super.provide(resolver);
        throw new CustomError();
    }
}
