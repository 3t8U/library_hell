desc 'Create a database dump'
task :dump, [:db_name] do |t, args|
  system("pg_dump #{args.db_name} > #{args.db_name}_backup.sql")
end
