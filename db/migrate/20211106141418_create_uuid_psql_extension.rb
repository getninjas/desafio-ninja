class CreateUuidPsqlExtension < ActiveRecord::Migration[6.1]
  def up
    enable_extension "pgcrypto"
  end

  def down
    disable_extension "pgcrypto"
  end
end
