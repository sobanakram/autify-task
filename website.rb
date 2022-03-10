require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'test.db')

class CreateWebsiteTable < ActiveRecord::Migration[7.0]
  def change
    create_table :websites do |table|
      table.string :host
      table.string :name
      table.integer :links_count
      table.integer :images_count
      table.datetime :last_fetched_at
      table.timestamps
    end
  end
end

# Create the table
CreateWebsiteTable.migrate(:up) unless ActiveRecord::Base.connection.table_exists?(:websites)
# CreateWebsiteTable.migrate(:down) if ActiveRecord::Base.connection.table_exists?(:websites)

class Website < ActiveRecord::Base

  validates :name, :last_fetched_at, presence: true

  def self.record(name, hostname, body = '')
    website = Website.find_or_create_by(name: name)
    links_count = body.scan(/<a/).count
    images_count = body.scan(/<img/).count
    website.update(last_fetched_at: Time.now, host: hostname, links_count: links_count, images_count: images_count)
  end
end