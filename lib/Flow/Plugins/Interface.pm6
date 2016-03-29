unit module Flow::Plugins::Interface;
use Flow::App;
use Flow::Utils::Cursor;

sub s-m($data, $len, :$ltr = True) {
  return $data.Str ~ (' ' x ($len - $data.Str.chars)) if     $ltr;
  return (' ' x ($len - $data.Str.chars)) ~ $data.Str unless $ltr;
}

multi MAIN('test', :$depth = 1) is export {
  MAIN('test', 't', :$depth);
}

multi MAIN('test', *@dirs, :$depth = 1) is export {
  my $app = Flow::App.new;

  my $ending-out = '';
  my $index      = 0;
  my $str-r      = '.'.IO.abspath;

  #"    # | Plan // Pass | File Name".say;
  my %cursord;
  my $cursori = 0;
  my $cursord = 0;
  $app.supply.act(-> $test {
    if $test<tested> {
      my $f = $test<path>.subst($*CWD.IO.abspath).substr(1);
      if ! so %cursord{$f} {
        %cursord{$f} = %(
          idx => $cursord++
        );
        home; br;
      }
      while $cursori != %cursord{$f}<idx> {
        $cursori++, down if $cursori < %cursord{$f}<idx>;
        $cursori--, up   if $cursori > %cursord{$f}<idx>;
      } 
      tl;
      print "{$f.substr(0,15)} { $test<data>.pass ?? '✓' !! '✗' }{' ' x 24}";
    }

    #  $index++;
    #  "[{ $test<data>.pass ?? '✓' !! '✗' }] $index | {s-m($test<data>.planned, 5)}//{s-m($test<data>.passed, 5, :!ltr)} | { $test<path>.substr($str-r.chars+1) }".say;
    #  my $eout = ''; 
    #  $eout ~= $test<data>.noks.join("\n").lines.map({ .subst(/^^/, '   ') }).join("\n");
    #  $eout ~= $test<data>.problems.join("\n").lines.map({ .subst(/^^/, '   ') }).join("\n");
    #  if $eout {
    #    $ending-out ~= "Test #$index - output\n$eout\n";
    #  }
    #}
    if $test<msg> eq 'test' {
      my $f = $test<file>.subst($*CWD.IO.abspath, '').substr(1);
      if ! so %cursord{$f} {
        %cursord{$f} = %(
          idx => $cursord++
        );
        home; br;
      }
      while $cursori != %cursord{$f}<idx> {
        $cursori++, down if $cursori < %cursord{$f}<idx>;
        $cursori--, up   if $cursori > %cursord{$f}<idx>;
      } 
      tl;
      print "{$f.substr(0, 15)} {$test<test>.substr(0, 25)}";

      #"{$test<result>} {$test<test>}".say;
    }
  });

  $app.test-dir(@dirs.map({ $_.IO.abspath }), :DIR-RECURSION($depth));

  $app.wait;
  %cursord.perl.say;
  "\n$ending-out".say if $ending-out.trim ne '';
#  sleep .1;
}

