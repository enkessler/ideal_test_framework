namespace 'project_namespace' do

  task :launch_sandbox do
    system("irb -r #{environment_config_directory}/irb_env.rb")
  end

end
