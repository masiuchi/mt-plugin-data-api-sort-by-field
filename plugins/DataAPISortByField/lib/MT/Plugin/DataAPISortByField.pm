package MT::Plugin::DataAPISortByField;
use strict;
use warnings;
use utf8;

use MT;
use MT::Meta;

sub callback {
    my ( $cb, $app, $filter, $opt, $cols ) = @_;

    return unless $opt->{sort_by} =~ /^field:/;

    ( my $sort_by = delete $opt->{sort_by} ) =~ s/^field://;
    my $sort_order = delete $opt->{sort_order} || 'descend';

    my $ds        = $filter->object_ds;
    my $class     = MT->model($ds);
    my $meta_type = MT::Meta->metadata_by_name( $class, "field.$sort_by" );

    push @{ $opt->{args}{joins} ||= [] },
        [
        $class->meta_pkg,
        undef,
        { "${ds}_id" => \"= ${ds}_id", },
        {   sort      => $meta_type->{type},
            direction => $sort_order,
        },
        ];
}

1;

