package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.examples.tests.ConstructorInjectableProtocol;
import as3.depending.examples.tests.ProtocolProviderFunctions;
import as3.depending.spec.ResolverAdapter;

public class ScopeSpecifyAdapter extends ResolverAdapter {


    public function ScopeSpecifyAdapter() {
        resolver = new Scope();
    }

    protected function get scope():Scope{
        return Scope(resolver);
    }

    override public function specifyTypeForResolver(type:Class):void {
        scope.specify(type);
    }

    override public function specifydImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        scope.specify(definingInterface, implementingClass);
    }

    override public function specifyAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        scope.specify(definingInterface, instance);
    }

    override public function specifyAProviderImplementationForResolver(definingInterface:Class, provider:Provider):void {
        scope.specify(definingInterface, provider);
    }

    override public function specifyAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        scope.specify(definingInterface, provider);
    }

    override public function specifyConstructorInjectableProtocolForResolver():void {
        scope.specify(ConstructorInjectableProtocol, ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }

    override public function specifyConstructorInjectableProtocolAsImplementationForResolver(definingInterface:Class):void {
        scope.specify(definingInterface, ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }
}
}
