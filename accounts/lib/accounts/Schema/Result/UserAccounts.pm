package accounts::Schema::Result::UserAccounts;
use base qw/DBIx::Class::Core/;

# Associated table in database
__PACKAGE__->table('usersaccounts');

# Column definition
__PACKAGE__->add_columns(

     'id' => {
         data_type => 'integer',
         is_nullable => 0,
         is_auto_increment => 1,
     },

     'username' => {
         data_type => 'text',
         is_nullable => 0,
     },

     'accountusername' => {
         data_type => 'text',
         is_nullable => 0,
     },

     'accounttype' => {

	data_type => 'text',
	is_nullable => 0,	

     },

 );

 # Tell DBIC that 'id' is the primary key
 __PACKAGE__->set_primary_key('id');

 1;
