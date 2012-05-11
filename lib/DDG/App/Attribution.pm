package DDG::App::Attribution;

use MooX qw(
	Options
);

use Module::Runtime qw( use_module );
use lib ();
use Path::Class;

option 'html' => (
	is => 'ro',
	default => sub { 0 },
	negativable => 1,
);

sub BUILD {
	my ( $self ) = @_;
	my $curdir = dir('lib')->absolute;
	lib->import($curdir->stringify);
	if (@ARGV) {
		for (@ARGV) {
			use_module($_);
			if ($self->html) {
				print $_->get_attributions_html;
				print "\n";
			} else {
				my @attributions = @{$_->get_attributions};
				if (@attributions) {
					print "\nAttributions for ".$_.":\n\n";
					while (@attributions) {
						my $key = shift @attributions;
						my $value = shift @attributions;
						print " - ".$key." (".$value.")\n";
					}
				} else {
					print "\nNo attributions for ".$_."\n\n";
				}
			}
		}
	} else {
		# TODO, load all and show all attributions
	}
	print "\n";
}

1;