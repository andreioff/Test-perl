package accounts;
use Mojo::Base 'Mojolicious';
use accounts::Schema;
use DBIx::Class;

# This method will run once at server start
sub startup {

  my $self = shift;

  $self->defaults(layout => 'default');

  $self->secrets(['This secret is used for new sessions', 'This secret is used only for validation']);
  $self->app->sessions->cookie_name('accounts');
  $self->app->sessions->default_expiration('600');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('main#index');

  $r->get('/login')->name('login_form')->to(template => 'login/login_form');
  $r->post('/login')->name('do_login')->to('Login#on_user_login');

  $r->get('/register')->name('register_form')->to(template => 'register/register_form');
  $r->post('/register')->name('do_register')->to('Register#createUser');

  my $authorized = $r->under('/user')->to('Login#is_logged_in');
  $authorized->get('/')->name('restricted_area')->to('UserOverview#showAccounts');
  $authorized->post('/')->name('add_account')->to('UserOverview#addAccount');
  $authorized->get('/:id')->name('delete_account')->to('UserOverview#deleteAccount');


  $r->route('/logout')->name('do_logout')->to(cb => sub{

    my $self = shift;
    $self->session(expires => 1);

    $self->redirect_to('/');

  });

}

1;
