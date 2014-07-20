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
 3. A **resolver** is a `function`, that takes an ***identifier*** as argument and tries to return the related *dependency*.
 4. A **provider** is a `function`, that on each invoke either returns a *value* of the same *type* or throws an `Error`.
 5. A **scope** is an instance that **specifies** a mapping of ***identifiers*** to *dependencies* to be used by a ***resolver***.


## Requirements


### 1. Depending

> 1. A **depending** is an *instance* that has *dependencies*.

By default ***depending***s communicate their dependencies by code using at least one of the following ways:
 - declaring constructor arguments
 - providing public properties (or setters)
 - providing public methods with arguments
A  ***depending*** requires that some subset of this will be used to be correctly initialized.
 
A DI container should provide conventions to allow a ***depending*** to make it explicit to the container what this subset is.
These mechanisms can be referred to as **inline specifying**.


### 2. Identifiers

> 2. An **identifier** is a *value* that is used to distinct *dependencies*.

***Identifiers*** are used in two parts of dependency injection:
 1. when *specifying* something as a resolvable *dependency*
 2. when asking a *resolver* for the *specified* *dependency*

Examples of the value an identifier can have that a DI container must support:
 - a `Class` instance ( can be a reference to a `class` or an `interface`)
 - a `String`
 - `NaN`
 - `0`
 - `null`
 - any `Object` instance
 
 
