# as3-depending

>If you have any questions, problems or even suggestions while reading the following, or using the library<br/>
>feel free to contact me via [an issue](https://github.com/karfau/as3-depending/issues/new) or [directly](https://github.com/karfau).<br/>
>You are of course welcome to [fork](https://github.com/karfau/as3-depending/fork) and [do whatever you want with it](https://github.com/karfau/as3-depending/blob/master/UNLICENSE).

## Definition of DI

The term *dependency injection* is a very general one, so I will define what I mean when talking about it:

1. depending classes **communicate** their dependencies
2. **specifying** how to resolve dependencies (e.g. what kind of instance to use that implements the required interface)
3. **creating** instances with **resolved** dependencies

All object oriented application code I know has classes that depend on other classes, so I claim that they all use dependency injection, if understood the way described above.

### understanding the different parts

Lets look at some code

```ActionScript
    public class TweetService{
        private const urlShorter = UrlShorter.getInstance();
        private const tweetClient = new SMSTweetClient();
        
        public function tweet(message:String):void{
            if(message.length >140){
                message = urlShorter.shorten(message);
            }
            if(message.length <= 140){
                tweetClient.post(message);
            }
        }
    }
```

In this case the depending class only **communicates** its dependencies to the compiler, it also **specifies** how to resolve them and also takes care for **resolving** them at **creation** time.
 That is the least flexible way to do it, and it is difficult to test if it works without increasing your bill for SMS.
 
improving the above concerns:
  
```ActionScript
    public class TweetService{
        private var urlShorter:UrlShorter;
        private var tweetClient:ITweetClient;
        
        public function TweetService(shorter:UrlShorter,tweetClient:ITweetClient){
            urlShorter = shorter;
            this.tweetClient = tweetClient;
        }
        
        public function tweet(message:String):void{
            ...
        }
    }
```

Ah, separation of concern for the WIN. Now the class **communicates** its dependency to everybody trying to create an instance. It is up to the creator to **resolve** those dependencies. 
- This simplifies testing because we could mock those dependencies and just make sure the API of those dependencies gets used in the right way.
- Regarding the third part of my definition of DI, the complexity increased: Every place in your application that needs a `TweetClient` needs a way to resolve those dependencies. Writing factories is one approach to keep DRY. But when it comes to more complex object graphs, it is not easy to write factories and keep DRY at the same time, which makes it error prone and less fun. 

### state of the art

To solve this, there exist many "dependency injection libraries / frameworks".
 
Most of them use metadata tags as a (second but explicit) way to **communicate** the dependencies (to the framework). By using the utility classes that are available in AS3 to do something like reflection, they detect those *"annotations"* (at runtime) and try to **create** and / or **resolve** those dependencies. 

As they don't know anything about the application code, they have some configuration or mapping phase, where the application **specifies** how to resolve those dependencies. 

One nice example of how this can look like is [DawnInjections](https://github.com/sammyt/dawn/wiki/DawnInjections).

## the goal of this library

The goals of this library are :
- provide a "generic factory" approach aka "DI container", that is flexible enough to be reused and lets the developer stay DRY (other frameworks also provide this)
- allowing you to resolve the dependencies in an object oriented, type safe and flexible way, ***not relying on reflection*** (using [describeType](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/package.html#describeType%28%29) [or describeTypeJson](http://jacksondunstan.com/articles/2609)) 

As I really like them, I will try to act after these [design principles](https://github.com/sammyt/dawn/wiki/DesignPrinciples).

### creating instances and resolving dependencies

The `Resolver` interface is the "generic factory" I talked about more early.

Implementing it **specifies** how to resolve things, its `get` method uses those specifications to **create** and / or **resolve** things. 

### deciding how to resolve dependencies

Implementing the interface could be done in a way that specifies the mappings at compile time, or it can be as flexible as you like. 
This library provides the implementation `Scope`. Each instance of `Scope` lets the developer write **specifications** as code, and already implements the **creation and resolving** part (an example will follow really soon).

## putting it all together

There are different approaches to communicate dependencies, and it has a lot to do with how instances can be created. 

In the "metadata world" the need for a lot of boilerplate is been taken away from the developer. The other argument for such frameworks is, that a class with dependencies doesn't need to depend on the framework that injects them.

### Option 1: implementing Depending a.k.a. fetching dependencies

As this library is not using "the reflection API", it doesn't have this additional information.
Instead the most simple way to tell a `Resolver` that creates an instance of a class with dependencies is to let the class have a constructor with no arguments and implement the `Depending` interface with its method `fetchDependencies(resolver:Resolver)`. 

Thank God it's code time:

```ActionScript
    public class TweetService implements Depending{
        private var urlShorter:UrlShorter;
        private var tweetClient:ITweetClient;
        
        public function fetchDependencies(resolver:Resolver):void{
            urlShorter = resolver.get(UrlShorter);
            tweetClient = resolver.get(ITweetClient);
        }
        
        public function tweet(message:String):void{
            ...
        }
    }
```

To create an instance you only need to have a properly configured `Resolver`:

```ActionScript
    var tweetService:TweetService = myResolver.get(TweetService);
```

The `resolver` will create an instance of `TweetService` and call `fetchDependencies` using itself as the argument. 
Lets assume `UrlShorter` is a really simple class, with no external dependencies, in this case the `resolver` just creates a new instance of the class. To create an instance of `ITweetClient` the `resolver` has to contain a **specification** for how this dependency should be resolved, before it gets asked for an instance of `TweetService`. If that has not happened, it will throw an `UnresolvedDependencyError`.

### Option 2: constructor injection a.k.a. factory methods

If you don't like classes having to implement an interface to allow DI detection and you love constructor arguments as much as I do, that's easy as pie:

```ActionScript
    public class TweetService{
    
        public static function create(resolver:Resolver):TweetService{
           return new TweetService( resolver.get(UrlShorter), resolver.get(ITweetClient));
        }
    
        private var urlShorter:UrlShorter;
        private var tweetClient:ITweetClient;
        
        public function TweetService(shorter:UrlShorter,tweetClient:ITweetClient){
            urlShorter = shorter;
            this.tweetClient = tweetClient;
        }
        
        public function tweet(message:String):void{
            ...
        }
    }
```

Having something like `create` as a static method, puts an example of how to construct such an object using ***any*** `Resolver` directly available for reuse. But to completely get rid of this dependency inside your class, this method could be anywhere and in this case of course it doesn't need to be static. 

You just need to **specify** that the `Resolver` should use this method to create a `TweetService`.

### using `Scope` and implementing `Resolver`

When implementing `Resolver` you have to take care of **creating instances with resolved dependencies** and **deciding how two resolve** dependencies. 

Lets look at what it looks like to use `Scope`:

```ActionScript
    var scope:Scope = new Scope();

    //Scope is an implementation of Resolver that allows configuration at runtime:
    scope.map(Car);
    scope.map(Inspector).toInstance(new Inspector('Tom Barnaby'));

    scope.map(IEngine).toType(SportEngine);
    var sportCar:Car = scope.get(Car);//finally using the Resolver method to get an instance

    scope.map(IEngine).toType(FamilyEngine);//overwrites the mapping to SportEngine
    var familyCar:Car = scope.get(Car);

    sportCar.accelerate();
    trace(sportCar.speed);//120

    familyCar.accelerate();
    trace(familyCar.speed);//50
```

This should look familiar to everybody that used a modern DI library. 
Feel free to [navigate through the executable code](depending-test/src/as3/depending/examples/factory/Main.as).

As the `Car` class is implementing `Depending` and has a constructor with no arguments as shown in **Option 1** above, you only need to specify the type to `Scope`.

As always there are different ways to do things, so lets look at how an implementation of `Resolver` could [look like](depending-test/src/as3/depending/examples/readme/TweetServiceResolver.as):

```ActionScript
    public class TweetServiceResolver implements Resolver {
    
        public function get(clazz:Class, required:Boolean = true):* {
            var instance:*;
            switch(clazz){
                case TweetService:
                    instance = TweetService.create(this);
                    break;
                case ITweetClient:
                    instance = new TraceTweetClient();
                    break;
                default:
                    instance = new clazz();
            }
            if(instance is Depending){
                Depending(instance).fetchDependencies(this);
            }
    
            return instance;
        }
    }
```

Feel free to [navigate through the executable code](depending-test/src/as3/depending/examples/readme/Main.as).

>If you have any questions, problems or even suggestions while reading the following, or using the library<br/>
>feel free to contact me via [an issue](https://github.com/karfau/as3-depending/issues/new) or [directly](https://github.com/karfau).<br/>
>You are of course welcome to [fork](https://github.com/karfau/as3-depending/fork) and [do whatever you want with it](https://github.com/karfau/as3-depending/blob/master/UNLICENSE).
