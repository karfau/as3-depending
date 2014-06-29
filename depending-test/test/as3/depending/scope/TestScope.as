package as3.depending.scope {
import as3.depending.errors.UnresolvedDependencyError;
import as3.depending.examples.tests.*;
import as3.depending.scope.impl.MappingStub;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.core.*;
import org.hamcrest.object.*;

public class TestScope {

    private var scope:Scope;


    [Before]
    public function setUp():void {
        scope = new Scope();
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
    public function getByType_throws_when_no_mapping_but_required():void {
        assertThat(function ():void {
            scope.getByType(IDefinition, true);
        }, throws(isA(UnresolvedDependencyError)))
    }

    [Test]
    public function getByType_returns_undefined_when_no_mapping_and_not_required():void {
        var value:* = scope.getByType(IDefinition, false);
        assertTrue(value === undefined);
    }

    [Test]
    public function getByType_returns_Mapping_getValue():void {
        scope = new TestableScope();
        var mapping:MappingStub = MappingStub(scope.map(IDefinition));
        mapping.testValue = new DefinitionImpl();

        assertThat(scope.getByType(IDefinition), strictlyEqualTo(mapping.testValue));
    }

}
}
