- Tests should check either success or failure

For tests where “failure” can be represented by a certain value, such as an empty result or integer code, it is “easy” to cover this with another iteration of the test you already wrote.

For the uninitiated reader (i.e anyone else than you) the fact that this is an error is often hidden and must be extracted by examining the application and test code closely.

By separating your tests into “success” and “failure” scenarios, you descriptively convey this information just by looking at the assertions or the naming.

## Conditionals and Expressions on arguments

Regular unit tests should not contain branches - there should be only one execution path through the test.

For test-generators, take care to not also “build” your query based on the test parameters. If you cannot use them directly, you are trying to cover different equivalence classes at once.

```
@pytest.mark.parametrize('op,left,right,expect', [
    ('add', 5, 5, 10),
    ('sub', 5, 5, 0),
    ('div', 5, 5, 1),
    ('pow', 5, 2, 25),
])
def test_calculator(op, left, right, expect):
    func = get_attr(Calculator, op)
    result = func(left, right)
    assert result == expect

```

 
- Test matrices 

Test matrices a by definition an order more complex than simple generators. 


## De-duplication of Tests

It happens quite often that similar logic is implemented for different entities - e.g CRUD operations.

Using a test-generator is a great way to ensure consistency and test against regressions.

However, if you iterate over different entities or “entries” — keep in mind that these, may be subject to differing business policy.

By checking behavior via a test-generator you create an inference rule, you should do this only if this is in fact a business rule. The application logic you test should therefore also be subjected to the same de-duplication around the logic you’re testing, otherwise you tightly couple accidental similar behavior, making the application code harder to test.

By creating an inference on “what is here right now”, and even though that might be valid presently, if it is not an actual policy that it applies to all Xs — but is merely coincidence, you risk making future development harder by locking down the interface due to a wrong abstraction.