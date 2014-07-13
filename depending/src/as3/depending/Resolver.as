package as3.depending {

/**
 * Resolver instances contain the definitions of how to resolve instances of a certain type.
 *
 * To make this work a Resolver instance defines or allows to define the concrete implementation(s) and/or instances that are available in its scope,
 * and can then be used to resolve those.
 */
public interface Resolver {

    /**
     * Resolves an instance of the given Class if defined, throws UnresolvedDependencyError if not.
     *
     * Can return null or undefined if defined or implemented that way.
     *
     * @param clazz the type of the dependency to resolve.
     *
     * @throws UnresolvedDependencyError when the resolver can not resolve it.
     */
    function get(clazz:Class):*;

}
}
