# GeoHash #
A horrible (way to much magic here (hardcoded values)) hack implementation of the [GeoHash](http://geohash.org) algorithm to generates a hash from a lat/long based on on nothing but the most basic of understanding from how [wikipedia](https://en.wikipedia.org/wiki/Geohash) described the algorithm going in the opposite direction (Hash to lat/lon).

# Unit Testing results #

    g.parse(lat:42.6, long: -5.6) == "ezs42"
    g.parse(lat:-25.382708, long: -49.265506)=="6gkzwgjzn820"
    g.parse(lat: 37.785834, long: -122.406417) == "9q8yywdq7vbp"
    g.parse(lat:-25.383, long:-49.266) == "6gkzwgjt"
    g.parse(lat:-25.427, long: -49.315) == "6gkzmg1u"
    g.parse(lat:39.2780150, long:-76.7618450) == "dqcrmnrep2ev"
    g.parse(lat:30.2672, long:-97.7431) == "9v6kpvcxh"

# Magic #
I would like to apologize to the world for this, really, but it's not all my [fault](http://smalltownbrewery.com/our-beers/nyfrb-10-7/).

## Hash Codes ##
I did not even try to figure out the pattern, I just hard coded a table to convert numbers (left) to codes (right):

"10" = "b", "11" = "c", "12" = "d", "13" = "e", "14" = "f"<br>
"15" = "g", "16" = "h", "17" = "j", "18" = "k", "19" = "m"<br>
"20" = "n", "21" = "p", "22" = "q", "23" = "r","24" = "s"<br>
"25" = "t", "26" = "u", "27" = "v", "28" = "w", "29" = "x"<br>
"30" = "y", "31" = "z"

## Precision ##
So I'm not sure how people connect precision of decimal places to hash length, and my algorithm required a number of iterations anyways, so I just fudged it Edison style (I can hear Tesla telling me that a little math would have saved me some time. See "fault" above.

    g.guessPrecision(raw: 42.6) == 14
    g.guessPrecision(raw: -25.383) == 20
    g.guessPrecision(raw: 30.2672) == 22
    g.guessPrecision(raw: -25.382708) == 32

# License #

I may change the license, so clone at your own risk.