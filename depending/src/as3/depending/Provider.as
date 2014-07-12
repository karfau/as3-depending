package as3.depending {

/**
 * A Provider holds the actual implementation how to receive an instance,
 * but is not responsible for injecting its dependencies.
 *
 * Some generic implementations are located at as3.depending.scope,
 * but this could also be a more specific factory or pool.
 *
 */
public interface Provider {

    /**
     * @return an instance
     */
    function provide():Object;

    /**
     * @returns true when the provided instances already have their dependencies resolved, false otherwise
     */
    function get providesResolved():Boolean;
}
}
