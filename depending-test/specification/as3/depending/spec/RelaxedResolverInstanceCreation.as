package as3.depending.spec {
import as3.depending.examples.tests.*;

import org.flexunit.assertThat;
import org.hamcrest.core.allOf;
import org.hamcrest.object.*;

public class RelaxedResolverInstanceCreation extends ResolverInstanceCreation {

    [Test]
    public function resolving_a_specified_type_optionally():void {
        adapter.specifyTypeForResolver(Instance);
        assertThat(relaxedResolver.optionally(Instance), instanceOf(Instance));
        extendedAsserts(Instance)
    }

    [Test]
    public function resolving_an_implementation_optionally():void {
        adapter.specifyImplementationForResolver(IProtocol, ProtocolImpl);
        assertThat(relaxedResolver.optionally(IProtocol), instanceOf(ProtocolImpl));
        extendedAsserts(IProtocol);
    }

    [Test]
    public function resolving_using_a_provider_implementation_optionally():void {
        const provider:ProtocolProvider = new ProtocolProvider();
        adapter.specifyAProviderForResolver(IProtocol, provider);
        assertThat(relaxedResolver.optionally(IProtocol), instanceOf(ProtocolImpl));
        extendedAsserts(IProtocol);
    }

    [Test]
    public function resolving_using_a_provider_function_with_no_arguments_optionally():void {
        adapter.specifyAProviderFunctionForResolver(IProtocol, ProtocolProviderFunctions.DefinitionProvider);
        assertThat(relaxedResolver.optionally(IProtocol), instanceOf(ProtocolImpl));
        extendedAsserts(IProtocol);
    }

    [Test]
    public function resolving_using_a_provider_function_with_resolver_as_argument_optionally():void {
        adapter.specifyAProviderFunctionForResolver(IProtocol, ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
        assertThat(relaxedResolver.optionally(IProtocol), allOf(
                instanceOf(ConstructorInjectableProtocol),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
        extendedAsserts(IProtocol);
    }

}
}
