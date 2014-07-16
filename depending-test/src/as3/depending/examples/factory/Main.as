package as3.depending.examples.factory {
import as3.depending.examples.factory.engine.*;
import as3.depending.scope.Scope;

import flash.display.Sprite;

public class Main extends Sprite{


    public function Main() {

        var scope:Scope = new Scope();

        //Scope is an implementation of Resolver that allows configuration at runtime:
        scope.map(Car);
        scope.map(Inspector).toInstance(new Inspector('Tom Barnaby'));

        scope.map(IEngine).toType(SportEngine);
        var sportCar:Car = scope.get(Car);

        scope.map(IEngine).toType(FamilyEngine);//overwrites the mapping to SportEngine
        var familyCar:Car = scope.get(Car);

        sportCar.accelerate();
        trace(sportCar.speed);//120

        familyCar.accelerate();
        trace(familyCar.speed);//50

    }
}
}
