require 'data_mapper'
require './app/data_mapper_setup'

task :auto_upgrade do 
  # this function makes non-destructive
  # changes. if your tables don't exist
  # they will be created but if they
  # do exist and you changed your
  # scheme (i.e. the type of one of the
  # properties), they will not be 
  # upgraded in case that led to data loss.

  DataMapper.auto_upgrade!
  puts "Auto-upgrade complete (no data loss)"
end

task :auto_migrate do 
  # to force the creation of all tables
  # as they are described in your models, 
  # even if this could lead to data loss, 
  # use auto_migrate

  DataMapper.auto_migrate!
  puts "Auto-migrate complete (data could have been lost)"
end

  # a database obviously needs to 
  # be created first.