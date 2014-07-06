package as3.depending {

/**
 * A Resolver instance is used to resolve dependencies for objects that have dependencies before they can start working.
 *
 * To make this work a Resolver gets configured first with the correct dependencies for its scope,
 * and can then be used to resolve those.
 *
 *
 */
public interface Resolver {

    /**
     * Resolves an instance of the given Class if one was mapped
     *
     * @param clazz the type of the dependency to resolve.
     * @param required decides whether to throw an Error(true, default) or return undefined(false) when an instance can not be created.
     *
     * @return the value if one was configured, undefined otherwise
     *
     * @throws UnresolvedDependencyError when required is true(default) and the resolver can not resolve it.
     */
    function get(clazz:Class, required:Boolean = true):*;

}
}
