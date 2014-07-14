package as3.depending.spec {
import as3.depending.examples.tests.ConstructorInjectableProtocol;
import as3.depending.examples.tests.IProtocol;
import as3.depending.examples.tests.Instance;
import as3.depending.examples.tests.ProtocolImpl;
import as3.depending.examples.tests.ProtocolProvider;
import as3.depending.examples.tests.ProtocolProviderFunctions;

import org.flexunit.assertThat;
import org.hamcrest.core.allOf;
import org.hamcrest.object.hasPropertyWithValue;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class RelaxedResolverInstanceCreation extends ResolverInstanceCreation {


    [Before]
    override public function setUpResolver():void {
        super.setUpResolver();
        assertRelaxedResolver();
    }

    [Test]
    public function resolving_a_defined_type_optionally():void {
        adapter.defineTypeForResolver(Instance);
        assertThat(relaxedResolver.optionally(Instance), instanceOf(Instance));
    }

    [Test]
    public function resolving_an_implementation_optionally():void {
        adapter.definedImplementationForResolver(IProtocol, ProtocolImpl);
        assertThat(relaxedResolver.optionally(IProtocol), instanceOf(ProtocolImpl));
    }

    [Test]
    public function resolving_an_implementing_instance_optionally():void {
        const instance:ProtocolImpl = new ProtocolImpl();
        adapter.defineAnImplementingInstanceForResolver(IProtocol, instance);
        assertThat(relaxedResolver.optionally(IProtocol), strictlyEqualTo(instance));
    }

    [Test]
    public function resolving_using_a_provider_implementation_optionally():void {
        const provider:ProtocolProvider = new ProtocolProvider();
        adapter.defineAProviderImplementationForResolver(IProtocol, provider);
        assertThat(relaxedResolver.optionally(IProtocol), instanceOf(ProtocolImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_no_arguments_optionally():void {
        adapter.defineAProviderFunctionForResolver(IProtocol, ProtocolProviderFunctions.DefinitionProvider);
        assertThat(relaxedResolver.optionally(IProtocol), instanceOf(ProtocolImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_resolver_as_argument_optionally():void {
        adapter.defineAProviderFunctionForResolver(IProtocol, ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
        assertThat(relaxedResolver.optionally(IProtocol), allOf(
                instanceOf(ConstructorInjectableProtocol),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
    }

    //TODO: define things without the need to provide a type for it, they already implement it (Scope has no support for this yet)

}
}
