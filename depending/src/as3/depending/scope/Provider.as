package as3.depending.scope {
import as3.depending.Resolver;

public interface Provider {
		function provide(resolver:Resolver = null):Object;
	}
}
