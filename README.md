as3-depending
=============

The term *dependency injection* is a very generel one, so I will define what I mean when talking about this subject:

1. depending classes **communicate** their dependencies
2. **deciding how to resolve** dependencies (e.g. what kind of instance to use that implements the required interface)
3. using those decision(s) to **create** instances with **resolved** dependencies


All object oriented application code I know has classes that depend on other classes, so I claim that they all use dependency injection, if understood the way described above.

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

In this case the depending class only **communicates** ist dependencies to the compiler, it is also responsible for the **decision how to resolve** them and also **resolves** them at **creation** time.
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
- This simplifies tests because we could mock those dependencies and just make sure the API of those dependencies gets used in the right cases.
- For the third part of my definition of DI, the complexity increased: Either every place your application that needs a `TweetClient` now also needs to know about `UrlShorter` and some `ITweetclient`, or you are starting to write factories to keep DRY. But it is not easy to write factories and keep DRY at the same time, which makes it error prone and less fun. And I think it (just) moves the problem to another place in the code, and not having a more generic approach available, makes creating complex object graphs a pain.

To solve this, there are a lot "dependency injection libraries/ frameworks" out there. 
Most of them use metadata tags as a (second but explicit) way to communicate the dependencies (to the framework). By using the (badly performing) utility classes that are available in AS3 to simulate reflection, (at runtime) they look at the information available about a class or instance and try to **create and/or resolve** those dependencies. 
As they don't know anything about the application code, they have some configuration or mapping phase, where the application tells the "framework" its **decisions how to resolve** those dependencies. 

*work in progress*

