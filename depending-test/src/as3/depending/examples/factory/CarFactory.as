package as3.depending.examples.factory {
import as3.depending.Resolver;

public class CarFactory {

    public function createCar(resolver:Resolver):Car {
        var car:Car = new Car();
        car.fetchDependencies(resolver);
        return car;
    }

}
}
