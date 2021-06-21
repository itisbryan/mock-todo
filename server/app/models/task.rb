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
  STATES = [
    TODO = 'todo'.freeze,
    IN_PROCESSING = 'in processing'.freeze,
    FINISHED = 'finished'.freeze
  ].freeze

  # enum state: {
  #   todo => TODO,
  #   processing => IN_PROCESSING,
  #   finished => FINISHED
  # }

  validates_presence_of :status
  validates_presence_of :content
  validates_inclusion_of :status, in: STATES
  validate :not_past_date

  # scope :todo_tasks, -> { where(state: TODO) }
  # scope :processing_tasks, -> { where(state: IN_PROCESSING) }
  # scope :finished_tasks, -> { where(state: FINISHED) }

  belongs_to :user
  belongs_to :todo

  private

  def not_past_date
    errors.add(:expired_at, "Can't be in the past") if
      !expired_at.blank? && expired_at < Date.today
  end

end
