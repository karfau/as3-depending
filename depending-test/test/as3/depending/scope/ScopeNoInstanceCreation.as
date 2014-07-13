package as3.depending.scope {
import as3.depending.spec.RelaxedResolverNoInstanceCreation;
import as3.depending.spec.ResolverAdapter;

public class ScopeNoInstanceCreation extends RelaxedResolverNoInstanceCreation {

    override protected function createAdapter():ResolverAdapter {
        return new ScopeAdapter();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
