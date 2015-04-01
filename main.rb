# DataMapper is the ORM (Object Relational Mapping) to interact w/ the database. Similar to Active Record.
# SQLite is the local database that requires no config.
# development.db (a non special type of filename, needs to be in the same folder as main.rb)

require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/developement.rb")

class Task
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true
  property :completed_at, DateTime
end
DataMapper.finalize

require 'sinatra'
require 'sinatra/reloader'  
require 'slim'

get '/' do 
  slim :index
end

get '/:task' do  
  @task = params[:task].split('-').join(' ').capitalize
  slim :task
end

post '/' do  
  @task = params[:task]
  slim :task
end
