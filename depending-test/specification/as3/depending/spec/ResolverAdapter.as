package as3.depending.spec {
import as3.depending.Provider;
import as3.depending.Resolver;

public class ResolverAdapter {
    public var resolver:Resolver;

    public function ResolverAdapter() {
    }

    public function defineTypeForResolver(type:Class):void {
        failNotImplemented("defining type as resolvable");
    }

    public function definedImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        failNotImplemented("defining an implementation as resolvable");
    }

    public function defineAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        failNotImplemented("defining an implementing instance as resolvable");
    }

    public function defineAProviderImplementationForResolver(definingInterface:Class, provider:Provider):void {
        failNotImplemented("defining a Provider implementation to use for resolving a definition");
    }

    public function defineAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        failNotImplemented( "defining a function as a provider to use for resolving a definition");
    }

    public final function failNotImplemented(feature:String):void {
        throw new NotImplementedException(this, feature);
    }
}
}
