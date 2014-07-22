# Scopes

An attempt to define an open standard for dependency injection containers for ActionScript.

## Legend

 - A **term** is defined in this sentence is bold.
 - A ***term*** that was defined in the same section sentence is bold and italic.
 - A *term* that was defined in this document but not in this section is italic.
 - Terms that are language keywords or identifiers are marked as `inline code`.
 - TODO: how to emphasize the keywords must, should and can?

## Terminology

### Prerequisites / language constructs

 I. A **definition** is the code that creates a **type** (a `class` or `interface`) that an **instance** can have.<br/>
 II. A **value** is anything that a variable of a certain type can contain. (Any legal value or reference other then `undefined`).<br/>
 III. A **dependency** is a ***value***, that is referenced by the ***definition*** of another ***type***.<br/>

### specified in this document

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
 - providing public methods with arguments
 
A  ***depending*** requires that some subset of this will be used to be correctly initialized.
The mechanisms that allows (the definition of) a ***depending*** to make it explicit to the container, what subset the container should take care of, will be referred to as **inline specifying**.
 
1. A DI container should provide conventions to allow  ***inline specifying***.
    1. Using these conventions may not enforce direct or indirect, global or static dependencies to the (definition of a) ***depending***, that would bind ***depending*** to the concrete implementation of the container.
    1. When using such convention requires to execute code of the container, it has to be done by injecting a [*resolver*](#3-resolver) or via an `interface`.


### 2. Identifiers

> 2. An **identifier** is a *value* that is used to distinct *dependencies*.

***Identifiers*** are used in two parts of dependency injection:
 - when *specifying* something as a resolvable *dependency*
 - when asking a *resolver* for the *specified* *dependency*

Examples of the value an identifier can have that a DI container must support:
 - a `Class` instance ( can be a reference to a `class` or an `interface`)
 - a `String`
 - `NaN`
 - `0`
 - `null`
 - any `Object` instance
 
 
### 3. Resolver

> 3. A **resolver** is a `function`, that takes at least one ***identifier*** as argument and tries to return the related *dependency*.

1. A ***resolver*** can **fail** to resolve a *dependency* for one of two reasons: 
    1. nothing has been *specified* for the given *identifier(s)*
    1. an Error occurs while resolving.
1. When a ***resolver*** ***fails*** each invoke has to **behave** in the same way:
    1. a **strict** ***resolver*** throws an `Error` 
    1. a **lax** ***resolver*** returns `undefined`
1. A DI container must have ***strict*** ***resolvers***
1. A DI container can support ***lax*** ***resolvers***
1. By default a ***resolver*** can only resolve a *dependency* by using the specified *identifier*.
    1. When a DI container allows **implicit resolving**, where the *identifier* is a type and the container is able to construct an instance,
        1. it has to be activated explicitly by the code that controls the [*scope*](#5-scope).
        1. when activated it may not affect the ***behaviour*** of a ***resolver***.
        1. when deactivated the ***resolver*** should ***fail*** again for *identifiers* that succeeded while it was active 
1. A ***resolver*** should support having a **parent resolver**: When it can resolve a ***resolver***, <br/>
   it delegates resolving to it for the specified *identifier* just before it would ***fail***.
    1. The ***behaviour*** of a ***resolver*** may not be altered when a ***parent resolver*** is used, <br/>
       independent of the ***behaviour*** of the ***parent resolvers***'s behaviour
    1. TODO: how to make sure that the current ***resolver*** is used for resolving subsequent *dependencies*? 
1. When a ***resolver*** supports more then one *identifier* as arguments
    1. each additional *identifier* works as a constraint to the earlier one
        1. the ***resolver*** can only succeed when it can fulfil all constraints, when it ***fails*** it should ***behave*** as expected.


### 4. Provider
        
> 4. A **provider** is a `function`, that on each invoke either returns a *value* of the same *type* or throws an `Error`.

1. A ***provider*** either expects a *resolver* as its only argument or has zero arguments
    1. when a ***provider*** expects a *resolver* as first argument it has to be invoked with a *resolver*
    1. when a ***provider*** creates an instance, it should inject the given *resolver* according to the *inline specifying* conventions
1. A ***provider*** should be immutable in a way that each time it is invoked it **behaves** the same way:
    1. a ***provider*** must not catch any `Error`, so it fails with the unmodified cause
    1. when it succeeds it always returns an instance of the same type
        1. a provider can return the same instance on each invoke
    1. declaring a ***provider*** must `throw` an `Error`, when it is known that invoking it will always `throw` an `Error`.


### 5. Scope

> 5. A **scope** is an *instance* that **specifies** a mapping of ***identifiers*** to *dependencies* to be used by a ***resolver***.

1. A DI container must provide at least one of the following possibilities to create ***scopes***:
    - creating a ***scope*** *instance* that has an API that allows to ***specify*** the mapping for the *resolver*
    - *defining* a ***scope*** using inheritance
1. A ***scope*** must support its default **instance caching strategy**, meaning when it creates *instances* and how they will be reused:
    - creating a new *instance* for each invoke of *resolver* (**no instance caching**)
    - creating an *instance* on the first invoke of *resolver* and always returning it (**lazy instance caching**)
    - creating an *instance* when *specified* and always returning it for each invoke of *resolver* (**eager instance caching**)
1. A ***scope*** should support at least two **instance caching strategies**.
    1. A ***scope*** should allow to ***specify*** which one to use for an *identifier*.
1.  A ***scope*** must have the following **strategy** to ***specify*** that when the *resolver* gets invoked with an *identifier*, 
    it resolves the *dependency* depending on the specified *value*:
    1. When *value* is a *provider*, each time the *resolver* is invoked, <br/>
       the *provider* should be invoked the correct way [see 4.2,4.3](#4-provider) <br/>
       and its current result must be returned by the *resolver*. 
    1. When *value* is not specified the *identifier* should be used as *value*.
    1. When *value* is a `Class` reference, depending on the ***instance caching strategy***,<br/>
       the *resolver* has must return an instance of that type.
       1. When the *definition* of *value* contains *inline specifying* conventions,<br/>
          the resolved instance must be returned with injected dependencies
    1. When *value* is none of the above the *resolver* must return *value* on each invoke. <br/>
       1. When the *definition* of *value* contains *inline specifying* conventions,
          the resolved instance should be returned with injected dependencies
1. A ***scope*** can allow extending the ***strategy*** to ***specify***, 
   by adding *lax resolvers* that can return a *provider* depending on the specified *value*.
    1. An extensible ***strategy*** must invoke the specified *lax resolvers* between 5.4.2 and 5.4.3.
    1. The order in which the *lax resolvers* are invoked must be predictable.
    1. The first *provider* that is returned from one of the specified *lax resolvers* must be used <br/>
       as if it would have been the specified *value* (see 5.4.1)
    1. The order in which the *lax resolvers* are invoked should be configurable. 
1. When an *identifier* is ***specified*** multiple times, a ***scope*** must always behave in one of the following ways:
    - the last ***specify*** overrides the previous one
    - an `Error` with a specif message is thrown
1. A ***scope*** should support both behaviours an allow to configure which one is the active behaviour.
1. A ***scope*** should allow to remove something ***specified*** with an *identifier*, <br/>
   in a way that *resolving* for the *identifier* lets the *resolver* *fail*. 
1. When the resolver supports more then one *identifier* ([3.7](#3-resolver)) a ***scope*** should allow to ***specify*** more *identifier*. <br/>
    1. each additional *identifier* works as a constraint to the earlier one
1. A ***scope*** can allow to ***specify*** a *provider* as an *identifier*.
    1. The *provider* must be correctly invoked immediately and the type of the returned value must be used as the *identifier*
1. A ***scope*** can allow to ask if something has been ***specified*** for an *identifier*.
