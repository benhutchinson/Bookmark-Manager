env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}") 
# telling datamapper to use a postgres database on localhost.
# the name is either "bookmark_manager_test" or "bookmark_manager_development" 
# this depends on the environment env

DataMapper.finalize
# after declaring the models, finalize them.

DataMapper.auto_upgrade!
# DataMapper then creates the database tables
# if the tables don't exist, they will be created

# if they do exist and you changed the schema 
# (e.g. changed the type of one of the properties)
# they will not be upgraded because that would lead to data loss

# if you want to force the creation of all tables
# as they are described in your models (even if this leads to data loss)
# the following command can be used: DataMapper.auto_migrate!

# and before you do any of this, you do need to create a database