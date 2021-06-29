# frozen_string_literal: true
require 'rails_helper'
require 'active_support'
# require_relative '../../support/devise'

RSpec.shared_examples 'A REST API',
                      http_error_instead_of_exception: true do |comparable_attributes:, resource_path:|
  include RequestSpecHelper

  def self.controller_has_action?(controller_class, action)
    controller_class.action.methods.include?(action.to_s)
  end

  before do
    @current_user = create(:user)
    @singular = get_resource_type('singular', resource_path)
    @plural = get_resource_type('plural', resource_path)
    @record = create(@singular, user: @current_user) unless dependent(resource_path)

    if dependent(resource_path)
      @master = create(master(resource_path))
      @record = create(@singular, master(resource_path) => @master)
      @master_path = resource_path.gsub ':id', @master.id.to_s
    end

    @valid_attributes = attributes_for(@singular)
    @invalid_attributes = attributes_for(@singular, :invalid)
  end

  describe "GET #{resource_path} (#index)" do

    before do
      @records = FactoryBot.create_list(@singular, 10, user: @current_user) unless dependent(resource_path)
      if dependent(resource_path)
        @records = create_list(@singular, 10, user: @current_user, master(resource_path) => @master)
        resource_path = @master_path
      end
    end

    it "should return all #{@plural}" do
      login(@current_user)
      get resource_path, headers: get_auth_params_from_login_response_headers(response)
      expect(response).to have_http_status(:ok)
      expect(json(response).size).equal? 2
      expect(json(response).deep_symbolize_keys[:data].size).equal? @records.size
    end

  end

  describe "GET #{resource_path}/:id (#show)" do
    context "with a valid #{@singular} ID" do
      before do
        login(@current_user)
        resource_path = @master_path if dependent(resource_path)
        get "#{resource_path}/#{@record.id}", headers: get_auth_params_from_login_response_headers(response)
        @data_json_response = json(response).deep_symbolize_keys[:data]
      end

      it "should return a 'OK' (200) HTTPS status code" do
        expect(response).to have_http_status(:ok)
      end

      it "should return the created #{@singular}" do
        expect(@data_json_response).to include(@record.attributes.slice(comparable_attributes))
      end
    end

    context "with an invalid #{@singular} ID" do
      before do
        login(@current_user)
        get "#{resource_path}/#{SecureRandom.hex(5).to_i}", headers: get_auth_params_from_login_response_headers(response)
      end

      it "should return a 'not found' (404) status code" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST #{resource_path} (#create)" do

    context 'with valid attributes' do
      before(:each) do
        login(@current_user)
        post resource_path, params: { @singular => @valid_attributes },
                            headers: get_auth_params_from_login_response_headers(response)
        @data_json_response = json(response).deep_symbolize_keys[:data]
      end

      it "should return a 'created' (201) HTTP status code" do
        expect(response).to have_http_status(:created)
      end

      it "should return the created #{@singular}" do
        expect(@data_json_response).to include(@record.attributes.slice(comparable_attributes))
      end

      it "should have #{@current_user} as author" do
        expect(@data_json_response[:relationships][:user]).equal? @current_user
      end
    end

    context 'with invalid attributes' do
      before(:each) do
        login(@current_user)
        post resource_path, params: { @singular => @invalid_attributes },
                            headers: get_auth_params_from_login_response_headers(response)
      end

      it "should return 'unprocessable entity' (402) HTTP status code" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #{resource_path}/:id (#update)" do
    context 'with valid attributes' do
      before do
        login(@current_user)
        patch "#{resource_path}/#{@record.id}", params: { @singular => @valid_attributes },
                                                headers: get_auth_params_from_login_response_headers(response)
      end

      it "should return a 'No content' (204) HTTP status code" do
        expect(response).to have_http_status(:no_content)
      end

      it "should return the updated #{@singular}" do
        get "#{resource_path}/#{@record.id}", headers: get_auth_params_from_login_response_headers(response)
        @data_json_response = json(response).deep_symbolize_keys[:data]
        @record.reload
        expect(@data_json_response).to include(@valid_attributes.slice(comparable_attributes))
      end
    end

    context 'with invalid attributes' do
      before do
        login(@current_user)
        patch "#{resource_path}/#{@record.id}", params: { @singular => @invalid_attributes },
                                                headers: get_auth_params_from_login_response_headers(response)
      end

      it "should return an 'unprocessable entity' (422) status code" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #{resource_path}/:id (#destroy)" do
    context 'delete completed successfully' do
      before do
        login(@current_user)
        delete "#{resource_path}/#{@record.id}", headers: get_auth_params_from_login_response_headers(response)
      end

      it "should return a 'No content' (204) HTTP status code" do
        expect(response).to have_http_status(:no_content)
      end

      it "should ensure that the #{@singular} no longer exists" do
        get "#{resource_path}/#{@record.id}", headers: get_auth_params_from_login_response_headers(response)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
