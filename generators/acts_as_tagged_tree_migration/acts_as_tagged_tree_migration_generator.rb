class ActsAsTaggedTreeMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate'
    end
  end

  def file_name
    "acts_as_tagged_tree_migration"
  end
end
