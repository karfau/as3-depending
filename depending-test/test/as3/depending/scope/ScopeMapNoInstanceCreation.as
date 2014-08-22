package as3.depending.scope {
import as3.depending.spec.RelaxedResolverNoInstanceCreation;
import as3.depending.spec.ResolverAdapter;

public class ScopeMapNoInstanceCreation extends RelaxedResolverNoInstanceCreation {

    override protected function createAdapter():ResolverAdapter {
        return new ScopeMapAdapter();
    }

    /**
     * Scope.map() doesn't support null as an argument
     */
    override public function resolving_null():void {
        //super.resolving_null();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
