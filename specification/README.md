# Scopes

An attempt to define an open standard for dependency injection containers for ActionScript.

## Legend

 - A **term** is defined in this sentence is bold.
 - A ***term*** that was defined in the same section sentence is bold and italic.
 - A *term* that was defined in this document but not in this section is italic.
 - Terms that are language keywords or identifiers are marked as `inline code`.


## Terminology

### Prerequisite / language constructs

 I. A **definition** is the code that creates a **type** (a `class` or `interface`) that an **instance** can have.<br/>
 II. A **value** is anything that a variable of a certain type can contain. (Any legal value or reference other then `undefined`).<br/>
 III. A **dependency** is a ***value***, that is referenced by the ***definition*** of another ***type***.<br/>

### For this document

 1. A **depending** is an *instance* that has *dependencies*.
 2. An **identifier** is a *value* that is used to distinct *dependencies*.
 3. A **resolver** is a `function`, that takes at least one ***identifier*** as argument and tries to return the related *dependency*.
 4. A **provider** is a `function`, that on each invoke either returns a *value* of the same *type* or throws an `Error`.
 5. A **scope** is an instance that **specifies** a mapping of ***identifiers*** to *dependencies* to be used by a ***resolver***.


## Requirements


### 1. Depending

> 1. A **depending** is an *instance* that has *dependencies*.

By default a ***depending*** communicate their dependencies by code using at least one of the following ways:
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

1. When a ***resolver*** instance can not resolve a *dependency* each invoke has to **behave** in the same way:
    1. a **strict** ***resolver*** throws an `Error` 
    1. a **lax** ***resolver*** returns `undefined`
1. By default a ***resolver*** can only resolve a *dependency* by using the specified *identifier*.
    1. When a DI container allows **implicit resolving**, where the *identifier* is a type and the container is able to construct an instance,
        1. it has to be activated explicitly by the code that controls the [*scope*](5-scope).
        1. when activated it may not affect the ***behaviour*** of a resolver.
        1. when deactivated resolvers that succeeded while it was active, should fail again 
1. When a resolver supports more then one *identifier* as arguments
    1. each additional identifier works as a constraint to the earlier one
        1. the ***resolver*** can only succeed when it can fulfil all constraints, when it fails it should ***behave*** as expected.
        
