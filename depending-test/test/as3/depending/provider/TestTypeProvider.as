package as3.depending.provider {
import as3.depending.examples.tests.Instance;
import as3.depending.scope.impl.DependingDefinitionMock;
import as3.depending.scope.impl.Invokes;
import as3.depending.scope.impl.ResolverDummy;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertNull;
import org.hamcrest.collection.array;
import org.hamcrest.core.allOf;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.strictlyEqualTo;

public class TestTypeProvider {

    //noinspection JSFieldCanBeLocal
    private var provider:TypeProvider;
    private var resolver:ResolverDummy;
    private var invokes:Invokes;

    [Before]
    public function setUp():void {
        resolver = new ResolverDummy();
        invokes = new Invokes();
    }


    [Test]
    public function provide_creates_Instance():void {
        Instance.last = null;
        provider = new TypeProvider(Instance);

        assertNull(Instance.last);

        var first:Instance = Instance(provider.provide(null));

        assertThat(first, allOf(
                notNullValue(),
                strictlyEqualTo(Instance.last),
                not(equalTo(provider.provide(null)))
        ));
    }

    [Test]
    public function provide_creates_Depending_and_injects_resolver():void {
        DependingDefinitionMock.lastInstance = null;
        DependingDefinitionMock.invokes = invokes;

        provider = new TypeProvider(DependingDefinitionMock);

        assertNull(DependingDefinitionMock.lastInstance);

        var first:DependingDefinitionMock = DependingDefinitionMock(provider.provide(resolver));

        assertThat(first, allOf(
                notNullValue(),
                strictlyEqualTo(DependingDefinitionMock.lastInstance),
                not(equalTo(provider.provide(resolver)))
        ));
        invokes.assertWasInvokedWith(first.fetchDependencies,array(resolver));
    }
}
}
