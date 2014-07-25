# DI container

An attempt to define an open standard for dependency injection containers for ActionScript.

## Legend

 - Terms that are language keywords or identifiers are marked as `inline code`.
 - A **term** that is defined in this sentence is bold.
 - A ***term*** that was defined in the same section is bold and italic.
 - A *term* that was defined in this document but not in this section is italic.
 - The keywords describing how important a requirement is, are
   - &lt;must&gt; and &lt;must not&gt;: fulfilling all those requirement makes an implementation **compatible**
   - &lt;should&gt; and &lt;should not&gt;: fulfilling all those requirement makes an implementation **conforming**
   - &lt;can&gt; describes additional features, to which an implementation can aim to be ***compatible*** or ***conforming***.
     

## Terminology

### Prerequisites / language constructs

 I. A **definition** is the code or byte code that declares a **type** (a `class` or `interface`) that an **instance** can have.<br/>
 II. A **value** is anything that a `var`iable of a certain ***type*** can contain. (This excludes `undefined`).<br/>
 III. A **dependency** is a ***value***, that is referenced by the ***definition*** of another ***type***.<br/>
 IV. A **type reference** is a ***value*** that has the ***type*** `Class`, it points to a `class` or an `interface`.<br/>
 V. A **method** is a `function` that can be accessed using a ***type*** or a ***value***.<br.>
 VI. A **detectable error** is an instance of type `Error` that is distinct from other errors by its ***type***.

### requirement categories in this document

 1. A **depending** is an *instance* that has *dependencies*.
 2. An **identifier** is a *value* that is used to distinct *dependencies*.
 3. A **resolver** is a `function`, that takes at least one ***identifier*** as argument and tries to return the related *dependency*.
 4. A **provider** is a `function`, that on each invoke either returns a *value* of the same *type* or throws an `Error`.
 5. A **scope** is an *instance* that **specifies** a mapping of ***identifiers*** to *dependencies* to be used by a ***resolver***.


## Requirements


### 1. Depending

> 1. A **depending** is an *instance* that has *dependencies*.

By default each ***depending*** communicates its *dependencies* by code using at least one of the following ways:
 - declaring constructor arguments
 - providing public properties (or setters)
 - providing public *methods* with arguments
 
A  ***depending*** requires that some subset of this will be used to be correctly initialized.<br/>
The mechanisms that allows (the *definition* of) a ***depending*** to make it explicit to the DI container, <br/>
what subset the container should take care of, will be referred to as **inline specifying**.
 
1. A DI container &lt;should&gt; provide **conventions** to allow  ***inline specifying***.
    1. The usage of such a ***convention*** &lt;should not&gt; add a *dependency* to the concrete DI container implementation to the *definition* of a ***depending***.
    1. The usage of such a ***convention*** is allowed add the following kinds of *dependency* to the *definition* of a ***depending***:
        1. A *dependency* to an injected [*resolver*](#3-resolver) or an *interface* representing a *resolver*.
        1. A *dependency* to an [*identifier type*](#23-identifier-types) when supported by the DI container.


### 2. Identifiers

> 2. An **identifier** is a *value* that is used to distinct *dependencies*.

***Identifiers*** are used in two parts of a DI container:
 - when *specifying* something as a resolvable *dependency*
 - when asking a *resolver* for the *specified* *dependency*

1. Two *values* represent the same ***identifier***, when comparing them (with `==`) returns `true`.
1. A DI container &lt;must&gt; support to use all *values* as ***identifiers*** that are equal when compared with them self.
   (This excludes `NaN`.)
   
#### 2.3 Identifier types

A DI container &lt;can&gt; *define* an **identifier type**, which allows to refer to the same ***identifier*** using different *instances*.
When a DI container supports an ***identifier type***, the following requirements **extend** the term ***identifier***,
meaning all requirements throughout this document that use the term 
apply for the (possibly mixed) usage of *value* ***identifiers*** and ***identifier types***.

**The purpose of this optional feature is to support *complex identifiers*,
supporting *identifier types* without supporting *complex identifiers* only increases complexity but doesn't add/change the container.**
    
1. An ***identifier type*** &lt;must&gt; have a *method* that **tests** two ***identifiers*** for similarity: it returns 
    - `true` if both *instances* describe the same ***identifier***
    - `false` otherwise.
1. An *instance* of an ***identifier type*** that has more then one criteria to decide 
   whether it identifies a *dependency* a *resolver* is asked for, is a **complex identifier**.
    1. A ***complex identifier*** &lt;must&gt; have a *method* that takes another ***identifier*** and returns
        - `true` when the other ***identifier*** is ***precise*** enough to be described by the ***complex identifier***.
        - `false` otherwise
1. An ***identifier type*** &lt;must&gt; have a *method* for **comparing** ***identifiers***: it takes two ***identifier*** and
        - returns the more ***precise identifier***
        - returns `null` when they are equally ***precise***
        - throws a *detectable error* when it can not find out the difference
    1. How **precise** or **general** an ***identifier*** is depends on "how much it covers":
        - the most ***general identifiers*** are ***complex identifiers*** that require only one of their criteria to be met (OR-criteria).
        - the next more ***precise identifiers*** are those that only returns `true` when ***compared*** with a single *type reference*
            - when the DI container is able to distinct whether a *type reference* points to a `class` or an `interface`,
              the ***identifiers*** &lt;should&gt; be ordered in a way that `interfaces` that `extend` no other `interface` are the most ***general*** one
              and the most concrete *type* is the most ***precise*** one.
        - the next more ***precise identifiers*** are those that only return `true` when ***compared*** with a single *value* (that is not a *type reference*)
        - the most ***precise identifiers*** are ***complex identifiers*** that require all of their criteria to be met (AND-criteria).
1. When at least one *instance* of an ***identifier type*** has been used to *specify* something as a resolvable *dependency*,&lt;br/>
   all ***identifiers*** that are used to *specify* or *resolve* &lt;must&gt; be ***tested*** in the correct order:
    1. More ***precise identifiers*** &lt;must&gt; be ***tested*** before more ***general*** ones.
    1. Equally ***precise identifiers*** &lt;must&gt; be ***tested*** in the order they have been *specified*.
    1. When *specifying* two ***identifiers*** that both match for a certain ***identifier*** it is called an **ambiguous specifying**,
       because a more ***precise identifier*** will prevent a more ***general*** one from being ***tested*** for this certain ***identifier*** 
       independent of the order they where *specified* in.
        - A DI container &lt;can&gt; allow to ***ambiguous specifying***.
        - A DI container &lt;can&gt; disallow ***ambiguous specifying*** by throwing a *detectable error*.

 
### 3. Resolver

> 3. A **resolver** is a `function`, that takes an ***identifier*** as argument and tries to return the related *dependency*.

1. A ***resolver*** **fails** when nothing has been *specified* for a given *identifier* or any `Error` occurs while resolving.
1. A ***resolver*** &lt;must&gt; **behave consistent** the same way on each ***failing*** invoke:
    1. a **strict** ***resolver*** throws an `Error`
        1. a  ***failing strict resolver*** &lt;should&gt; throw a *detectable error* that is *defined* the DI container.
    1. a **lax** ***resolver*** returns `undefined`
1. A DI container &lt;must&gt; support ***strict resolvers***
1. A DI container &lt;can&gt; support ***lax resolvers***
1. By default a ***resolver*** &lt;must&gt; only **succeed** to resolve a *dependency* for *identifiers* that have been *specified*.
    1. A DI container &lt;can&gt; allow **implicit resolving**, when the *identifier* is a *type* and the container is able to construct an *instance*,
        1. ***implicit resolving*** &lt;must&gt; be activated explicitly by the code that controls the [*scope*](#5-scope).
        1. when activated it &lt;must not&gt; affect the ***consistent behaviour*** of a ***resolver***.
        1. when deactivated the ***resolver*** &lt;must&gt; ***fail*** again for *identifiers* that succeeded while it was active 
1. A ***resolver*** &lt;should&gt; support having a **parent resolver**: When it would ***fail*** to resolve a *dependency*,<br/>
   it delegates resolving for the given *identifier* to it.
    1. The ***consistent behaviour*** of a ***resolver*** may not be altered when a ***parent resolver*** is used, <br/>
       independent of the ***consistent behaviour*** of the ***parent resolvers***.
       
- TODO: how to make sure that the current ***resolver*** is used for resolving subsequent *dependencies*? 
- TODO: maybe we need to extract an own section about ***lax resolvers***, like the one for *identifier types*, as the feature is optional and the requirement of ***consistent behaviour*** has a lot of implications in multiple places. 


### 4. Provider
        
> 4. A **provider** is a `function`, that on each invoke either returns a *value* of the same *type* or throws an `Error`.

1. A ***provider*** either expects a *resolver* as its only argument or has zero arguments
    1. when a ***provider*** expects a *resolver* as first argument it has to be invoked with a *resolver*
    1. when a ***provider*** creates an *instance*, it &lt;must&gt; inject the given *resolver* according to the *inline specifying conventions*
1. A ***provider*** &lt;should&gt; be immutable in a way that each time it is invoked it acts the same way:
    1. a ***provider*** &lt;must not&gt; catch any `Error`, so it fails with the unmodified cause
    1. when it succeeds it always returns an *instance* of the same *type*
        1. a ***provider*** &lt;can&gt; return the same *instance* on each invoke
    1. declaring a ***provider*** &lt;must&gt; `throw` an `Error`, when it is known that invoking it will always `throw` an `Error`.


### 5. Scope

> 5. A **scope** is an *instance* that **specifies** a mapping of ***identifiers*** to *dependencies* to be used by a ***resolver***.

1. A DI container &lt;must&gt; provide at least one of the following possibilities to create ***scopes***:
    - creating a ***scope*** *instance* that has an API that allows to ***specify*** the mapping for the *resolver*
    - *defining* a ***scope*** using inheritance
1. A ***scope*** &lt;must&gt; support its default **instance caching strategy**, meaning when it creates *instances* and how they will be reused:
    - creating a new *instance* for each invoke of *resolver* (**no instance caching**)
    - creating an *instance* on the first invoke of *resolver* and always returning it (**lazy instance caching**)
    - creating an *instance* when ***specified*** and always returning it for each invoke of *resolver* (**eager instance caching**)
1. A ***scope*** &lt;should&gt; support at least two **instance caching strategies**.
    1. A ***scope*** &lt;should&gt; allow to ***specify*** which one to use for an *identifier*.
1.  A ***scope*** &lt;must&gt; have the following **strategy** to ***specify*** the *value* the *resolver* will succeed with when gets invoked with an *identifier*:
    1. When *value* is a *provider*, each time the *resolver* is invoked, <br/>
       the *provider* &lt;must&gt; be invoked the correct way ([see 4.2,4.3](#4-provider)) <br/>
       and its current result &lt;must&gt; be returned by the *resolver*. 
    1. When *value* is not given the *identifier* &lt;should&gt; be used as *value*.
       When this is not supported ***specifying*** only an *identifier* &lt;should not&gt; be compilable or &lt;must&gt; `throw` a *detectable error*.
    1. When *value* is a `Class` reference, based on the ***instance caching strategy***,<br/>
       the *resolver* has &lt;must&gt; return an *instance* of that *type*.
       1. When the *definition* of *value* contains *inline specifying conventions*,<br/>
          the resolved *instance* &lt;must&gt; be returned with injected dependencies
    1. When *value* is none of the above the *resolver* &lt;must&gt; return *value* on each invoke. <br/>
       1. When the *definition* of *value* contains *inline specifying conventions*,
          the resolved *instance* &lt;should&gt; be returned with injected dependencies
1. A ***scope*** &lt;can&gt; allow extending the ***strategy*** to ***specify***, 
   by adding *lax resolvers* that take the ***specified*** *value* as an *identifier* and return a *provider* on success.
    1. An extensible ***strategy*** &lt;must&gt; invoke the added *lax resolvers* between 5.4.2 and 5.4.3.
    1. The order in which the *lax resolvers* are invoked &lt;must&gt; be predictable.
    1. The first *provider* that is returned from one of the added *lax resolvers* &lt;must&gt; be used <br/>
       as if it would have been the given *value* (see 5.4.1)
    1. The order in which the *lax resolvers* are invoked &lt;should&gt; be configurable. 
1. When an *identifier* is ***specified*** multiple times, a ***scope*** &lt;must&gt; always **operate** in one of the following ways:
    - the last ***specify*** overrides the previous one
    - it `throw`s a *detectable error* with a meaningful message
1. A ***scope*** &lt;should&gt; support both ways to ***operate*** an allow to configure which one is active.
1. A ***scope*** &lt;should&gt; allow to remove something ***specified*** with an *identifier*, <br/>
   in a way that *resolving* for the *identifier* lets the *resolver* *fail*. 
1. A ***scope*** &lt;can&gt; allow to ***specify*** a *provider* without as an *identifier*.
    1. The *provider* &lt;must&gt; be correctly invoked immediately and the *type* of the returned *value* &lt;must&gt; be used as the *identifier*.
1. A ***scope*** &lt;can&gt; allow to ask if something has been ***specified*** for an *identifier*.
