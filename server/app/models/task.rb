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
class Task < ApplicationRecord
  enum STATUS = [
    TODO = 'todo'.freeze,
    IN_PROCESSING = 'in processing'.freeze,
    FINISHED = 'finished'.freeze
  ].freeze

  validates :content, presence: true
  validate :expiration_date_cannot_be_in_the_past
  validates :status, inclusion: { in: STATUS }

  belongs_to :users
  belongs_to :todos

  private
  
  def expiration_date_cannot_be_in_the_past
    errors.add(:expired_at, "Can't be in the past") if
      !expired_at.blank? && expired_at < Date.today
  end

end
