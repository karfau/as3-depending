package as3.depending.scope {
import as3.depending.errors.UnresolvedDependencyError;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.core.allOf;
import org.hamcrest.core.isA;
import org.hamcrest.core.throws;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.strictlyEqualTo;

public class TestScope {

    private var scope:Scope;


    [Before]
    public function setUp():void {
        scope = new Scope();
    }


    [Test]
    public function map_returns_same_Mapping_for_same_type():void {
        var mapping:Mapping = scope.map(Object);
        var second:Mapping = scope.map(Object);
        assertThat(second, allOf(
                notNullValue(),
                strictlyEqualTo(mapping)
        ));
    }

    [Test]
    public function getByType_throws_when_no_mapping_but_required():void {
        assertThat(function ():void {
            scope.getByType(Object, true);
        }, throws(isA(UnresolvedDependencyError)))
    }

    [Test]
    public function getByType_returns_undefined_when_no_mapping_and_not_required():void {
        var value:* = scope.getByType(Object, false);
        assertTrue(value === undefined);
    }

    [Test]
    public function getByType_returns_Mapping_getValue():void {
        scope = new TestableScope();
        var mapping:MappingStub = MappingStub(scope.map(Object));

        assertThat(scope.getByType(Object), strictlyEqualTo(mapping.testValue));
    }

}
}
