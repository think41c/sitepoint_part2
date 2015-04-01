# DataMapper is the ORM (Object Relational Mapping) to interact w/ the database. Similar to Active Record.
# SQLite is the local database that requires no config.
# development.db (a non special type of filename, will be created by ruby in the same folder that main.rb is in)
# The file is created when a database record is created (like in IRB) and stores the info of the database records.

# You can create tasks in IRB by going into IRB and typing:
# require './main'    
# Task.auto_migrate!    # this references 'Task', the name of our class. The .auto_migrate! is a built in method
# Task.create(name: "whatever")   # The .create is a built in method. The "name:" is a symbol we made under 'property' below

require 'sinatra/reloader'  
require 'sinatra'
require 'data_mapper'
require 'slim'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.rb")

class Task
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true
  property :completed_at, DateTime
end
DataMapper.finalize

get '/' do 
  @tasks = Task.all   # gets all tasks from the database, stores into array into @tasks.
  slim :index
end

get '/:task' do  
  @task = params[:task].split('-').join(' ').capitalize
  slim :task
end

post '/' do
  Task.create params[:task]   # Now will .create a task, put it to the params[:task] value. 
  redirect to('/')            # Refreshes the page essentially. Doesn't seem to matter what URL is given.
end

delete '/task/:id' do 
  Task.get(params[:id]).destroy
  redirect to('/')
end
