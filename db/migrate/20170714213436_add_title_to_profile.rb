class AddTitleToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :title, :string

    Profile.reset_column_information

    Profile.find_each do |profile|
      profile.update(title: profile.biography)
      profile.update(biography: nil)
    end
  end
end
