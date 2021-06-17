# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  expired_at :datetime
#  is_public  :boolean          default(TRUE), not null
#  status     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  todo_id    :integer          not null
#  user_id    :integer          not null
#
# Foreign Keys
#
#  todo_id  (todo_id => todos.id)
#  user_id  (user_id => users.id)
#
require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
