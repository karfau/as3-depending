package as3.depending {
import as3.depending.errors.UnresolvedDependencyError;

import flash.utils.getQualifiedClassName;

public class BaseRelaxedResolver implements RelaxedResolver {

    public function get(identifier:Object):* {
        try {
            return doResolve(identifier);
        } catch (error:Error) {
            throw new UnresolvedDependencyError("couldn't resolve a value for class <" + getQualifiedClassName(identifier) + ">, an error was thrown: ", error);
        }
    }

    protected function doResolve(identifier:Object):* {
        throw new Error(this + " is not implementing BaseRelaxedResolver.doResolve or calls super.doResolve()");
    }

    public function optionally(identifier:Object):* {
        try {
            return doResolve(identifier);
        } catch (error:Error) {
            return undefined;
        }
    }

}
}
