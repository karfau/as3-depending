package as3.depending.spec {
import as3.depending.Provider;
import as3.depending.RelaxedResolver;
import as3.depending.Resolver;

public class ResolverAdapter {
    public var resolver:Resolver;

    public function get relaxedResolver():RelaxedResolver {
        return RelaxedResolver(resolver);
    }

    public final function failNotImplemented(feature:String):void {
        throw new NotImplementedException(this, feature);
    }


    public function specifyTypeForResolver(type:Class):void {
        failNotImplemented("specify a type as resolvable");
    }

    public function specifyImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        failNotImplemented("specify an implementation as resolvable");
    }

    public function specifyAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        failNotImplemented("specify an implementing instance as resolvable");
    }

    public function specifyAProviderForResolver(definingInterface:Class, provider:Provider):void {
        failNotImplemented("specify a Provider instance to use for resolving a definition");
    }

    public function specifyAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        failNotImplemented( "specify a function as a provider to use for resolving a definition");
    }

    public function specifyConstructorInjectableProtocolForResolver():void {
        failNotImplemented( "specify ConstructorInjectableProtocol as resolvable");
    }

    public function specifyConstructorInjectableProtocolAsImplementationForResolver(definingInterface:Class):void {
        failNotImplemented("specify the implementation ConstructorInjectableProtocol as resolvable");
    }

    public function specifyAValueForResolver(value:Object):void {
        failNotImplemented("specify a value as resolvable");
    }

    protected var expectingCachedInstance:Boolean;
    public final function usingInstanceCaching(active:Boolean):ResolverAdapter {
        expectingCachedInstance = active;
        return this;
    }
}
}
