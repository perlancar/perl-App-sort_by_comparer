package App::sort_by_comparer;

use 5.010001;
use strict;
use warnings;
use Log::ger;

use AppBase::Sort;
use AppBase::Sort::File ();
use Perinci::Sub::Util qw(gen_modified_sub);

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

gen_modified_sub(
    output_name => 'sort_by_comparer',
    base_name   => 'AppBase::Sort::sort_appbase',
    summary     => 'Sort lines of text by a Comparer module',
    description => <<'MARKDOWN',

This utility lets you sort lines of text using one of the available Comparer::*
perl modules.

MARKDOWN
    add_args    => {
        %AppBase::Sort::File::argspecs_files,
        comparer_module => {
            schema => "perl::comparer::modname_with_optional_args",
            pos => 0,
        },
    },
    modify_args => {
        files => sub {
            my $argspec = shift;
            #delete $argspec->{pos};
            #delete $argspec->{slurpy};
        },
    },
    modify_meta => sub {
        my $meta = shift;

        $meta->{examples} = [
            {
                src_plang => 'bash',
                src => q[ someprog ... | sort-by-comparer similarity=string,foo],
                test => 0,
                'x.doc.show_result' => 0,
            },
        ];
    },
    output_code => sub {
        require Module::Load::Util;

        my %oc_args = @_;

        AppBase::Sort::File::set_source_arg(\%oc_args);
        $args{_gen_comparer} = sub {
            my $gc_args = shift;
            Module::Load::Util::call_module_function_with_optional_args(
                {ns_prefix=>"Comparer", function=>"gen_comparer"},
                $gc_args->{comparer_module});
        };
        AppBase::Sort::sort_appbase(%args);
    },
);

1;
# ABSTRACT:
