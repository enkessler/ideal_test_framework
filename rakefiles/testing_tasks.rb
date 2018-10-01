require 'childprocess'
require_relative '../testing/helpers'


namespace 'project_namespace' do

  namespace 'testing' do

    task :suite_1 do |t|
      generate_run_artifact_folder(suite_name: 'suite_1')
      run_cucumber(cucumber_options: 'testing/cucumber/features')
    end


  end

end
