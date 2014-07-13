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

public class RelaxedResolverInstanceCreation extends ResolverInstanceCreation {


    [Before]
    override public function setUpResolver():void {
        super.setUpResolver();
        assertRelaxedResolver();
    }

    [Test]
    public function resolving_a_defined_type_optionally():void {
        adapter.defineTypeForResolver(Independent);
        assertThat(relaxedResolver.optionally(Independent), instanceOf(Independent));
    }

    [Test]
    public function resolving_an_implementation_optionally():void {
        adapter.definedImplementationForResolver(IDefinition, DefinitionImpl);
        assertThat(relaxedResolver.optionally(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_an_implementing_instance_optionally():void {
        const instance:DefinitionImpl = new DefinitionImpl();
        adapter.defineAnImplementingInstanceForResolver(IDefinition, instance);
        assertThat(relaxedResolver.optionally(IDefinition), strictlyEqualTo(instance));
    }

    [Test]
    public function resolving_using_a_provider_implementation_optionally():void {
        const provider:DefinitionProvider = new DefinitionProvider();
        adapter.defineAProviderImplementationForResolver(IDefinition, provider);
        assertThat(relaxedResolver.optionally(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_no_arguments_optionally():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.DefinitionProvider);
        assertThat(relaxedResolver.optionally(IDefinition), instanceOf(DefinitionImpl));
    }

    [Test]
    public function resolving_using_a_provider_function_with_resolver_as_argument_optionally():void {
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.ResolvedDefinitionProvider);
        assertThat(relaxedResolver.optionally(IDefinition), allOf(
                instanceOf(ResolvedDefinition),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
    }

    //TODO: define things without the need to provide a type for it, they already implement it (Scope has no support for this yet)

}
}
