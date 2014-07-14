package as3.depending.scope {
import as3.depending.spec.RelaxedResolverConstructorInjection;
import as3.depending.spec.ResolverAdapter;

public class ScopeConstructorInjection extends RelaxedResolverConstructorInjection {


    override protected function createAdapter():ResolverAdapter {
        return new ScopeAdapter();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
