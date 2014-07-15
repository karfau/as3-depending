package as3.depending.scope {
import as3.depending.examples.tests.*;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;
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
    public function map_returns_Mapping_with_resolver_set_to_scope():void {
        var mapping:Mapping = scope.map(IProtocol);
        assertThat(mapping.getResolver(), strictlyEqualTo(scope));
    }

    [Test]
    public function get_creates_Mapping_for_clazz():void {
        scope.get(DependingDefinitionMock);
        assertTrue(scope.hasMapping(DependingDefinitionMock));
    }

    [Test]
    public function optionally_creates_Mapping_for_clazz():void {
        scope.optionally(DependingDefinitionMock);
        assertTrue(scope.hasMapping(DependingDefinitionMock));
    }

    [Test]
    public function get_does_not_create_Mapping_for_interface():void {
        try{
            scope.get(IProtocol);
        }catch(e:Error){}
        assertFalse(scope.hasMapping(IProtocol));
    }

    [Test]
    public function optionally_does_not_create_Mapping_for_interface():void {
        scope.optionally(IProtocol);
        assertFalse(scope.hasMapping(IProtocol));
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

}
}
