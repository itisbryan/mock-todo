# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe '#valid?' do
    it 'is invalid if title is blank' do
      todo = create(:todo)
      expect(todo).to be_valid

      todo.title = ''
      expect(todo).to be_invalid

      todo.title = nil
      expect(todo).to be_invalid
    end

    it 'is valid when title is unique' do
      todo1 = create(:todo)
      todo2 = create(:todo)

      expect(todo2.title).not_to be todo1.title
      expect(todo2).to be_valid
    end

    it 'is invalid if title is taken' do
      create(:todo, title: 'Mock')

      todo = Todo.new
      todo.title = 'Mock'
      expect(todo).to be_invalid

    end
  end

  describe '#save' do
    context 'when complete data is given' do
      it 'can be persisted' do
        author = create(:user)
        todo = create(:todo, user: author)
        todo.save

        expect(todo).to be_persisted
        expect(todo.user).to eq author
      end
    end
  end
end
