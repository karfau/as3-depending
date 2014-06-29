package as3.depending {

/**
 * A Depending instance depends on something that needs to be resolved before it can be used.
 *
 * The code the creates the instance should call fetchDependencies directly after creating it,
 * with a resolver capable of providing those dependencies.
 */
public interface Depending {

    /**
     * When this method gets called the depending object will use the resolver to wire its dependencies.
     *
     * Implementing classes should document what dependencies they expect to be resolvable.
     *
     * @param resolver
     */
    function fetchDependencies(resolver:Resolver):void;

}
}
