# '#{t:var}'       => human readable time
# '#{d:path}'      => trim file from path
# '#{b:path}'      => trim dir from path
# '#{=3:@v}'       => trim text (foobar -> foo)
# '#{=-3:@v}'      => trim text (foobar -> bar)
# '#{=|5|...:@v}'  => trimmed on right ('foobar' -> 'fooba...')
# '#{=|-5|...:@v}' => trimmed on right ('foobar' -> '...oobar')
# '#{p9:@v}baz'    => pad text (foobar -> 'foobar   baz')
# '#{p-9:@v}baz'   => pad text (foobar -> '   foobarbaz')
# '#{=3;p-6:@v}'   => combine ('foobar' -> '   foo   ')

# Comparison
# '#{#,}'                    => escaped comma
# '#{==:#{@v}bar,foobar}'    => if v#{bar} == foobar then 1 else 0
# '#{!=:#{@v}bar,foobar}'    => if v#{bar} != foobar then 1 else 0
# '#{<:#{@v},bar}'           => if v < bar then 1 else 0
# '#{||:0,#{@v}}'            => if 0 || #{v} then 1 else 0
# '#{&&:0,#{@v}}'            => if 0 && #{v} then 1 else 0
# '#{?@v,yes,no}'            => if #{v} then yes else no
# '#{?#{==:#{@v},0},yes,no}' => if #{v} == 0 then yes else no
# '#{?#{==:#{@v},0},#{@v} is true,#{@v} is false}'  => if #{v} == 0 then '#{v} is true' else '#{v} is false'

# Substitution
# '#{s|foo|bar|:@v}'            => s/foo/bar @v
# '#{s|(foo)(bar)|\2\1|:@v}'    => s/(foo)(bar)/\2\1 @v
# '#{s|#{@w}|xxx|:@v}'          => s/#w/xxx @v
# '#{s|FOO|xxx|i:@v}'           => s/FOO/xxx/i @v
# '#{s|foo|xxx|;s|bar|yyy|:@v}' => s/foo/xxx;s/bar/yyy @v

# Arithmetic
# '#{e|+|:1,1}'       => 2
# '#{e|-|:1,1}'       => 0
# '#{e|*|:1,1}'       => 1
# '#{e|/|f|4:10,3}'   => 3.3333
# '#{e|m|:4,3}'       => 1

# Matching
# '#{m:*foo*,#{@v}}'     => v=foobar; 1 if pattern matches else 0 (1)
# '#{m|ri:^FOO,#{@v}}'   => v=foobar; r=regex i=ignore_case; 1 if pattern matches else 0 (1)

# C = searches for format in pane content; returns line number or 0
# '#{C:x*z}'
# '#{C|r:x.z}'

# Loops (S W P)
# '#{W:#{window_name} }'      => irssi mutt emacs ksh ksh ksh ksh ksh ksh emacs emacs ksh
# '#{W:#{window_name} ,--- }' => irssi mutt emacs ksh ksh ksh ksh ksh --- emacs emacs ksh

# Literals and Quoting
#   - l = literal string given to it
#   - q = quote special chars
# '#{?#{l:1},a,b}'
# '#{q:@v}'

# Expand more than once (E T)
# '#{status-left}'   => [#{session_name}]
# '#{T:status-left}' => [0]
