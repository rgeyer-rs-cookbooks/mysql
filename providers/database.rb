include Opscode::Mysql::Database

action :flush_tables_with_read_lock do
  Chef::Log.info "mysql_database: flushing tables with read lock"
  db.query "flush tables with read lock"
  if new_resource.respond_to? 'updated_by_last_action'
    new_resource.updated_by_last_action(true)
  else
    new_resource.updated = true
  end
end

action :unflush_tables do
  Chef::Log.info "mysql_database: unlocking tables"
  db.query "unlock tables"
  if new_resource.respond_to? 'updated_by_last_action'
    new_resource.updated_by_last_action(true)
  else
    new_resource.updated = true
  end
end

action :create_db do
  unless @mysqldb.exists
    Chef::Log.info "mysql_database: Creating database #{new_resource.database}"
    db.query("create database #{new_resource.database}")
    if new_resource.respond_to? 'updated_by_last_action'
      new_resource.updated_by_last_action(true)
    else
      new_resource.updated = true
    end
  end
end

def load_current_resource
  @mysqldb = Chef::Resource::MysqlDatabase.new(new_resource.name)
  @mysqldb.database(new_resource.database)
  exists = db.list_dbs.include?(new_resource.database)
  @mysqldb.exists(exists)
end
