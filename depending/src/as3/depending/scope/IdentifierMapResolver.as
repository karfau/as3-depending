package as3.depending.scope {
import as3.depending.BaseRelaxedResolver;
import as3.depending.Providing;
import as3.depending.provider.ProviderStrategy;
import as3.depending.provider.invokeProvider;

public class IdentifierMapResolver extends BaseRelaxedResolver {

    private var _specifies:IdentifierMap;

    public function IdentifierMapResolver(specifies:IdentifierMap) {
        _specifies = specifies;
    }

    public var implicitResolving:ProviderStrategy;

    override protected function doResolve(identifier:Object):* {
        if(_specifies.has(identifier)){
            return invokeProvider(_specifies.get(identifier), this);
        }
        if(implicitResolving){
            var provider:Providing = implicitResolving.providerFor(identifier);
            if(provider){
                var value:Object = invokeProvider(provider, this);
            }
            return value;
        }
        throw new Error("can not resolve " + identifier);
    }

}
}
