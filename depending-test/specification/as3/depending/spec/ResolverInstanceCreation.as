package as3.depending.spec {
import as3.depending.examples.tests.DefinitionImpl;
import as3.depending.examples.tests.DefinitionProvider;
import as3.depending.examples.tests.IDefinition;
import as3.depending.examples.tests.Independent;
import as3.depending.examples.tests.ProviderFunctions;
import as3.depending.examples.tests.ResolvedDefinition;

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
    public function resolving_a_defined_type_optionally():void {
        adapter.defineTypeForResolver(Independent);
        assertThat(resolver.optionally(Independent), instanceOf(Independent));
    }

    [Test]
    public function resolving_an_implementation():void {
        adapter.definedImplementationForResolver(IDefinition, DefinitionImpl);
        assertThat(resolver.get(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_an_implementation_optionally():void {
        adapter.definedImplementationForResolver(IDefinition, DefinitionImpl);
        assertThat(resolver.optionally(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_an_implementing_instance():void {
        const instance:DefinitionImpl = new DefinitionImpl();
        adapter.defineAnImplementingInstanceForResolver(IDefinition, instance);
        assertThat(resolver.get(IDefinition), strictlyEqualTo(instance));
    }

    [Test]
    public function resolving_an_implementing_instance_optionally():void {
        const instance:DefinitionImpl = new DefinitionImpl();
        adapter.defineAnImplementingInstanceForResolver(IDefinition, instance);
        assertThat(resolver.optionally(IDefinition), strictlyEqualTo(instance));
    }

    [Test]
    public function resolving_using_a_provider_implementation():void {
        const provider:DefinitionProvider = new DefinitionProvider();
        adapter.defineAProviderImplementationForResolver(IDefinition, provider);
        assertThat(resolver.get(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_implementation_optionally():void {
        const provider:DefinitionProvider = new DefinitionProvider();
        adapter.defineAProviderImplementationForResolver(IDefinition, provider);
        assertThat(resolver.optionally(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_no_arguments():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.DefinitionProvider);
        assertThat(resolver.get(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_no_arguments_optionally():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.DefinitionProvider);
        assertThat(resolver.optionally(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_resolver_as_argument():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.ResolvedDefinitionProvider);
        assertThat(resolver.get(IDefinition), allOf(
                instanceOf(ResolvedDefinition),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
    }

    [Test]
    public function resolving_using_a_provider_function_with_resolver_as_argument_optionally():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.ResolvedDefinitionProvider);
        assertThat(resolver.optionally(IDefinition), allOf(
                instanceOf(ResolvedDefinition),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
    }



    //TODO: define things without the need to provide a type for it, they already implement it (Scope has no support for this yet)


}
}
