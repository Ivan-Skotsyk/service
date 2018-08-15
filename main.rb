require 'sinatra'
require 'mongoid'

Mongoid.load! 'mongoid.config'

# Model
class OptIn
  include Mongoid::Document
  field :email, type: String
  field :mobile, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :permission_type, type: String
  field :channel, type: String
  field :company_name, type: String

  validates :email, presence: true
  validates :mobile, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :permission_type, presence: true
  validates :channel, presence: true
  validates :company_name, presence: true

  index({ permission_type: 1, company_name: 1 }, unique: true)

  scope :email, ->(email) { where(email: /^#{email}/i) }
  scope :mobile, ->(mobile) { where(mobile: /^#{mobile}/i) }
  scope :first_name, ->(first_name) { where(first_name: /^#{first_name}/i) }
  scope :last_name, ->(last_name) { where(last_name: /^#{last_name}/i) }
  scope :permission_type, ->(permission_type) { where(permission_type: /^#{permission_type}/i) }
  scope :channel, ->(channel) { where(channel: /^#{channel}/i) }
  scope :company_name, ->(company_name) { where(company_name: /^#{company_name}/i) }
end

class Serializer
  def initialize(opt_in)
    @opt_in = opt_in
  end

  def as_json(*)
    data = {
      id: @opt_in.id.to_s,
      email: @opt_in.email,
      mobile: @opt_in.mobile,
      first_name: @opt_in.first_name,
      last_name: @opt_in.last_name,
      permission_type: @opt_in.permission_type,
      channel: @opt_in.channel,
      company_name: @opt_in.company_name
    }
    data
  end
end

helpers do
  def opt_in
    @opt_in = OptIn.where(id: params[:id]).first
  end
end

get '/opt_ins' do
  opt_ins = OptIn.all
  %i[email mobile first_name last_name permission_type channel company_name].each do |filter|
    opt_ins = opt_ins.send(filter, params[filter]) if params[filter]
  end
  opt_ins.map { |opt_in| Serializer.new(opt_in) }.to_json
end

get '/opt_ins/:id' do
  Serializer.new(opt_in).to_json
end

post '/opt_ins' do
  body = JSON.parse request.body.read
  opt_in = OptIn.create(
    email: body['email'],
    mobile: body['mobile'],
    first_name: body['first_name'],
    last_name: body['last_name'],
    permission_type: body['permission_type'],
    channel: body['channel'],
    company_name: body['company_name']
  )
  opt_in.to_json
end

patch '/opt_ins/:id' do
  body = JSON.parse request.body.read
  opt_in.update(
    email: body['email'],
    mobile: body['mobile'],
    first_name: body['first_name'],
    last_name: body['last_name'],
    permission_type: body['permission_type'],
    channel: body['channel'],
    company_name: body['company_name']
  )
  opt_in.to_json
end

delete '/opt_ins/:id' do
  opt_in.destroy
end
