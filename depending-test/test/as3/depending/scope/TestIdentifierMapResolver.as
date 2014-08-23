package as3.depending.scope {
import as3.depending.provider.ProviderMock;
import as3.depending.scope.impl.*;

import org.flexunit.asserts.assertFalse;
import org.hamcrest.collection.array;

public class TestIdentifierMapResolver {

    private var resolver:IdentifierMapResolver;
    private var invokes:Invokes;

    private var map:IdentifierMap;

    [Before]
    public function setUp():void {
        map = new IdentifierMap();
        resolver = new IdentifierMapResolver(map);
        invokes = new Invokes();
        DependingDefinitionMock.invokes = invokes;
    }

    [Test]
    public function implicitResolving_allows_get_to_resolve_clazz():void {
        resolver.implicitResolving = new ImplicitResolvingStrategy();
        var value:DependingDefinitionMock = resolver.get(DependingDefinitionMock);
        invokes.assertWasInvokedWith(value.fetchDependencies, array(resolver));
    }

    [Test]
    public function implicitResolving_allows_optionally_to_resolve_clazz():void {
        resolver.implicitResolving = new ImplicitResolvingStrategy();
        var value:DependingDefinitionMock = resolver.optionally(DependingDefinitionMock);
        invokes.assertWasInvokedWith(value.fetchDependencies, array(resolver));
    }

    [Test]
    public function implicitResolving_with_get_does_not_specify_clazz():void {
        resolver.implicitResolving = new ImplicitResolvingStrategy();
        resolver.get(DependingDefinitionMock);
        assertFalse(map.has(DependingDefinitionMock));
    }

    [Test]
    public function implicitResolving_with_optionally_does_not_specify_clazz():void {
        resolver.implicitResolving = new ImplicitResolvingStrategy();
        resolver.optionally(DependingDefinitionMock);
        assertFalse(map.has(DependingDefinitionMock));
    }

    [Test]
    public function get_uses_map_for_resolving():void {
        var providing:ProviderMock = new ProviderMock(invokes);
        map.set(null, providing);
        resolver.get(null);
        invokes.assertWasInvokedWith(providing.provide, array(resolver));
    }

    [Test]
    public function optionally_uses_map_for_resolving():void {
        var providing:ProviderMock = new ProviderMock(invokes);
        map.set(null, providing);
        resolver.optionally(null);
        invokes.assertWasInvokedWith(providing.provide, array(resolver));
    }

}
}
