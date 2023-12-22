/+  *test, regex

|%
++  has-match
  |=  [reg=tape pass=(list tape) fail=(list tape)]  ^-  tang
  |^
    %+  weld
      ^-  tang
      %+  roll  pass
      |=  [a=tape b=tang]  ^-  tang
      (weld b (run a %.y))
    ^-  tang
    %+  roll  fail
    |=  [a=tape b=tang]  ^-  tang
    (weld b (run a %.n))
  ::
  ++  run
    |=  [a=tape res=?]  ^-  tang
    =+  result=(expect-eq !>(res) !>((has:regex reg a)))
    ?~  result  result
    %+  weld  result
    ^-  tang
    :~  [%palm [": " ~ ~ ~] [leaf+"pattern" (sell !>(reg)) ~]]
        [%palm [": " ~ ~ ~] [leaf+"subject" (sell !>(a)) ~]]
    ==
  --
++  invalid-regex
  |=  [reg=tape]  ^-  tang
  =/  result=tang  (expect !>(!(valid:regex reg)))
  =/  result=tang
    %+  weld
    (expect !>(!(valid:regex reg)))
    (expect-fail |.((run:regex reg "")))
  ?~  result  result
  :_  ~
  :+  %palm
    [": " ~ ~ ~]
  [leaf+"expected pattern to fail" (sell !>(reg)) ~]
++  capture-groups
  |=  [reg=tape tex=tape res=(list (pair @u tape))]
  =/  result=tang
    %+  expect-eq  !>(res)
    !>  ^-  (list (pair @u tape))
    %+  turn
      %+  sort  ~(tap by (ran:regex reg tex))
      |=  [a=(pair @u range:regex) b=(pair @u range:regex)]
      (lth p.a p.b)
    |=  [a=(pair @u range:regex)]  ^-  (pair @u tape)
    [p.a q.q.a]
  ?~  result  result
  %+  weld  result
  ^-  tang
  :~  [%palm [": " ~ ~ ~] [leaf+"pattern" (sell !>(reg)) ~]]
      [%palm [": " ~ ~ ~] [leaf+"subject" (sell !>(tex)) ~]]
  ==
--

|%
++  test-empty
  ;:  weld
    (has-match "" ~["" "a" "abc" "\0a"] ~)
    (has-match "a|" ~["" "a" "abc" "\0a"] ~)
    (has-match "()" ~["" "a" "abc" "\0a"] ~)
    (has-match "a()b" ~["ab"] ~["" "a" "b"])
    (has-match "a?" ~["" "a" "b"] ~)
    (has-match "(a?)b\\1c" ~["abc" "abac" "bc"] ~["" "bac"])
  ==
++  test-basic-matching
  ;:  weld
    %^  has-match  "a"
    ~["a" " \0aa" "a \0a"]
    ~["" "\0a" "bcdef"]
  ::
    %^  has-match  "123\0a"
    ~["123\0a" " \0a123\0a" "123\0a \0a"]
    ~["" "\0a" "123" "\0a123"]
  ::
    %^  has-match  "quick brown fox"
    ~["quick brown fox" "the quick brown fox"]
    ~["Quick brown fox"]
  ::
    %^  has-match  "\\^\\$\\.\\|\\?\\+\\*\\()\\[]\\\{}\\\\"
    ~["^$.|?+*()[]\{}\\"]
    ~["^$.|?+*\{}\\" "^$." "?+*()[]\{}"]
  ::
    %^  has-match  "."
    ~["." "a" "^" "$" "(" ")" "\0a"]
    ~[""]
  ::
    %^  has-match  "a.c"
    ~["abc" "a-c" "a\\c" "a\00c"]
    ~["ac"]
  ::
    %^  has-match  "^\00+$"
    ~["\00" "\00\00\00"]
    ~[""]
  ::
    %^  has-match  "\\x00\\x01\\x02\\x03\\x04\\x05\\x06\\x07\\x08\\x09\\x0a\\x0b\\x0c\\x0d\\x0e\\x0f\\x10\\x11\\x12\\x13\\x14\\x15\\x16\\x17\\x18\\x19\\x1a\\x1b\\x1c\\x1d\\x1e\\x1f\\x20\\x21\\x22\\x23\\x24\\x25\\x26\\x27\\x28\\x29\\x2a\\x2b\\x2c\\x2d\\x2e\\x2f\\x30\\x31\\x32\\x33\\x34\\x35\\x36\\x37\\x38\\x39\\x3a\\x3b\\x3c\\x3d\\x3e\\x3f\\x40\\x41\\x42\\x43\\x44\\x45\\x46\\x47\\x48\\x49\\x4a\\x4b\\x4c\\x4d\\x4e\\x4f\\x50\\x51\\x52\\x53\\x54\\x55\\x56\\x57\\x58\\x59\\x5a\\x5b\\x5c\\x5d\\x5e\\x5f\\x60\\x61\\x62\\x63\\x64\\x65\\x66\\x67\\x68\\x69\\x6a\\x6b\\x6c\\x6d\\x6e\\x6f\\x70\\x71\\x72\\x73\\x74\\x75\\x76\\x77\\x78\\x79\\x7a\\x7b\\x7c\\x7d\\x7e\\x7f\\x80\\x81\\x82\\x83\\x84\\x85\\x86\\x87\\x88\\x89\\x8a\\x8b\\x8c\\x8d\\x8e\\x8f\\x90\\x91\\x92\\x93\\x94\\x95\\x96\\x97\\x98\\x99\\x9a\\x9b\\x9c\\x9d\\x9e\\x9f\\xa0\\xa1\\xa2\\xa3\\xa4\\xa5\\xa6\\xa7\\xa8\\xa9\\xaa\\xab\\xac\\xad\\xae\\xaf\\xb0\\xb1\\xb2\\xb3\\xb4\\xb5\\xb6\\xb7\\xb8\\xb9\\xba\\xbb\\xbc\\xbd\\xbe\\xbf\\xc0\\xc1\\xc2\\xc3\\xc4\\xc5\\xc6\\xc7\\xc8\\xc9\\xca\\xcb\\xcc\\xcd\\xce\\xcf\\xd0\\xd1\\xd2\\xd3\\xd4\\xd5\\xd6\\xd7\\xd8\\xd9\\xda\\xdb\\xdc\\xdd\\xde\\xdf\\xe0\\xe1\\xe2\\xe3\\xe4\\xe5\\xe6\\xe7\\xe8\\xe9\\xea\\xeb\\xec\\xed\\xee\\xef"
    ~["\00\01\02\03\04\05\06\07\08\09\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f\20\21\22\23\24\25\26\27\28\29\2a\2b\2c\2d\2e\2f\30\31\32\33\34\35\36\37\38\39\3a\3b\3c\3d\3e\3f\40\41\42\43\44\45\46\47\48\49\4a\4b\4c\4d\4e\4f\50\51\52\53\54\55\56\57\58\59\5a\5b\5c\5d\5e\5f\60\61\62\63\64\65\66\67\68\69\6a\6b\6c\6d\6e\6f\70\71\72\73\74\75\76\77\78\79\7a\7b\7c\7d\7e\7f\80\81\82\83\84\85\86\87\88\89\8a\8b\8c\8d\8e\8f\90\91\92\93\94\95\96\97\98\99\9a\9b\9c\9d\9e\9f\a0\a1\a2\a3\a4\a5\a6\a7\a8\a9\aa\ab\ac\ad\ae\af\b0\b1\b2\b3\b4\b5\b6\b7\b8\b9\ba\bb\bc\bd\be\bf\c0\c1\c2\c3\c4\c5\c6\c7\c8\c9\ca\cb\cc\cd\ce\cf\d0\d1\d2\d3\d4\d5\d6\d7\d8\d9\da\db\dc\dd\de\df\e0\e1\e2\e3\e4\e5\e6\e7\e8\e9\ea\eb\ec\ed\ee\ef\f0\f1\f2\f3\f4\f5\f6\f7\f8\f9\fa\fb\fc\fd\fe\ff"]
    ~
  ==
++  test-case-sensitivity
  ;:  weld
    %^  has-match  "(?i)abc(?-i)def"
    ~["abcdef" "ABCdef" "Abcdef"]
    ~["abcDEF" "ABCDEF"]
  ::
    %^  has-match  "a|(?i)(?-i)b|c"
    ~["a" "b" "c"]
    ~["" "A" "C"]
  ::
    %^  has-match  "a|(?i)b|c"
    ~["a" "b" "B" "c" "C"]
    ~["" "A"]
  ::
    %^  has-match  "a(?i)|b|c"
    ~["a" "b" "B" "c" "C"]
    ~["" "A"]
  ::
    %^  has-match  "(?i)a((?-i)b|c)d"
    ~["abd" "acd" "AbD" "AcD"]
    ~["aBd" "aCd"]
  ::
    %^  has-match  "a((?i)bc)d"
    ~["abcd" "aBCd"]
    ~["Abcd" "abcD"]
  ==
++  test-unmatched-braces
  ;:  weld
    %^  has-match  "abc)+def"
    ~["abc)def" "abc))def" "abc)))def"]
    ~["abcdef"]
  ::
    %^  has-match  "(abc))def)"
    ~["abc)def)"]
    ~["abcdef)" "abc)def" "abcdef"]
  ::
    (has-match "a)]}b" ~["a)]}b"] ~["ab"])
  ==
++  test-anchors
  ;:  weld
    %^  has-match  "^abc$"
    ~["abc"]
    ~["xabc" "abcy" "x\0aabc" "x\0aabc\0ay" "abc\0ay"]
  ::
    %^  has-match  "^$"
    ~[""]
    ~["a" "\0a" "a\0a" "a\0a\0ab" "a\0ab"]
  ::
    %^  has-match  "(abc|^)def"
    ~["abcdef" "def"]
    ~["bcdef"]
  ::
    %^  has-match  "\\ba\\b"
    ~["a-" "-a" "-a-"]
    ~["a_" "_a" "_a_"]
  ::
    %^  has-match  "\\by\\b"
    ~
    ~["xy" "yz" "xyz"]
  ::
    %^  has-match  "\\Ba\\B"
    ~["_a_"]
    ~["a_" "_a" "a-" "-a" "-a-"]
  ::
    %^  has-match  "\\By\\b"
    ~["xy"]
    ~["xyz"]
  ::
    %^  has-match  "\\by\\B"
    ~["yz"]
    ~["xyz"]
  ::
    %^  has-match  "\\By\\B"
    ~["xyz"]
    ~["yz"]
  ::
    %^  has-match  "\\b"
    ~["a" " a" ".a"]
    ~["" " " ". ."]
  ::
    %^  has-match  "\\B"
    ~["" "aa" "a.aa"]
    ~["a" "a.a"]
  ::
    %^  has-match  "\\<"
    ~["a" "-a" "_" "-_"]
    ~["" "-"]
  ::
    %^  has-match  "\\>"
    ~["a" "a-" "_" "_-"]
    ~["" "-"]
  ::
    %^  has-match  "b.*\\<"
    ~["b a" "bcd a"]
    ~["b"]
  ::
    %^  has-match  "\\>.*b"
    ~["a b" "a ab"]
    ~["b" "b " "ab"]
  ==
++  test-alternation
  ;:  weld
    %^  has-match  "((a|bc)d)|xyz"
    ~["ad" "bcd" "xyz"]
    ~["abc" "abcxy"]
  ::
    %^  has-match  "(a|^)bc(d|$)"
    ~["bc" "xabc" "bcdy" "xabcdy"]
    ~["xbc" "bcy" "xbcy" "xabcy"]
  ::
    %^  has-match  "^a*b"
    ~["b" "ab" "aab" "aab"]
    ~["xb" "axb" "axab"]
  ::
    %^  has-match  "^(a|ab)+$"
    ~["a" "ab" "aababaaaaaababaab"]
    ~["b" "abb" "aaaaabbaa"]
  ::
    %^  has-match  "^a+(abcd|xy)$"
    ~["aabcd" "aaabcd" "axy" "aaxy"]
    ~["abcd" "xy"]
  ::
    %^  has-match  "^(foo|ba.)+$"
    ~["foobarbaz"]
    ~["" "fodbar"]
  ::
    %^  has-match  "^(abc|)*xyz$"
    ~["xyz" "abcxyz" "abcabcxyz"]
    ~["abccxyz"]
  ::
    %^  has-match  "^(abc|)+xyz$"
    ~["xyz" "abcxyz" "abcabcxyz"]
    ~["abccxyz"]
  ::
    %^  has-match  "^(a|)+"
    ~["" "a" "aa" "aaa" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
    ~
  ==
++  test-repetition
  ;:  weld
    %^  has-match  "^(abc)\{1,2}zz"
    ~["abczz" "abcabczz"]
    ~["zz" "abcabcabczz" ">>abczz"]
  ::
    %^  has-match  "^(b+|a)\{1,2}c"
    ~["bc" "bbc" "bbbc" "bac" "bbac" "aac" "abbbbbbbbbbbc" "bbbbbbbbbbbac"]
    ~["aaac" "abbbbbbbbbbbac"]
  ::
    %^  has-match  "A\\x00\{2,3}Z"
    ~["The A\00\00Z" "An A\00\00\00Z"]
    ~["A\00Z"]
  ::
    %^  has-match  "ab\{1,3}bc"
    ~["abbbbc" "abbbc" "abbc"]
    ~["abc" "abbbbbc"]
  ::
    %^  has-match  "a+b+c"
    ~["aabbabc"]
    ~
  ::
    %^  has-match  "a\{1,}b\{1,}c"
    ~["aabbabc"]
    ~
  ::
    %^  has-match  "(a+|b)*"
    ~["ab"]
    ~
  ::
    %^  has-match  "(a+|b)\{0,}"
    ~["ab"]
    ~
  ::
    %^  has-match  "(a+|b)+"
    ~["ab"]
    ~
  ::
    %^  has-match  "(a+|b)\{1,}"
    ~["ab"]
    ~[""]
  ::
    %^  has-match  "(a+|b)?"
    ~["ab" "a" "b"]
    ~
  ::
    %^  has-match  "^(a+|b)\{0,1}$"
    ~["" "a" "aaa" "b"]
    ~["ab"]
  ::
    %^  has-match  "^(\\d*(\\s+|\\s*$))*$"
    ~["123" "123 " "123 456" "123 456 " "123 456 789"]
    ~["123abc"]
  ::
    (invalid-regex "?")
    (invalid-regex "*")
    (invalid-regex "+")
    (invalid-regex "(?.)")
    (invalid-regex "(*.)")
    (invalid-regex "(+.)")
  ==
++  test-character-classes
  ;:  weld
    %^  has-match  "[.]"
    ~["." "a."]
    ~["a" "b" "c" "\0a"]
  ::
    %^  has-match  "[^.]"
    ~["a" "b" "c" "\0a" ".a"]
    ~["."]
  ::
    %^  has-match  "[^]]"
    ~["a" "-"]
    ~["]" ""]
  ::
    %^  has-match  "[^]-]"
    ~["a" " "]
    ~["]" "-" ""]
  ::
    %^  has-match  "[^-]"
    ~["a" "]"]
    ~["-" ""]
  ::
    %^  has-match  "[^-]]"
    ~["a]" "]]" " ]"]
    ~["]" "-]" "] "]
  ::
    %^  has-match  "[^][]"
    ~["a" " " "-"]
    ~["[" "]" ""]
  ::
    %^  has-match  "^[X-c]+$"
    ~["XYZ_^abc"]
    ~["xyz_^ABC" "xyz" "ABC"]
  ::
    %^  has-match  "(?i)^[X-c]+$"
    ~["XYZ_^abc" "xyz_^ABC" "xyz" "ABC"]
    ~["!" "\"" "#" "$" "%" "&" "'" "(" ")" "+" "," "-" "." "/"]
  ::
    %^  has-match  "^[[:ascii:]]+$"
    ~["\00\0aabc\7f"]
    ~["\80"]
  ::
    %^  has-match  "^[[:alnum:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"]
    ~["-" "." "~" "\0a" "\09"]
  ::
    %^  has-match  "^[[:alpha:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
    ~["-" "." "~" "\0a" "\09" "0" "9"]
  ::
    %^  has-match  "^[[:blank:]]+$"
    ~[" \09"]
    ~["\0a" "\0d"]
  ::
    %^  has-match  "^[[:cntrl:]]+$"
    ~["\00\01\02\03\04\05\06\07\08\09\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f\7f"]
    ~[" " "a" "\7e" "\ff"]
  ::
    %^  has-match  "^[[:digit:]]+$"
    ~["0123456789"]
    ~["a"]
  ::
    %^  has-match  "^\\d+$"
    ~["0123456789"]
    ~["a"]
  ::
    %^  has-match  "^\\D+$"
    ~["abcdef"]
    ~["0" "9" "a123456789"]
  ::
    %^  has-match  "^[\\d]+$"
    ~["0123456789"]
    ~["a"]
  ::
    %^  has-match  "^[\\D]+$"
    ~["abcdef"]
    ~["0" "9" "a123456789"]
  ::
    %^  has-match  "^[[:graph:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`\{|}~"]
    ~["\00" "\09" "\0a"]
  ::
    %^  has-match  "^[[:lower:]]+$"
    ~["abcdefghijklmnopqrstuvwxyz"]
    ~["A"]
  ::
    %^  has-match  "^\\l+$"
    ~["abcdefghijklmnopqrstuvwxyz"]
    ~["A"]
  ::
    %^  has-match  "\\L"
    ~["A"]
    ~["abcdefghijklmnopqrstuvwxyz"]
  ::
    %^  has-match  "^[\\l]+$"
    ~["abcdefghijklmnopqrstuvwxyz"]
    ~["A"]
  ::
    %^  has-match  "[\\L]"
    ~["A"]
    ~["abcdefghijklmnopqrstuvwxyz"]
  ::
    %^  has-match  "^[[:print:]]+$"
    ~["abcdef "]
    ~["\00" "\0a"]
  ::
    %^  has-match  "^[[:punct:]]+$"
    ~["!\"#$%&'()*+,-./:;<=>?@[\\]^_`\{|}~"]
    ~["a" "b" "c" "\00" "\0a"]
  ::
    %^  has-match  "^[[:space:]]+$"
    ~[" \09\0a\0b\0c\0d"]
    ~["A" "a"]
  ::
    %^  has-match  "^\\s+$"
    ~[" \09\0a\0b\0c\0d"]
    ~["A" "a"]
  ::
    %^  has-match  "\\S"
    ~["A" "a"]
    ~[" \09\0a\0b\0c\0d"]
  ::
    %^  has-match  "^[\\s]+$"
    ~[" \09\0a\0b\0c\0d"]
    ~["A" "a"]
  ::
    %^  has-match  "[\\S]"
    ~["A" "a"]
    ~[" \09\0a\0b\0c\0d"]
  ::
    %^  has-match  "^[[:upper:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
    ~["a"]
  ::
    %^  has-match  "^\\u+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
    ~["a"]
  ::
    %^  has-match  "\\U"
    ~["a"]
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
  ::
    %^  has-match  "^[\\u]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
    ~["a"]
  ::
    %^  has-match  "[\\U]"
    ~["a"]
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
  ::
    %^  has-match  "^[[:xdigit:]]+$"
    ~["ABCDEFabcdef0123456789"]
    ~["G" "g" "\00" "\0a"]
  ::
    %^  has-match  "^[[:word:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"]
    ~["-" "." "~" "\0a" "\09"]
  ::
    %^  has-match  "^[\\w]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"]
    ~["-" "." "~" "\0a" "\09"]
  ::
    %^  has-match  "[\\W]"
    ~["-" "." "~" "\0a" "\09"]
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"]
  ::
    %^  has-match  "^[[:alpha:][:digit:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"]
    ~["-" "." "~" "\0a" "\09"]
  ::
    %^  has-match  "[[:^alpha:]]"
    ~["-" "." "~" "\0a" "\09" "1" "2" "3"]
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
  ::
    %^  has-match  "[[:^alpha:][:digit:]]"
    ~["-" "." "~" "\0a" "\09" "1" "2" "3"]
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
  ::
    %^  has-match  "^[\\U\\L]+$"
    ~["ABC" "abc" "0123456789" "-"]
    ~[""]
  ::
    %^  has-match  "(?i)^[[:upper:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
    ~
  ::
    %^  has-match  "(?i)^[[:lower:]]+$"
    ~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
    ~
  ::
    %^  has-match  "^[:alpha:]+$"
    ~[":alpha:" "aaaa:aaaa:aaaa:aaaa"]
    ~["abc" "[alpha]"]
  ::
    %^  has-match  "^[abc\\]def]+$"
    ~["abc]def"]
    ~["[abc\\]def]"]
  ::
    %^  has-match  "^[]^$.|?+*()[\{}\\\\]+$"
    ~["^$.|?+*()[]\{}\\"]
    ~
  ::
    %^  has-match  "^[\\^$.|?+*()[\{}\\\\\\]]+$"
    ~["^$.|?+*()[]\{}\\"]
    ~
  ::
    %^  has-match  "[^]^$.|?+*()[\{}\\\\]"
    ~["^$.|?+*()[]\{}\\a"]
    ~["^$.|?+*()[]\{}\\"]
  ::
    %^  has-match  "\\a\\t\\n\\v\\f\\r\\e"
    ~["\07\09\0a\0b\0c\0d\1b"]
    ~
  ::
    %^  has-match  "[\\a][\\b][\\t][\\n][\\v][\\f][\\r][\\e]"
    ~["\07\08\09\0a\0b\0c\0d\1b"]
    ~
  ::
    %^  has-match  "^[\\x00-\\b]+$"
    ~["\00" "\00\01\02\03\04\05\06\07\08"]
    ~["\09" "\0a"]
  ::
    %^  has-match  "^[ --]+$"
    ~[" !\"#$%&'()+,-"]
    ~["." "/" "a" "b" "c"]
  ::
    %^  has-match  "[-ac]"
    ~["-" "a" "c"]
    ~["b"]
  ::
    %^  has-match  "[ac-]"
    ~["-" "a" "c"]
    ~["b"]
  ::
    %^  has-match  "[-ac-]"
    ~["-" "a" "c"]
    ~["b"]
  ::
    %^  has-match  "[-a-c-]"
    ~["-" "a" "b" "c"]
    ~
  ::
    %^  has-match  "[---]"
    ~["-"]
    ~["+" "," "." "/"]
  ::
    %^  has-match  "[\\B]"
    ~["B"]
    ~["ab"]
  ::
    (invalid-regex "[a--]")
    (invalid-regex "[a--z]")
    (invalid-regex "[a-[:digit]]")
    (invalid-regex "[a-\\w]")
    (invalid-regex "[[:digit:]-a]")
    (invalid-regex "[a-b-c]")
    (invalid-regex "[a---c]")
    (invalid-regex "[]")
    (invalid-regex "[^]")
    (invalid-regex "[[::]]")
    (invalid-regex "[[:a:]]")
  ==
++  test-backreferences
  ;:  weld
    %^  has-match  "(abc|xyz)\\1"
    ~["abcabc" "xyzxyz"]
    ~["abcxyz" "xyzabc"]
  ::
    %^  has-match  "(((((((((a|)))))))))\\8\\9"
    ~["" "a" "aa" "aaa"]
    ~
  ::
    %^  has-match  "(a)(b)(c)(d)(e)(f)(g)(h)(i)\\8\\9"
    ~["abcdefghihi"]
    ~["abcdefgh"]
  ::
    %^  has-match  "(foo|ba.)\\1"
    ~["foofoo" "barbar" "bazbaz"]
    ~["foobar" "barbaz"]
  ::
    %^  has-match  "^(11+)\\1+$"
    ~["1111" "111111" "11111111" "111111111" "1111111111" "111111111111"]
    ~["1" "11" "111" "11111" "1111111" "11111111111" "1111111111111"]
  ::
    %^  has-match  "^(a|)\\1*b"
    ~["ab" "aaaab" "b"]
    ~["acb"]
  ::
    %^  has-match  "^(a|)\\1+b"
    ~["aab" "aaaab" "b"]
    ~["ab"]
  ::
    %^  has-match  "^(a|)\\1?b"
    ~["ab" "aab" "b"]
    ~["acb"]
  ::
    %^  has-match  "^(a|)\\1\{2}b"
    ~["aaab" "b"]
    ~["ab" "aab" "aaaab"]
  ::
    %^  has-match  "^(a|)\\1\{2,3}b"
    ~["aaab" "aaaab" "b"]
    ~["ab" "aab" "aaaaab"]
  ::
    %^  has-match  "^(((a+)|b)(\\>\\s*))*\\3$"
    ~["aaa b aaa" "aaa b aa aa" "b a a"]
    ~["aaa b aa aaa"]
  ::
    %^  has-match  "(?i)(abc|def)\\1"
    ~["abcABC" "ABCabc" "defDEF" "DEFdef"]
    ~["abcdef" "defabc"]
  ::
    %^  has-match  "(abc)(?i)\\1"
    ~["abcABC" "abcAbc"]
    ~["ABCabc" "Abcabc" "AbcAbc"]
  ==
++  test-lookahead
  ;:  weld
    %^  has-match  "(?=abc)abc"
    ~["abc"]
    ~["ABC"]
  ::
    %^  has-match  "(?=(?i)abc)abc"
    ~["abc"]
    ~["ABC"]
  ::
    %^  has-match  "(?i)(?=ABC)abc"
    ~["abc" "ABC"]
    ~
    ::
    %^  has-match  "(?=abc(?!abcdef))(abc)\\1"
    ~["abcabc" "abcabcde" "abcabc def"]
    ~["abcabcdef"]
  ==
++  test-capture-groups
  ;:  weld
    %^  capture-groups  "(foo)"  "foo"
    ~[[0 "foo"] [1 "foo"]]
  ::
    %^  capture-groups  "a|b+"  "abbb"
    ~[[0 "a"]]
  ::
    %^  capture-groups  "(a|b+)*"  "abbb"
    ~[[0 "abbb"] [1 "bbb"]]
  ::
    %^  capture-groups  "(bb|bbb)bb"  "bbbb"
    ~[[0 "bbbb"] [1 "bb"]]
  ::
    %^  capture-groups  "(a)|(aa)"  "aa"
    ~[[0 "aa"] [2 "aa"]]
  ::
    %^  capture-groups  "(a)a|(aa)"  "aa"
    ~[[0 "aa"] [1 "a"]]
  ::
    %^  capture-groups  "(a?)b"  "b"
    ~[[0 "b"] [1 ""]]
  ::
    %^  capture-groups  "(([[:alnum:]]*)( *))*"  "100 ABC"
    ~[[0 "100 ABC"] [1 "ABC"] [2 "ABC"] [3 ""]]
  ::
    %^  capture-groups  "(([[:alnum:]]*)( *))*"  "100 ABC "
    ~[[0 "100 ABC "] [1 "ABC "] [2 "ABC"] [3 " "]]
  ::
    %^  capture-groups  "(abc|abcd)(d|d\{5})"  "abcdddd"
    ~[[0 "abcdd"] [1 "abcd"] [2 "d"]]
  ::
    %^  capture-groups  "(abc|abcd)(d|d\{5})"  "abcddddd"
    ~[[0 "abcddddd"] [1 "abc"] [2 "ddddd"]]
  ::
    %^  capture-groups  "(abc|abcd)(d|d\{5})"  "abcdddddd"
    ~[[0 "abcdddddd"] [1 "abcd"] [2 "ddddd"]]
  ::
    %^  capture-groups  "(abc|abcd)(|d\{4,5})"  "abcddddd"
    ~[[0 "abcddddd"] [1 "abcd"] [2 "dddd"]]
  ::
    %^  capture-groups  "(abc|abcd)(|d\{4,5})"  "abcdddddd"
    ~[[0 "abcdddddd"] [1 "abcd"] [2 "ddddd"]]
  ==
++  test-convenience-functions
  ;:  weld
    (expect-fail |.((run:regex "?" "")))
    (expect-fail |.((ran:regex "a" "")))
    (expect-fail |.((rut:regex "?" "")))
    (expect-fail |.((rat:regex "a" "")))
  ::
    %-  expect-eq  :_  !>((rut:regex "abc" "abcdef"))
    !>(`(unit range:regex)``[[[1 1] [1 4]] "abc"])
  ::
    %-  expect-eq  :_  !>((rat:regex "abc" "abcdef"))
    !>(`range:regex`[[[1 1] [1 4]] "abc"])
  ::
    %-  expect-eq  :_  !>((alt:regex "(\\w\{3})?" "abcdefghi"))
    !>  ^-  (list range:regex)
    :~  [[[1 1] [1 4]] "abc"]
        [[[1 4] [1 7]] "def"]
        [[[1 7] [1 10]] "ghi"]
    ==
  ::
    (expect-eq !>(`~`~) !>((is:regex "a" "aaa")))
    (expect-eq !>(`~`~) !>((is:regex "ab" "abab")))
    (expect-eq !>(`~`~) !>((is:regex "[ab]" "ab")))
    (expect-eq !>(`~`~) !>((is:regex "[[:^space:]]" "a")))
    (expect-eq !>(`(unit hair)``[1 4]) !>((is:regex "a" "aaab")))
    (expect-eq !>(`(unit hair)``[1 5]) !>((is:regex "ab" "ababa")))
    (expect-eq !>(`(unit hair)``[1 3]) !>((is:regex "[ab]" "abc")))
    (expect-eq !>(`(unit hair)``[1 2]) !>((is:regex "[[:^space:]]" "a ")))
    (expect-eq !>(`~`~) !>((as:regex "a" "aaa")))
    (expect-eq !>(`~`~) !>((as:regex "ab" "abab")))
    (expect-eq !>(`~`~) !>((as:regex "[ab]" "ab")))
    (expect-eq !>(`~`~) !>((as:regex "[[:^space:]]" "a")))
    (expect-fail |.((as:regex "a" "aaab")))
    (expect-fail |.((as:regex "ab" "ababa")))
    (expect-fail |.((as:regex "[ab]" "abc")))
    (expect-fail |.((as:regex "[[:^space:]]" "a ")))
  ::
    %+  expect-eq
    !>(`(unit range:regex)``[[[1 3] [1 4]] "a"])
    !>((fort:regex "a" [1 2] "a a"))
  ::
    (expect-eq !>(`~`~) !>((fort:regex "a" [1 2] "a b")))
  ::
    %+  expect-eq
    !>(`(unit range:regex)``[[[1 2] [1 2]] ""])
    !>((fort:regex "a*" [1 2] "a b"))
  ::
    %+  expect-eq
    !>(`(unit range:regex)``[[[1 2] [1 4]] "aa"])
    !>((fort:regex "a*" [1 2] "aaab"))
  ==
--
