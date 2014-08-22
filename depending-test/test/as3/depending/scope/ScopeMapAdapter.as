package as3.depending.scope {
import as3.depending.Providing;
import as3.depending.examples.tests.*;

public class ScopeMapAdapter extends ScopeSpecifyAdapter {


    public function ScopeMapAdapter() {
        resolver = new Scope();
    }

    private function handleInstanceCaching(mapping:Mapping):void {
        if (expectingCachedInstance) {
            if(useEagerSingleton){
                mapping.asEagerSingleton();
            }else{
                mapping.asSingleton();
            }
        }
    }

    override public function specifyTypeForResolver(type:Class):void {
        handleInstanceCaching(scope.map(type));
    }

    override public function specifyImplementationForResolver(definingInterface:Class, implementingClass:Class):void {
        handleInstanceCaching(scope.map(definingInterface).toType(implementingClass));
    }

    override public function specifyAnImplementingInstanceForResolver(definingInterface:Class, instance:Object):void {
        scope.map(definingInterface).toInstance(instance);
    }

    override public function specifyAProviderForResolver(definingInterface:Class, provider:Providing):void {
        handleInstanceCaching(scope.map(definingInterface).toProviding(provider));
    }

    override public function specifyAProviderFunctionForResolver(definingInterface:Class, provider:Function):void {
        handleInstanceCaching(scope.map(definingInterface).toFactory(provider));
    }

    override public function specifyConstructorInjectableProtocolForResolver():void {
        scope.map(ConstructorInjectableProtocol)
                .toFactory(ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }


    override public function specifyConstructorInjectableProtocolAsImplementationForResolver(definingInterface:Class):void {
        scope.map(definingInterface)
                .toFactory(ProtocolProviderFunctions.ConstructorInjectableDefinitionProvider);
    }


    override public function specifyInlineConstructorInjectableProtocolForResolver():void {
        scope.map(IResolverSpecProtocol).toFactory(InlineConstructorInjectableProtocol.create);//not really inline, but explicit and type safe and works ;)
    }

    override public function specifyAValueForResolver(value:Object):void {
        //pure TDD: minimal implementation to let tests pass ;)
        if (value !== null) {
            scope.map(value.constructor).toInstance(value);
        }
    }
}
}
