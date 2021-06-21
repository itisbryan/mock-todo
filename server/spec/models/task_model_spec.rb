require 'rails_helper'

RSpec.describe Task, type: :model do

  describe '#valid?' do

    it 'is invalid if content is blank' do
      task = create(:task)

      task.content = ''
      expect(task).to be_invalid

      task.content = nil
      expect(task).to be_invalid
    end

    it 'is invalid if status is blank' do
      task = create(:task)

      task.status = ''
      expect(task).to be_invalid

      task.status = nil
      expect(task).to be_invalid
    end

    it 'should validate the state correctly' do
      user = build(:user)
      todo = build(:todo)

      task = create(:task, user: user, todo: todo)

      expect(task).to be_valid

      task.status = 'invalid status'
      expect(task).to be_invalid

      Task::STATES.each do |state|
        task.status = state
        expect(task).to be_valid
      end
    end

    it 'should validate the expired at correctly' do
      task = create(:task)

      task.expired_at = 2.days.ago
      expect(task).to be_invalid

      task.expired_at = Date.today
      expect(task).to be_valid

      task.expired_at = Date.tomorrow
      expect(task).to be_valid

    end
  end

  describe '#save' do
    context 'when complete data is given' do
      it 'can be persisted' do
        author = create(:user)
        todo_archive = create(:todo)
        task = create(
          :task,
          user: author,
          todo: todo_archive,
          status: Task::IN_PROCESSING
        )
        task.save
        expect(task).to be_persisted
        expect(task.user).to eq author
        expect(task.todo).to eq todo_archive
      end
    end
  end

end
