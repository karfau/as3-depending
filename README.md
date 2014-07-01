as3-depending
=============

dependency injection with focus on the object that has dependencies. Inspired by Guice, using interfaces instead of "reflection".

The basic idea is easily expressed in two interfaces:

- A class that implements `Depending` needs to implement the method `fetchDependencies` that has one parameter of type `Resolver`.
- A `Resolver` provides the method ```getByType(type:Class,required:Boolean = true)```.

Lets look at some [code](depending-test/src/as3/depending/examples/readme):
```
import as3.depending.Depending;
import as3.depending.Resolver;

import flash.display.Sprite;

public class Main extends Sprite implements Depending {

    public var model:IModel;

    public function fetchDependencies(resolver:Resolver):void {
        model = resolver.getByType(IModel);
    }
    
}
```

This was inspired by [this article from Manfred Karrer](http://www.screenshot.at/blog/2012/01/31/dependency-injection-without-reflection/), especially by the last section where he concludes that:

> So you may ask that **fetching dependencies is not the same like injecting them**, and classes should get the dependencies from outside instead of fetching them from inside.
> [...]
> It is **not about getting or fetching**, it it about to keep the class clean from static dependencies.`

The inclusion of dependencies into your application code, can of course be seen as a drawback. 
I think it is not too bad, because 
1. you only add dependencies to really simple interfaces, not to an implementation.
2. you don't need to implement `Depending`, you could have any method taking a `Resolver` to handle dependencies, even a static one. Which would reduces the dependencies to one interface.

What about this boilerplate code that needs to be written to wire the object?
* it will be more performant then any approach to detect properties of your objects that need injection.
* your properties can be private or protected
* there will always be code for this, either by some DI framework or inside your application. So why not put it inside the class that should know best where to put what, encapsulated in a straight forward method.

 



