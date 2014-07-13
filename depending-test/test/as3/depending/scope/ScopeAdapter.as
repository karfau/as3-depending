package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.spec.ResolverAdapter;

public class ScopeAdapter extends ResolverAdapter {


    public function ScopeAdapter() {
        resolver = new Scope();
    }

    protected function get scope():Scope{
        return Scope(resolver);
    }

    override public function defineTypeOnResolver(type:Class):void {
        scope.map(type);
    }

    override public function definedImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        scope.map(definingInterface).toType(implementingClass);
    }

    override public function defineAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        scope.map(definingInterface).toInstance(instance);
    }

    override public function defineAProviderImplementationForResolver(definingInterface:Class, provider:Provider):void {
        scope.map(definingInterface).toProvider(provider);
    }

    override public function defineAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        scope.map(definingInterface).toFactory(provider);
    }
}
}
