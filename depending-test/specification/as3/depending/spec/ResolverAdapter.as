package as3.depending.spec {
import as3.depending.Provider;
import as3.depending.Resolver;

public class ResolverAdapter {
    public var resolver:Resolver;

    public function ResolverAdapter() {
    }

    public function defineTypeOnResolver(type:Class):void {
        throw new NotImplementedException(resolver, "defining type as resolvable");
    }

    public function definedImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        throw new NotImplementedException(resolver, "defining an implementation as resolvable");
    }

    public function defineAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        throw new NotImplementedException(resolver, "defining an implementing instance as resolvable");
    }

    public function defineAProviderImplementationForResolver(definingInterface:Class, provider:Provider):void {
        throw new NotImplementedException(resolver, "defining a Provider implementation to use for resolving a definition");
    }
}
}
