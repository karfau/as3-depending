package as3.depending.scope.impl {
import as3.depending.RelaxedResolver;

public class ResolverMock implements RelaxedResolver {

    public function get(clazz:Class):* {
        return undefined;
    }

    public function optionally(clazz:Class):* {
        return undefined;
    }
}
}
