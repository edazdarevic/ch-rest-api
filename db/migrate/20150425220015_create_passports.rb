class CreatePassports < ActiveRecord::Migration
  def self.up
    create_table :passports do |t|
      t.binary :passport_pdf
      t.integer :company_id
    end
  end

  def self.down
    drop_table :passports
  end
end
