require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 10, user_id: user.id) }
  let(:todo_id) { todos.first.id }
  let(:headers) { valid_headers }

  describe 'GET /todos' do
    before { get '/todos', params: {}, headers: headers }

    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(todos.size)
    end

    it 'returns status code :ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status code :not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'POST /todos' do
    let(:valid_attributes) { {title: 'Learn Elm', user_id: user.id}.to_json }

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes, headers: headers }

      it 'returns status code :created' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Elm')
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { {title: nil}.to_json }
      before { post '/todos', params: invalid_attributes, headers: headers }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /todos/:id' do
    let(:valid_attributes) { {title: 'Shopping'}.to_json }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers }

      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the record' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", params: {}, headers: headers }

    it 'returns status code :no_content' do
      expect(response).to have_http_status(:no_content)
    end
  end
end