package as3.depending.provider {
import as3.depending.Resolver;

public function invokeProvider(provider:Function, resolver:Resolver):Object {
    if(provider.length == 0){
        return provider();
    }
    if(resolver == null){
        throw new ArgumentError('resolver can not be null');
    }
    return provider(resolver);
}
}
