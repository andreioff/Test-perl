package accounts::Schema::Result::User;
use base qw/DBIx::Class::Core/;

# Associated table in database
__PACKAGE__->table('users');

# Column definition
__PACKAGE__->add_columns(

     'id' => {
         data_type => 'integer',
         is_nullable => 0,
         is_auto_increment => 1,
     },

     'user' => {
         data_type => 'char',
         is_nullable => 0,
         size => 31,
     },

     'password' => {
         data_type => 'text',
         is_nullable => 0,
         size => 50,
     },

 );

 # Tell DBIC that 'id' is the primary key
 __PACKAGE__->set_primary_key('id');
