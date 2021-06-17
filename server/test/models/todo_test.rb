# == Schema Information
#
# Table name: todos
#
#  id                :integer          not null, primary key
#  is_public         :boolean          default(TRUE), not null
#  short_description :string
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require "test_helper"

class TodoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
