# as3-depending

## Definition of DI

The term *dependency injection* is a very general one, so I will define what I mean when talking about this subject:

1. depending classes **communicate** their dependencies
2. **deciding how to resolve** dependencies (e.g. what kind of instance to use that implements the required interface)
3. using those decision(s) to **create** instances with **resolved** dependencies

All object oriented application code I know has classes that depend on other classes, so I claim that they all use dependency injection, if understood the way described above.

## understanding the different parts

Lets look at some code

    public class TweetService{
        private const urlShorter = UrlShorter.getInstance();
        private const tweetClient = new SMSTweetClient();
        
        public function tweet(message:String):void{
            if(message.length >140){
                message = urlShorter.shorten(message);
            }
            if(message.length >140){
                message = tweetClient.post(message);
            }
        }
    }

In this case the depending class only **communicates** its dependencies to the compiler, it is also responsible for the **decision how to resolve** them and also **resolves** them at **creation** time.
 That is the least flexible way to do it, and each time you use the class, even when only testing if it works, your bill for SMS increases.
 
 improving the above concerns:
  
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

Ah, separation of concern for the WIN. Now the class **communicates** its dependency to everybody trying to create an instance. **How to resolve** those dependencies is up to the creating instance. 
- This simplifies testing because we could mock those dependencies and just make sure the API of those dependencies gets used in the right way.
- Regarding the third part of my definition of DI, the complexity increased: Every place in your application that needs a `TweetClient` needs a way to resolve those dependencies. Writing factories is one approach to keep DRY. But when it comes to more complex object graphs, it is not easy to write factories and keep DRY at the same time, which makes it error prone and less fun. 

## state of the art

To solve this, there are a lot "dependency injection libraries/ frameworks" out there.
 
Most of them use metadata tags as a (second but explicit) way to communicate the dependencies (to the framework). By using the (badly performing) utility classes that are available in AS3 to simulate reflection, they look at the information available about a class or instance (at runtime) and try to **create and/or resolve** those dependencies. 

As they don't know anything about the application code, they have some configuration or mapping phase, where the application tells the "framework" its **decisions how to resolve** those dependencies. 

One nice example of how this can look like is here: [DawnInjections](https://github.com/sammyt/dawn/wiki/DawnInjections).

## the goal of this library

The goals of this library are :
- provide a generic "factory" approach, that is flexible enough to be reused and lets the developer to stay dry (as others do)
- instead of relying on analysing metadata tags at runtime, allowing you to resolve the dependencies in a flexible and object oriented way  

As I really like them, I will try to act after these [design principles](https://github.com/sammyt/dawn/wiki/DesignPrinciples).

### creating instances and resolving dependencies

The `Resolver` interface with its `get` method is the generic factory I talked about more early.

It returns an instance of the given type, with all its dependencies resolved. 

As it is an interface, it can be totally up to the implementation how this is done: 

### deciding how to resolve dependencies

Implementing the interface could be done in a way that defines the mappings at compile time, or it can be as flexible as you like. As such an interface without an implementation will not help to stay DRY, `Scope` is an implementation which allows to configure those mappings at runtime without the need to implement the interface.

## putting it all together

There are different approaches to communicate dependencies, and it has a lot to do with how instances can be created. 

In the "metadata world" the need for a lot of boilerplate is been taken away from the developer, which sometimes makes it look like magic. The other argument for such frameworks is, that a class with dependencies doesn't need to depend on the framework that injects them.

### Option 1: implementing Depending a.k.a. fetching dependencies

As this library is not using "the reflection API", it doesn't have this additional information.
Instead the most simple way to tell a `Resolver` that creates an instance of a class with dependencies is to let the class have a constructor with no arguments and implement the `Depending` interface with its method `fetchDependencies(resolver:Resolver)`. 

Thank God it's code time:

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

To create an instance you only need to have a properly configured `Resolver`:
 
    var tweetService:TweetService = myResolver.get(TweetService);

The resolver will create an instance of `TweetService` and call `fetchDependencies` using itself as the argument. 
Lets assume `UrlShorter` is a really simple class, with no external dependencies, in this case the resolver just creates a new instance of the class. To create an instance of ITweetClient the resolver needs to know how this dependency should be resolved, before it gets asked for an instance of `TweetService`. If that has not happened, it will throw an `UnresolvedDependencyError`.

### Option 2: constructor injection a.k.a. factory methods

If you don't like classes having to implement an interface to allow DI detection and you love constructor arguments as much as I do? Easy as pie:


    public class TweetService{
    
        public static function create(resolver:Resolver):TweetClient{
           return new TweetClient( resolver.get(UrlShorter), resolver.get(ITweetClient));
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

Having something like `create` as a static method, puts an example of how to construct such an object using ***any*** `Resolver` directly available for reuse. But to completely get rid of this dependency inside your class, this method could be anywhere and in this case of course it doesn't  need to be static. 

Just make sure the resolver that should be able to create a `TweetService` knows about it.


