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

public class ResolverInstanceCreation extends BaseResolverSpec {

    [Test]
    public function resolving_a_specified_type():void {
        adapter.specifyTypeForResolver(Instance);
        extendedAsserts(Instance);
        assertThat(resolver.get(Instance), instanceOf(Instance));
    }

    [Test]
    public function resolving_an_implementation():void {
        adapter.specifyImplementationForResolver(IProtocol, ProtocolImpl);
        extendedAsserts(IProtocol);
        assertThat(resolver.get(IProtocol), instanceOf(ProtocolImpl));
    }

    [Test]
    public function resolving_using_a_provider_implementation():void {
        const provider:ProtocolProvider = new ProtocolProvider();
        adapter.specifyAProviderForResolver(IProtocol, provider);
        extendedAsserts(IProtocol);
        assertThat(resolver.get(IProtocol), instanceOf(ProtocolImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_no_arguments():void {
        adapter.specifyAProviderFunctionForResolver(IProtocol, ProtocolProviderFunctions.DefinitionProvider);
        extendedAsserts(IProtocol);
        assertThat(resolver.get(IProtocol), instanceOf(ProtocolImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_resolver_as_argument():void {
        adapter.specifyAProviderFunctionForResolver(IProtocol, ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
        extendedAsserts(IProtocol);
        assertThat(resolver.get(IProtocol), allOf(
                instanceOf(ConstructorInjectableProtocol),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
    }

    protected function extendedAsserts(identifier:Class):void {

    }
}
}
