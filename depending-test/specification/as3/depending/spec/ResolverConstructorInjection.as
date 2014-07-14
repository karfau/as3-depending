package as3.depending.spec {
import as3.depending.examples.tests.ConstructorInjectableProtocol;
import as3.depending.examples.tests.IResolverSpecProtocol;

import org.flexunit.assertThat;
import org.hamcrest.object.strictlyEqualTo;

public class ResolverConstructorInjection extends BaseResolverSpec {

    [Test]
    public function resolving_a_defined_type():void {
        adapter.defineConstructorInjectableProtocolForResolver();
        assertThat(IResolverSpecProtocol(resolver.get(ConstructorInjectableProtocol)).resolver, strictlyEqualTo(resolver));
    }

    [Test]
    public function resolving_an_implementation():void {
        adapter.defineConstructorInjectableProtocolAsImplementationForResolver(IResolverSpecProtocol);
        assertThat(IResolverSpecProtocol(resolver.get(IResolverSpecProtocol)).resolver, strictlyEqualTo(resolver));
    }

    //TODO: 'inline configuration' for constructor injection

}
}
