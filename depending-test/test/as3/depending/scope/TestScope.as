package as3.depending.scope {
import as3.depending.errors.UnresolvedDependencyError;
import as3.depending.examples.tests.*;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
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
        var mapping:Mapping = scope.map(IDefinition);
        var second:Mapping = scope.map(IDefinition);
        assertThat(second, allOf(
                notNullValue(),
                strictlyEqualTo(mapping)
        ));
    }

    [Test]
    public function map_returns_Mapping_with_resolver_set_to_scope():void {
        var mapping:Mapping = scope.map(IDefinition);
        assertThat(mapping.resolver, strictlyEqualTo(scope));
    }

    [Test]
    public function get_throws_when_no_mapping_but_required():void {
        assertThat(function ():void {
            scope.get(IDefinition);
        }, throws(allOf(
                instanceOf(UnresolvedDependencyError),
                hasPropertyWithValue('caught',instanceOf(VerifyError))
        )));
    }

    [Test]
    public function get_for_simpleClass_returns_instance_when_no_mapping():void {
        var value:Independent = scope.get(Independent);
        assertThat(value, notNullValue());
    }

    [Test]
    public function get_for_dependingClass_returns_instance_when_no_mapping():void {
        var value:DependingDefinitionMock = scope.get(DependingDefinitionMock);
        assertThat(value, notNullValue());
        invokes.assertInvokes(value.fetchDependencies, array(scope));
    }

    [Test]
    public function get_returns_undefined_when_no_mapping_and_not_required():void {
        var value:* = scope.optionally(IDefinition);
        assertTrue(value === undefined);
    }

    [Test]
    public function get_returns_Mapping_getValue():void {
        scope = new TestableScope();
        var mapping:MappingStub = MappingStub(scope.map(IDefinition));
        mapping.testValue = new DefinitionImpl();

        assertThat(scope.get(IDefinition), strictlyEqualTo(mapping.testValue));
    }

}
}
