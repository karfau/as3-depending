package as3.depending {

/**
 * Resolver instances contain the information that specifies how to resolve instances for certain types.
 *
 * To make this work a Resolver instance specifies or allows to specify the concrete implementation(s) and/or instances that are available in its scope,
 * and can then be used to resolve those.
 */
public interface Resolver {

    /**
     * Resolves a value for a given identifier if specified, throws UnresolvedDependencyError if not.
     *
     * Can return null or undefined if specified or implemented that way.
     *
     * @param identifier the identifier of the dependency to resolve.
     *
     * @throws UnresolvedDependencyError when the resolver can not resolve it.
     */
    function get(identifier:Object):*;

}
}
