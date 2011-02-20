# Cosmos

Cosmos calculates the sunrise, sunset and solar noon for a given date and location.

## Sample usage

    sun = Cosmos::Solar.new(:date => DateTime.now, :lat => 42.0, :lng => -71.0)
    sun.rise          # => #<DateTime: 2455612.58838365,0,2299161>
    sun.rise.to_s     # => "2011-02-20T02:07:16+00:00"

## Precision

These calculations have a precision of close to 3 minutes (mostly due to approximation). Also, they do not take into account the effect of air temperature, altitude, etc. Together, these may affect the time by 5 minutes or more.

More detail [here](http://users.electromagnetic.net/bu/astro/sunrise-set.php).

## Reference

* [Sunrise equation](http://en.wikipedia.org/wiki/Sunrise_equation)
* [Sunrise equation more](http://users.electromagnetic.net/bu/astro/sunrise-set.php)
* [Julian day](http://en.wikipedia.org/wiki/Julian_Day)

## Contributing to Cosmos

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Greg Sterndale. See LICENSE.txt for
further details.

