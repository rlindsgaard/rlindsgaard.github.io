Lately me and my team have been working in parts of the code where we needed to setup some objects in a database in order to test different behavior in the UI.

Since the whole logic depends on counting and aggregating over a timeframe I found myself needing to setup a bunch of objects - and I needed to be able to control different attributes for different tests.

Regular python fixtures work quite well when you only care about setting up one object. But what when you need multiple objects, and when you would like to decide exactly how many you get?

Pytest offers a built-in method for doing exactly that: factories.


## Factories, what are they good for?

### Complex setup
### What about a helper?

## When not to use a factory

## A factory template


