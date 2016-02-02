unit module Kangaroo::Roles;

role output-parser is export {
  has Int $.passed  = 0;
  has Int $.failed  = 0;
  has Int $.planned = 0;

  has @.oks;
  has @.noks;
  has @.problems;

  method parse(Str $data) {*}
  method fail {*}
  method pass {*}
  method problem(Str $problem) {
    CATCH { default { .perl.say; } }
    @.problems.append($problem);
  }
  method ok(Str $test) {
    CATCH { default { .perl.say; } }
    @.oks.append($test);
  }
  method nok(Str $test) {
    CATCH { default { .perl.say; } }
    @.noks.append($test);
  }
}
