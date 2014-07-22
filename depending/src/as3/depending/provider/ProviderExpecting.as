package as3.depending.provider {
import as3.depending.Providing;
import as3.depending.Resolver;

public interface ProviderExpecting extends Providing {

    function provide(resolver:Resolver):Object;

}
}
