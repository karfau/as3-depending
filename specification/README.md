# Scopes

An attempt to define an open standard for dependency injection containers for ActionScript.

## Terminology

I. A *definition* is the code that creates a *type* (a `class` or `interface`) that an *instance* can have.
II. A *value* is anything that a variable of a certain type can contain. (Any legal value or reference other then `undefined`).
III. A *dependency* is a *value*, that is referenced by the *definition* of another *type*.

1. A **depending** is an *instance* that has ***dependencies***.
2. An **identifier** is a *value* that is used to distinct ***dependencies***.
3. A **resolver** is a `function`, that takes an ***identifier*** as argument and tries to return the related ***dependency***.
4. A **provider** is a `function`, that on each invoke either returns a *value* of the same *type* or throws an `Error`.
5. A **scope** is an instance that specifies a mapping of ***identifiers*** to ***dependencies*** to be used by a ***resolver***.

