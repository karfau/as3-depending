package as3.depending.spec {
import as3.depending.examples.tests.DefinitionImpl;
import as3.depending.examples.tests.DefinitionProvider;
import as3.depending.examples.tests.IDefinition;
import as3.depending.examples.tests.Independent;
import as3.depending.examples.tests.ProviderFunctions;
import as3.depending.examples.tests.ConstructorInjectableDefinition;

import org.flexunit.assertThat;
import org.hamcrest.core.allOf;
import org.hamcrest.object.hasPropertyWithValue;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class ResolverInstanceCreation extends BaseResolverSpec {

    [Test]
    public function resolving_a_defined_type():void {
        adapter.defineTypeForResolver(Independent);
        assertThat(resolver.get(Independent), instanceOf(Independent));
    }

    [Test]
    public function resolving_an_implementation():void {
        adapter.definedImplementationForResolver(IDefinition, DefinitionImpl);
        assertThat(resolver.get(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_an_implementing_instance():void {
        const instance:DefinitionImpl = new DefinitionImpl();
        adapter.defineAnImplementingInstanceForResolver(IDefinition, instance);
        assertThat(resolver.get(IDefinition), strictlyEqualTo(instance));
    }

    [Test]
    public function resolving_using_a_provider_implementation():void {
        const provider:DefinitionProvider = new DefinitionProvider();
        adapter.defineAProviderImplementationForResolver(IDefinition, provider);
        assertThat(resolver.get(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_no_arguments():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.DefinitionProvider);
        assertThat(resolver.get(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_resolver_as_argument():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.ConstructorInjectableDefinitionProvider);
        assertThat(resolver.get(IDefinition), allOf(
                instanceOf(ConstructorInjectableDefinition),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
    }

    //TODO: define things without the need to provide a type for it, they already implement it (Scope has no support for this yet)

}
}
