# TODO: Have this live somewhere else?

def run_cucumber(**options)
  if options[:parallel]
    run_cucumber_in_parallel(options)
  else
    run_cucumber_in_serial(options)
  end
end

def run_rspec(**options)
  if options[:parallel]
    run_rspec_in_parallel(options)
  else
    run_rspec_in_serial(options)
  end

end

def run_cucumber_in_serial(**options)
  command = 'bundle exec cucumber'

  # Any extra stuff to add on to the Cucumber command that has not otherwise been included
  command += " #{options[:cucumber_options]}" if options[:cucumber_options]

  # TODO: throw error if test failures occur
  system(command)
end

def current_run_number(suite_name)
  used_run_numbers = Dir.glob("#{base_report_directory}/#{suite_name}/run_*").collect { |directory| directory[/\d+$/].to_i }
  used_run_numbers.max.to_i
end

def next_suite_run_number(suite_name)
  current_run_number(suite_name) + 1
end

def wipe_report_directory(child_directory = nil)
  target_directory = base_report_directory
  target_directory += "/#{child_directory}" if child_directory

  FileUtils.remove_entry(target_directory, true)
end

def generate_run_artifact_folder(suite_name:)
  FileUtils.mkdir_p("#{base_report_directory}/#{suite_name}/run_#{next_suite_run_number(suite_name)}")
end

def base_report_directory
  "#{base_project_directory}/reports"
end

def environment_config_directory
  "#{base_project_directory}/environments"
end

def base_project_directory
  "#{__dir__}/.."
end

def base_features_directory
  "#{base_project_directory}/testing/cucumber/features"
end

def determine_starting_indexes
  tagger = CukeCataloger::UniqueTestCaseTagger.new

  current_indexes = tagger.determine_known_ids(base_features_directory)
  other_indexes = determine_reserved_indexes

  tagger.send(:default_start_indexes, current_indexes + other_indexes)
end

def determine_reserved_indexes
  # If you want to ensure that some indexes don't get used (e.g. they are indexes of old
  # tests that have since been removed), add code here that will return them. (e.g. `['8', '10-1']`)

  []
end
