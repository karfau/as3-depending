package as3.depending.provider {
import as3.depending.Resolver;
import as3.depending.examples.tests.Instance;
import as3.depending.scope.impl.Invokes;
import as3.depending.scope.impl.ResolverDummy;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.core.throws;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class Test_invokeProvider {

    public static var shouldProvide:*;
    public static var wasProvided:*;

    private var invokes:Invokes;
    private var resolver:Resolver;

    [Before]
    public function setUp():void {
        invokes = new Invokes();
        resolver = new ResolverDummy();
        shouldProvide = new Instance();
        wasProvided = undefined;
    }

    private function expectingProviderFunction(expected:Resolver):Object {
        invokes.invoke(expectingProviderFunction, expected);
        if (shouldProvide is Error) {
            throw shouldProvide;
        }
        wasProvided = shouldProvide;
        return wasProvided;
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
    public function a_provider_that_expects_a_resolver_returns_a_value_not_undefined():void {
        shouldProvide = undefined;
        var result:* = invokeProvider(expectingProviderFunction, resolver);
        assertTrue("invokeProvider did return <" + result + "> instead of the provided value <" + wasProvided + ">", result === null);
    }

    [Test]
    public function a_provider_that_expects_a_resolver_returns_a_value():void {
        assertThat(invokeProvider(expectingProviderFunction, resolver), strictlyEqualTo(wasProvided));
    }

    [Test(expects="as3.depending.provider.CustomError")]
    public function a_provider_that_expects_a_resolver_must_not_catch_errors():void {
        shouldProvide = new CustomError();
        invokeProvider(expectingProviderFunction, resolver);
    }

}
}
