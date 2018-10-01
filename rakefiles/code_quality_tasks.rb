require 'rubocop/rake_task'
require 'cuke_sniffer'


namespace 'project_namespace' do

  namespace 'code_quality' do

    desc 'Checks the codebase for style violations'
    task :check_code_style do |t|
      Rake::Task['project_namespace:code_quality:ruby_check'].invoke
      Rake::Task['project_namespace:code_quality:gherkin_check'].invoke
    end

    desc 'Checks Ruby code for common style violations'
    RuboCop::RakeTask.new(:ruby_check) do |t|
      root_directory = "#{__dir__}/.."
      report_output_path = "#{root_directory}/reports/rubocop_report.html"


      t.patterns = ['**/*.rb']
      t.formatters = ['html']
      t.options = ['-o', report_output_path, '--force-exclusion']
      t.fail_on_error = false # So that this task can be easily chained to other tasks without breaking
    end

    desc 'Checks Gherkin code for common style violations'
    task :gherkin_check do |t|
      root_directory = "#{__dir__}/.."
      features_directory = "#{root_directory}/testing/cucumber/features"
      step_definitions_directory = "#{root_directory}//testing/cucumber/step_definitions"
      hooks_directory = "#{root_directory}//testing/cucumber/hooks"
      report_output_path = "#{root_directory}/reports/cuke_sniffer_report"

      sniffer = CukeSniffer::CLI.new(features_location: features_directory,
                                     step_definitions_location: step_definitions_directory,
                                     hooks_location: hooks_directory)

      sniffer.output_html(report_output_path)
    end

  end

end
