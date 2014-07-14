package as3.depending.spec {
import as3.depending.examples.tests.DefinitionImpl;
import as3.depending.examples.tests.DefinitionProvider;
import as3.depending.examples.tests.IDefinition;
import as3.depending.examples.tests.IResolverSpecDefinition;
import as3.depending.examples.tests.Independent;
import as3.depending.examples.tests.ProviderFunctions;
import as3.depending.examples.tests.ConstructorInjectableDefinition;

import org.flexunit.assertThat;
import org.hamcrest.core.allOf;
import org.hamcrest.object.hasPropertyWithValue;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class RelaxedResolverConstructorInjection extends ResolverConstructorInjection {

    [Test]
    public function resolving_a_defined_type_optionally():void {
        adapter.defineConstructorInjectableTypeForResolver();
        assertThat(IResolverSpecDefinition(relaxedResolver.optionally(ConstructorInjectableDefinition)).resolver, strictlyEqualTo(resolver));
    }

    [Test]
    public function resolving_an_implementation_optionally():void {
        adapter.defineConstructorInjectableTypeAsImplementationForResolver(IResolverSpecDefinition);
        assertThat(IResolverSpecDefinition(relaxedResolver.optionally(IResolverSpecDefinition)).resolver, strictlyEqualTo(resolver));
    }

/*
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
        adapter.defineAProviderFunctionForResolver(IDefinition, ProviderFunctions.ConstructorInjectableDefinitionProvider);
        assertThat(relaxedResolver.optionally(IDefinition), allOf(
                instanceOf(ConstructorInjectableDefinition),
                hasPropertyWithValue('resolver',strictlyEqualTo(resolver))
        ));
    }
*/

    //TODO: define things without the need to provide a type for it, they already implement it (Scope has no support for this yet)

}
}
