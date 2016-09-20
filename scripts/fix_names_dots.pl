perl -i -p -e 'if( s/>([^\|]+)\|/>$1 /) {} else { s/\./-/g; }' *.trim
