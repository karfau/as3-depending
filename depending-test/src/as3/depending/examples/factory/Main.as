package as3.depending.examples.factory {
import as3.depending.examples.factory.engine.*;
import as3.depending.scope.Scope;

public class Main {
    public function Main() {

        var factory:CarFactory = new CarFactory();

        var sportScope:Scope = new Scope();
        sportScope.map(IEngine).toType(SportEngine);

        var familyScope:Scope = new Scope();
        familyScope.map(IEngine).toType(FamilyEngine);


        var sportCar:Car = factory.createCar(sportScope);
        sportCar.accelerate();
        trace(sportCar.speed);//120

        var familyCar:Car = factory.createCar(familyScope);
        familyCar.accelerate();
        trace(familyCar.speed);//50

    }
}
}
