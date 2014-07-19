package as3.depending.scope {
import as3.depending.examples.tests.*;
import as3.depending.provider.ProviderMock;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.collection.array;
import org.hamcrest.core.*;
import org.hamcrest.object.*;

public class TestScope {

    private var scope:Scope;
    private var invokes:Invokes;

    [Before]
    public function setUp():void {
        scope = new Scope();
        invokes = new Invokes();
        DependingDefinitionMock.invokes = invokes;
    }

    [Test]
    public function map_returns_same_Mapping_for_same_type():void {
        var mapping:Mapping = scope.map(IProtocol);
        var second:Mapping = scope.map(IProtocol);
        assertThat(second, allOf(
                notNullValue(),
                strictlyEqualTo(mapping)
        ));
    }

    [Test]
    public function specify_returns_the_related_Specified():void {
        var it:Specified = scope.specify(IProtocol);
        assertThat(it.scope, strictlyEqualTo(scope));
        assertThat(scope.specify(IProtocol), strictlyEqualTo(it));
    }

    [Test]
    public function specify_allows_access_to_provider():void {
        const provider:ProviderMock = new ProviderMock(invokes);
        var it:Specified = scope.specify(provider);
        assertThat(it.provider, strictlyEqualTo(provider));
    }

    [Test]
    public function map_returns_Mapping_with_resolver_set_to_scope():void {
        var mapping:Mapping = scope.map(IProtocol);
        assertThat(mapping.getResolver(), strictlyEqualTo(scope));
    }

    [Test]
    public function implicitResolving_allows_get_to_resolve_clazz():void {
        scope.implicitResolving = new ImplicitResolvingStrategy();
        var value:DependingDefinitionMock = scope.get(DependingDefinitionMock);
        invokes.assertWasInvokedWith(value.fetchDependencies, array(scope));
    }

    [Test]
    public function implicitResolving_allows_optionally_to_resolve_clazz():void {
        scope.implicitResolving = new ImplicitResolvingStrategy();
        var value:DependingDefinitionMock = scope.optionally(DependingDefinitionMock);
        invokes.assertWasInvokedWith(value.fetchDependencies, array(scope));
    }

    [Test]
    public function implicitResolving_with_get_does_not_specify_clazz():void {
        scope.implicitResolving = new ImplicitResolvingStrategy();
        scope.get(DependingDefinitionMock);
        assertFalse(scope.isSpecified(DependingDefinitionMock));
    }

    [Test]
    public function implicitResolving_with_optionally_does_not_specify_clazz():void {
        scope.implicitResolving = new ImplicitResolvingStrategy();
        scope.optionally(DependingDefinitionMock);
        assertFalse(scope.isSpecified(DependingDefinitionMock));
    }

    [Test]
    public function get_does_not_create_Mapping_for_interface():void {
        try{
            scope.get(IProtocol);
        }catch(e:Error){}
        assertFalse(scope.isSpecified(IProtocol));
    }

    [Test]
    public function optionally_does_not_create_Mapping_for_interface():void {
        scope.optionally(IProtocol);
        assertFalse(scope.isSpecified(IProtocol));
    }

    [Test]
    public function get_invokes_Mapping_getValue():void {
        scope = new TestableScope(invokes);
        var mapping:Mapping = scope.map(IProtocol);

        invokes.assertNoInvokes(mapping.getValue);

        scope.get(IProtocol);

        invokes.assertInvokes(mapping.getValue, 1);
    }

    [Test]
    public function optionally_invokes_Mapping_getValue():void {
        scope = new TestableScope(invokes);
        var mapping:Mapping = scope.map(IProtocol);
        assertThat(mapping, instanceOf(TestableMapping));

        invokes.assertNoInvokes(mapping.getValue);

        scope.optionally(IProtocol);

        invokes.assertInvokes(mapping.getValue, 1);
    }

    [Test]
    public function after_map_identity_isSpecified():void {
        scope.map(null);
        assertTrue('for null',scope.isSpecified(null));
        scope.map(IProtocol);
        assertTrue('for IProtocol',scope.isSpecified(IProtocol));
        scope.map(ProtocolImpl);
        assertTrue('for IProtocol',scope.isSpecified(IProtocol));
    }

    [Test]
    public function after_specify_identity_isSpecified():void {
        scope.specify(null);
        assertTrue('for null',scope.isSpecified(null));
        scope.specify(IProtocol);
        assertTrue('for IProtocol',scope.isSpecified(IProtocol));
        scope.specify(ProtocolImpl);
        assertTrue('for IProtocol',scope.isSpecified(IProtocol));
    }

}
}
