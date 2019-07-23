package accounts;
use Mojo::Base 'Mojolicious';
use Schema;
use DBIx::Class;

# This method will run once at server start
sub startup {

  my $self = shift;

  $self->defaults(layout => 'default');

  $self->secrets(['This secret is used for new sessions', 'This secret is used only for validation']);
  $self->app->sessions->cookie_name('accounts');
  $self->app->sessions->default_expiration('600');

  my $connection = Schema->connect('dbi:Pg:dbname=accounts;host=127.0.0.1', 'postgres', 'postgres', {AutoCommit => 1});
  $connection->deploy();

  $self->helper(datab => sub { return $connection; });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('main#index');

  $r->get('/login')->name('login_form')->to(template => 'login/login_form');
  $r->post('/login')->name('do_login')->to('Login#on_user_login');

  my $authorized = $r->under('/user')->to('Login#is_logged_in');
  $authorized->get('/')->name('restricted_area')->to(template => 'user/overview');

  $r->route('/logout')->name('do_logout')->to(cb => sub{

    my $self = shift;
    $self->session(expires => 1);

    $self->redirect_to('/');

  });

}

1;
