package as3.depending.provider {
import as3.depending.Providing;
import as3.depending.examples.tests.*;
import as3.depending.scope.impl.*;

import org.flexunit.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.collection.hasItem;
import org.hamcrest.object.*;

public class TestDefaultProviderStrategy {

    private var it:DefaultProviderStrategy;

    [Before]
    public function setUp():void {
        it = new DefaultProviderStrategy();
    }

    [Test]
    public function creates_ValueProvider_for_null():void {
        const value:Object = null;
        const provider:Providing = it.providerFor(value);
        assertThat(provider, instanceOf(ValueProvider));
        assertThat(ValueProvider(provider).provide(), strictlyEqualTo(value));
    }

    [Test]
    public function creates_ValueProvider_for_instance():void {
        const value:Instance = new Instance();
        const provider:Providing = it.providerFor(value);
        assertThat(provider, instanceOf(ValueProvider));
        assertThat(ValueProvider(provider).provide(), strictlyEqualTo(value));
    }

    [Test]
    public function creates_TypeProvider_for_Class_value():void {
        const provider:Providing = it.providerFor(Instance);
        assertThat(provider, instanceOf(TypeProvider));
        assertThat(TypeProvider(provider).provide(), instanceOf(Instance));
    }

    [Test]
    public function creates_FactoryProvider_for_Function_value():void {
        var invoke:Invokes = new Invokes();

        const provider:Providing = it.providerFor(invoke.noParameters);
        assertThat(provider, instanceOf(FactoryProvider));
        invoke.assertNoInvokes(invoke.noParameters);

        FactoryProvider(provider).provide();
        invoke.assertInvokes(invoke.noParameters, 1)
    }

    [Test]
    public function returns_given_provider():void {
        const input:Providing = new ProviderMock(null);
        const result:Providing = it.providerFor(input);
        assertThat(result, strictlyEqualTo(input));
    }

    [Test]
    public function adding_ProviderStrategy_adds_it_to_the_list():void {
        const addition:ProviderStrategyMock = new ProviderStrategyMock();
        it.add(addition);
        assertThat(it.strategies, hasItem(addition));
    }

    [Test]
    public function providerFor_invokes_strategies():void {
        var invokes:Invokes = new Invokes();
        const first:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        const second:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        it.strategies = new <ProviderStrategy>[first,null,second];

        const value:Instance = new Instance();
        it.providerFor(value);
        invokes.assertWasInvokedWith(first.providerFor, array(value));
        invokes.assertWasInvokedWith(second.providerFor, array(value));
    }

    [Test]
    public function providerFor_first_in_strategies_wins():void {
        var invokes:Invokes = new Invokes();
        const first:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        first.result = new ProviderMock();
        const second:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        it.strategies = new <ProviderStrategy>[first,second];

        const value:Instance = new Instance();
        it.providerFor(value);
        invokes.assertInvokes(first.providerFor, 1);
        invokes.assertNoInvokes(second.providerFor);
    }

    [Test]
    public function providerFor_second_in_strategies_wins():void {
        var invokes:Invokes = new Invokes();
        const first:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        const second:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        second.result = new ProviderMock();
        it.strategies = new <ProviderStrategy>[first,second];

        const value:Instance = new Instance();
        it.providerFor(value);
        invokes.assertInvokes(first.providerFor, 1);
        invokes.assertInvokes(second.providerFor, 1);
    }

    [Test]
    public function providerFor_returns_provider_from_strategy():void {
        var invokes:Invokes = new Invokes();
        const addition:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        it.add(addition);
        addition.result = new ProviderMock();

        const value:Instance = new Instance();
        assertThat(it.providerFor(value), strictlyEqualTo(addition.result));
    }

    [Test]
    public function providerFor_return_provider_without_invoking_strategies():void {
        var invokes:Invokes = new Invokes();
        const addition:ProviderStrategyMock = new ProviderStrategyMock(invokes);
        it.add(addition);

        const input:Providing = new ProviderMock(null);
        it.providerFor(input);
        invokes.assertNoInvokes(addition.providerFor);
    }
}
}
