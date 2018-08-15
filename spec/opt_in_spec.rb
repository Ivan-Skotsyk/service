require 'airborne'

describe 'Get request' do
  it 'should validate type' do
    get 'http://localhost:4567/opt_ins'
    expect_json_types(:array)
  end

  it 'should validate keys in one opt-in' do
    get 'http://localhost:4567/opt_ins/5b699b7a6177ec7d1c99bd34'
    expect_json_keys([:id, :email, :mobile, :first_name, :last_name, :permission_type, :channel, :company_name])
  end

  it 'should validate values in one opt-in' do
    get 'http://localhost:4567/opt_ins/5b744d836177ec0e81101fc8'
    expect_json(id: '5b744d836177ec0e81101fc8', email: 'ivsko@gmail.com', mobile: '+380554258845', first_name: 'Ivan', last_name: 'Skotsyk', permission_type: 'one', channel: 'email', company_name: 'Pepsi')
  end
end

describe 'Post request' do
  it 'should create new opt-in' do
    post 'http://localhost:4567/opt_ins', {email: 'vasya_pupkin@gmail.com', mobile: '+3806785213649', first_name: 'Vasya' , last_name: 'Pupkin', permission_type: 'one', channel: 'email', company_name: 'Cola'}
    expect_json_keys( [:_id, :channel, :company_name, :email, :first_name, :last_name, :mobile, :permission_type])
  end
end

describe 'Patch request' do
  it 'should update  opt-in' do
    patch 'http://localhost:4567/opt_ins/5b699b7a6177ec7d1c99bd34', {email: 'andy_pupkin@gmail.com', mobile: '+3806785254786', first_name: 'Andy' , last_name: 'Pupkin', permission_type: 'one', channel: 'email', company_name: 'HP'}
    expect_json_keys( [:_id, :channel, :company_name, :email, :first_name, :last_name, :mobile, :permission_type])
  end

  it 'should validate updated opt-in' do
    get 'http://localhost:4567/opt_ins/5b699b7a6177ec7d1c99bd34', {email: 'andy_pupkin@gmail.com', mobile: '+3806785254786', first_name: 'Andy' , last_name: 'Pupkin', permission_type: 'one', channel: 'email', company_name: 'HP'}
    expect_json( email: 'andy_pupkin@gmail.com', mobile: '+3806785254786', first_name: 'Andy' , last_name: 'Pupkin', permission_type: 'one', channel: 'email', company_name: 'HP')
  end
end


describe 'Delete request' do
  it 'should delete  opt-in' do
    delete 'http://localhost:4567/opt_ins/5b74599b6177ec5459fff61c'
    expect_status(200)
  end
end

