package as3.depending.provider {
import as3.depending.Providing;
import as3.depending.Resolver;

public function invokeProvider(provider:Object, resolver:Resolver):Object {
    var method:Function = provider as Function;
    var providing:Object = provider as ProviderZero;
    if (method == null) {
        if (providing == null) {
            throw new ArgumentError('expected a Function or a Providing but was ' + provider);
        }else{
            method = providing.provide as Function;
        }
    }

    if(method.length == 0){
        return method();
    }
    if(resolver == null){
        throw new ArgumentError('resolver can not be null');
    }
    return method(resolver);
}
}
