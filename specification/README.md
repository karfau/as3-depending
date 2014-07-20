# Scopes

An attempt to define an open standard for dependency injection containers for ActionScript.

## Terminology

I. A *definition* is the code that creates a *type* (a `class` or `interface`) that an *instance* can have.
II. A *value* is anything that a variable of a certain type can contain. (Any legal value or reference other then `undefined`).

1. A **dependency** is a *value*, that is referenced by the *definition* of another *type*.
2. A **depending** is an *instance* that has ***dependencies***.
3. An **identifier** is a *value* that is used to distinct ***dependencies***.
4. A **resolver** is a `function`, that takes an ***identifier*** as argument and tries to return the related ***dependency***.
6. A **provider** is a `function`, that on each invoke either returns a *value* of the same *type* or throws an `Error`.
7. A **scope** is an instance that specifies a mapping of ***identifiers*** to ***dependencies*** to be used by a ***resolver***.
