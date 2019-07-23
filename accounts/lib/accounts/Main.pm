package accounts::Main;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {

  my $self = shift;

  $self->render('main/index');
}

1;
