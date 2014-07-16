package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.spec.ResolverAdapter;

public class ScopeSpecifyAdapter extends ResolverAdapter {


    public function ScopeSpecifyAdapter() {
        resolver = new Scope();
    }

    protected function get scope():Scope{
        return Scope(resolver);
    }

    override public function defineTypeForResolver(type:Class):void {
        scope.specify(type);
    }

    override public function definedImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        scope.specify(definingInterface, implementingClass);
    }

    override public function defineAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        scope.specify(definingInterface, instance);
    }

    override public function defineAProviderImplementationForResolver(definingInterface:Class, provider:Provider):void {
        scope.specify(definingInterface, provider);
    }

    override public function defineAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        scope.specify(definingInterface, provider);
    }

/*
    override public function defineConstructorInjectableProtocolForResolver():void {
        scope.map(ConstructorInjectableProtocol)
                .toFactory(ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }


    override public function defineConstructorInjectableProtocolAsImplementationForResolver(definingInterface:Class):void {
        scope.map(definingInterface)
                .toFactory(ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }*/
}
}
