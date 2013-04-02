twentyfour
==========

Solve the general case of the [24-challenge puzzle](http://en.wikipedia.org/wiki/24_Game).

I grew up playing 24-challenge in math class, and wondered at a young age how I could programmatically solve the cards. As a much older child, I decided to finally write the algorithm.

This a brute force algorithm that loops through combinations of:
* every permutation of the integer inputs
* every permutation of the operators (including multiples of the same operator)
* every possible order of operations using the selected operators (think of this as using parentheses in every possible place)

See the Sinatra-backed webapp in action here: [http://twentyfour.herokuapp.com](http://twentyfour.herokuapp.com).

The algorithm returns results in less than a second when processing 4 or 5 integers, can just barely handle 6, and poops the bed on 7 or more. If you can write an optimized algorithm to solve this puzzle, I'd love to see it!
