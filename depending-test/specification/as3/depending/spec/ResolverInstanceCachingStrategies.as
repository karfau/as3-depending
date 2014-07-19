package as3.depending.spec {
import as3.depending.examples.tests.Instance;

import org.flexunit.assertThat;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;

import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

public class ResolverInstanceCachingStrategies extends BaseResolverSpec {

    [Test]
    public function resolving_a_cached_instance_of_a_defined_type():void {
        adapter.usingInstanceCaching(true).specifyTypeForResolver(Instance);
        assertThat(resolver.get(Instance), strictlyEqualTo(resolver.get(Instance)));
    }

    [Test]
    public function resolving_different_instances_of_a_defined_type():void {
        adapter.usingInstanceCaching(false).specifyTypeForResolver(Instance);
        assertThat(resolver.get(Instance), not(equalTo(resolver.get(Instance))));
    }
}
}
