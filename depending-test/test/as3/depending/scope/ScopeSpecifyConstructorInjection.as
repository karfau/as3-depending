package as3.depending.scope {
import as3.depending.spec.RelaxedResolverConstructorInjection;
import as3.depending.spec.ResolverAdapter;

public class ScopeSpecifyConstructorInjection extends RelaxedResolverConstructorInjection {


    override protected function createAdapter():ResolverAdapter {
        return new ScopeSpecifyAdapter();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
