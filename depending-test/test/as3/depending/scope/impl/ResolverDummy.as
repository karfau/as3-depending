package as3.depending.scope.impl {
import as3.depending.RelaxedResolver;

public class ResolverDummy implements RelaxedResolver {

    public function get(identifier:Object):* {
        return undefined;
    }

    public function optionally(identifier:Object):* {
        return undefined;
    }
}
}
