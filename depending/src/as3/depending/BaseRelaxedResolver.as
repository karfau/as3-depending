package as3.depending {
import as3.depending.errors.UnresolvedDependencyError;

import flash.utils.getQualifiedClassName;

public class BaseRelaxedResolver implements RelaxedResolver {

    public function get(clazz:Class):* {
        try {
            return doResolve(clazz);
        } catch (error:Error) {
            throw new UnresolvedDependencyError("couldn't resolve a value for class <" + getQualifiedClassName(clazz) + ">, an error was thrown: ", error);
        }
    }

    protected function doResolve(clazz:Class):* {
        throw new Error(this + " is not implementing BaseRelaxedResolver.doResolve or calls super.doResolve()");
    }

    public function optionally(clazz:Class):* {
        try {
            return doResolve(clazz);
        } catch (error:Error) {
            return undefined;
        }
    }

}
}
