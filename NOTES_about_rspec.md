The more I work with Rspec the less I understand about its popularity. This is an overly complex DSL that strives to simplify your tests but actually makes them less readable.

pass. and pass_with - how to abort after the first?


something that logically belongs together, such as "run the operation with following input" and "then, the model should look as follows", is split into two parts, just to satisfy the user DSL, making things like transporting state a lot more complex, internally. Again, just to satisfy a verbose test DSL. 


1. let the code run as it's run in production
2. assert it

BLOG> Test as many edge cases as possible with as little code as possible.


count parenthesis RSpec vs Minitest. Also, it's not that we didn't try to make the syntax as simple as possible

overiding same-named matchers is far more complicated than in "pure Ruby" Minitest, where you can even use {super}.
