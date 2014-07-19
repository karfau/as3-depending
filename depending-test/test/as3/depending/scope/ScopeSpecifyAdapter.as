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

    public var useEagerSingleton:Boolean;

    private function handleInstanceCaching(specified:Specified):void {
        if (expectingCachedInstance) {
            if (useEagerSingleton) {
                specified.asEagerSingleton();
            } else {
                specified.asSingleton();
            }
        }
    }

    override public function specifyTypeForResolver(type:Class):void {
        handleInstanceCaching(scope.specify(type));
    }

    override public function specifyImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        handleInstanceCaching(scope.specify(definingInterface, implementingClass));
    }

    override public function specifyAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        scope.specify(definingInterface, instance);
    }

    override public function specifyAProviderForResolver(definingInterface:Class, provider:Provider):void {
        handleInstanceCaching(scope.specify(definingInterface, provider));
    }

    override public function specifyAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        handleInstanceCaching(scope.specify(definingInterface, provider));
    }

    override public function specifyConstructorInjectableProtocolForResolver():void {
        scope.specify(ConstructorInjectableProtocol, ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }

    override public function specifyConstructorInjectableProtocolAsImplementationForResolver(definingInterface:Class):void {
        scope.specify(definingInterface, ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }

    override public function specifyAValueForResolver(value:Object):void {
        scope.specify(value);
    }
}
}
