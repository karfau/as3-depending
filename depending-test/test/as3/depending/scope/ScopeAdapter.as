package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.examples.tests.ConstructorInjectableProtocol;
import as3.depending.examples.tests.ProtocolProviderFunctions;
import as3.depending.spec.ResolverAdapter;

public class ScopeAdapter extends ResolverAdapter {


    public function ScopeAdapter() {
        resolver = new Scope();
    }

    protected function get scope():Scope{
        return Scope(resolver);
    }

    override public function specifyTypeForResolver(type:Class):void {
        scope.map(type);
    }

    override public function specifydImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        scope.map(definingInterface).toType(implementingClass);
    }

    override public function specifyAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        scope.map(definingInterface).toInstance(instance);
    }

    override public function specifyAProviderImplementationForResolver(definingInterface:Class, provider:Provider):void {
        scope.map(definingInterface).toProvider(provider);
    }

    override public function specifyAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        scope.map(definingInterface).toFactory(provider);
    }

    override public function specifyConstructorInjectableProtocolForResolver():void {
        scope.map(ConstructorInjectableProtocol)
                .toFactory(ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }


    override public function specifyConstructorInjectableProtocolAsImplementationForResolver(definingInterface:Class):void {
        scope.map(definingInterface)
                .toFactory(ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }
}
}
