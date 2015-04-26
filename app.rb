require 'sinatra/base'
require 'sinatra/activerecord'
require './models/company'
require './models/passport'
require 'json'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/companydb')

class CompanyRestApi < Sinatra::Base
  register PaperTrail::Sinatra
  set :root, File.dirname(__FILE__)

  helpers do
    def params_to_json
      json_string = request.body.read
      request.body.rewind
      @json_params = JSON.parse json_string if json_string.length > 1
    end
  end

  before do
    content_type :json

    headers 'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST','PUT'],
      'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept',
      'Access-Control-Allow-Credentials' => 'true'

    if request.request_method == 'OPTIONS'
      halt 200
    end
  end

  before '/company/:id*' do
    @company = Company.find_by id: params['id']
    if @company.nil?
      halt 404
    end
  end

  def handle_error(status, model)
    halt status, { reason: model.errors.messages }.to_json
  end

  post '/company' do
    @company = Company.new(params_to_json)

    if @company.save
      halt 201, @company.to_json
    else
      handle_error 400, @company
    end
  end

  get '/company' do
    Company.order(:id).all.to_json
  end

  get '/company/:id' do
      @company.to_json
  end

  put '/company/:id' do
    if @company.update(params_to_json)
      @company.to_json
    else
      handle_error 400, @company
    end
  end

  get '/company/:id/passport/:pid' do
    passport = @company.passports.find_by id: params[:pid]
    halt 404, { reason: 'Passport not found' }.to_json if passport.nil?

    content_type 'application/pdf'
    passport.passport_pdf
  end

  post '/company/:id/passport' do
    halt 400, { reason: "File not provided" }.to_json if params['file'].nil?
    passport = Passport.new
    passport.passport_pdf = params['file'][:tempfile].read
    @company.passports << passport

    if @company.save
      halt 201, { id: passport.id }.to_json
    else
      handle_error 400, @company
    end
  end
end
