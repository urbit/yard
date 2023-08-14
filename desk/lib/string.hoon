  ::  /lib/string
::::  ~lagrev-nocfep
::    Version ~2023.8.14
::
::    A string library supporting common operations for mortals.
::    Gates assume tape input unless suffixed with `-c`.
::
|%
++  alphabet        ^~  `tape`(weld (gulf 65 90) (gulf 97 122))
++  alpha-lower     ^~  `tape`(slag 26 alphabet)
++  alpha-upper     ^~  `tape`(scag 26 alphabet)
++  digits          ^~  `tape`(gulf 48 57)
++  alpha-digits    ^~  `tape`(weld alphabet digits)
++  hexdigits       ^~  `tape`:(weld digits (gulf 65 70) (gulf 97 102))
++  octdigits       ^~  `tape`(gulf 48 55)
++  punctuation     ^~  `tape`:(weld (gulf 32 47) (gulf 58 64) (gulf 91 96) (gulf 123 126))
++  whitespace      ^~  `tape`:(weld " " ~['\0a'] ~['\09'])
++  ascii           ^~  `tape`:(weld alphabet digits punctuation whitespace)
::  Utility sets
++  set-alphabet      ^~  (~(gas in *(set @tD)) alphabet)
++  set-alpha-lower   ^~  (~(gas in *(set @tD)) alpha-lower)
++  set-alpha-upper   ^~  (~(gas in *(set @tD)) alpha-upper)
++  set-digits        ^~  (~(gas in *(set @tD)) digits)
++  set-alpha-digits  ^~  (~(gas in *(set @tD)) alpha-digits)
++  set-hexdigits     ^~  (~(gas in *(set @tD)) hexdigits)
++  set-octdigits     ^~  (~(gas in *(set @tD)) octdigits)
++  set-punctuation   ^~  (~(gas in *(set @tD)) punctuation)
++  set-whitespace    ^~  (~(gas in *(set @tD)) whitespace)
++  set-ascii         ^~  (~(gas in *(set @tD)) ascii)
::
++  is-alpha    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-alphabet)))
++  is-lower    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-alpha-lower)))
++  is-upper    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-alpha-upper)))
++  is-digit    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-digits)))
++  is-alnum    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-alpha-digits)))
++  is-hex      |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-hexdigits)))
++  is-octal    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-octdigits)))
++  is-ascii    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-ascii)))
++  is-decimal  is-digit
++  is-numeric  is-digit
++  is-space    |=(=tape =(~ (~(dif in (~(gas in *(set @tD)) tape)) set-whitespace)))
++  is-title    |=(=tape =((title tape) tape))
::
++  is-knot     |=(=tape ((sane %ta) (crip tape)))
++  is-tas      is-term
++  is-ta       is-knot
++  is-term     |=(=tape ((sane %tas) (crip tape)))
++  is-uc
  |=  =tape
  ^-  ?
  =/  p  (bisk:so [[1 1] tape])
  &(=(+((lent tape)) +>+<+:p) =(%uc +>-<:p))
++  is-ud
  |=  =tape
  ^-  ?
  =/  p  (bisk:so [[1 1] tape])
  &(=(+((lent tape)) +>+<+:p) =(%ud +>-<:p))
++  is-ui
  |=  =tape
  ^-  ?
  =/  p  (bisk:so [[1 1] tape])
  &(=(+((lent tape)) +>+<+:p) =(%ui +>-<:p))
++  is-uv
  |=  =tape
  ^-  ?
  =/  p  (bisk:so [[1 1] tape])
  &(=(+((lent tape)) +>+<+:p) =(%uv +>-<:p))
++  is-uw
  |=  =tape
  ^-  ?
  =/  p  (bisk:so [[1 1] tape])
  &(=(+((lent tape)) +>+<+:p) =(%uw +>-<:p))
++  is-ux
  |=  =tape
  ^-  ?
  =/  p  (bisk:so [[1 1] tape])
  &(=(+((lent tape)) +>+<+:p) =(%ux +>-<:p))
::
::  Convert the string to all upper case.  Synonymous with ++cuss.
++  upper  cuss
::  Convert the string to all lower case.  Synonymous with ++cass.
++  lower  cass
::  Convert the first character to upper case.
++  capitalize  |=(=tape (weld (upper (scag 1 tape)) (slag 1 tape)))
::  Center the string in spaces.
++  center
  |=  [=tape wid=@ud]
  ^-  ^tape
  ?.  (gth wid (lent tape))  tape
  =/  lof  (div (sub wid (lent tape)) 2)
  =/  rof  (sub wid (add lof (lent tape)))
  :(weld `^tape`(zing (reap lof " ")) tape `^tape`(zing (reap rof " ")))
::  Count the number of times a value occurs in the string.
++  count  |=([nedl=tape hstk=tape] (lent (fand nedl hstk)))
::  Produce the index of every match of nedl in hstk as a list of atoms.
++  find-all  fand
::  Does the string start with the given substring?
++  starts-with  |=([=tape subs=tape] ^-(? =(subs (scag (lent subs) tape))))
::  Does the string end with the given substring?
++  ends-with    |=([=tape subs=tape] ^-(? =(subs (slag (lent subs) tape))))
::  Tape-based version of ++join.
++  link
  |=  [sep=tape =(list tape)]
  ^-  tape
  =/  res   (snag 0 list)
  =/  list  (slag 1 list)
  |-
  ?~  list  res
  %=  $
    list  t.list
    res   :(weld res sep i.list)
  ==
::  Repeat a tape as a tape (rather than as (list tape)).
++  echo  |=([=tape n=@ud] ^-(^tape (zing (reap n tape))))
::  Left-justify text with whitespace
++  ljust
  |=  [=tape wid=@ud]
  ^-  ^tape
  ?.  (gth wid (lent tape))  tape
  =/  rof  (sub wid (lent tape))
  (weld tape `^tape`(zing (reap rof " ")))
::  Right-justify text with whitespace
++  rjust
  |=  [=tape wid=@ud]
  ^-  ^tape
  ?.  (gth wid (lent tape))  tape
  =/  lof  (sub wid (lent tape))
  (weld `^tape`(zing (reap lof " ")) tape)
::  Strip whitespace from the left-hand side.
++  lstrip
  |=  =tape
  ^-  ^tape
  |-
  ?.  (is-space ~[(snag 0 tape)])
    tape
  $(tape (slag 1 tape))
::  Strip whitespace from the right-hand side.
++  rstrip
  |=  =tape
  ^-  ^tape
  |-
  ?.  (is-space ~[(snag 0 tape)])
    tape
  $(tape (slag 1 tape))
::  Strip whitespace on both ends.
++  strip  |=(=tape (lstrip (rstrip tape)))
::
++  partition
  |=  [nedl=tape hstk=tape]
  ^-  [l=tape n=tape r=tape]
  =/  l   (scag (need (find nedl hstk)) hstk)
  =/  nr  (slag (need (find nedl hstk)) hstk)
  =/  n   (scag (lent nedl) nr)
  =/  r   (slag (lent nedl) nr)
  [l=l n=n r=r]
::
++  replace
  |=  [bit=tape bot=tape =tape]
  ^-  ^tape
  |-
  =/  off  (find bit tape)
  ?~  off  tape
  =/  clr  (oust [(need off) (lent bit)] tape)
  $(tape :(weld (scag (need off) clr) bot (slag (need off) clr)))
::
++  split
  |=  [sep=tape =tape]
  ^-  (list ^tape)
  =|  res=(list ^tape)
  |-
  ?~  tape  (flop res)
  =/  off  (find sep tape)
  ?~  off  (flop [`^tape`tape `(list ^tape)`res])
  %=  $
    res   [(scag `@ud`(need off) `^tape`tape) res]
    tape  (slag +(`@ud`(need off)) `^tape`tape)
  ==
::
++  rfind  |=([seq=tape =tape] ?~((find seq (flop tape)) ~ `(dec (sub (lent tape) (need (find seq (flop tape)))))))
::
++  title  |=(=tape (link " " (turn (split " " (zing (turn tape (cork trip lower)))) capitalize)))
::
++  zfill
  |=  [=tape wid=@ud]
  ^-  ^tape
  ?.  (gth wid (lent tape))  tape
  =/  lof  (sub wid (lent tape))
  (weld `^tape`(zing (reap lof "0")) tape)
++  grab  |=([n=@ud =tape] ^-(^tape ~[(snag n tape)]))
--
