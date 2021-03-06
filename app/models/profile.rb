# == Schema Information
#
# Table name: profiles
#
#  avatar_from_slack  :string
#  biography          :text
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  location           :string
#  nickname           :string
#  privacy_level      :integer          default(0)
#  receive_emails     :boolean          default(FALSE)
#  receive_job_alerts :boolean          default(FALSE)
#  updated_at         :datetime         not null
#  user_id            :integer
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_e424190865  (user_id => users.id)
#

class Profile < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :nickname, allow_blank: true

  enum privacy_option: [ "Hidden", "Members only", "Open" ]

  def complete?
    if (self.user.first_name.blank? ||
        self.user.last_name.blank? ||
        self.location.blank?)
      return false
    else
      return true
    end
  end

  def profile_picture
    unless avatar_from_slack
      return 'profile_picture_default.png'
    end

    avatar_from_slack
  end

  def location_name
    unless location.blank?
      country = ISO3166::Country[location]
      (country.translations[I18n.locale.to_s] || country.name) if country
    else
      "Not set yet"
    end
  end
end
