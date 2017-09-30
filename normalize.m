function gb = normalize(gb) %normalizes all matrix values so they sit between 0 and 1

gb = ( gb - min(gb(:)) ) / ( max(gb(:)) - min(gb(:)) );