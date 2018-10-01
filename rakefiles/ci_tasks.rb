namespace 'project_namespace' do

  namespace 'ci' do

    task :run_all_suites do |t, args|
      run_in_parallel = ENV['parallel_all_suites'] || 'false'

      list_of_suites = ['suite_1'] # Add additional suites as needed
      processes = {}
      suite_with_failures = []
      start_time = Time.now


      if run_in_parallel
        list_of_suites.each do |suite_name|
          # Example command is for Windows. Unix-like OS might be able to leave out the beginning portion
          processes[suite_name] = ChildProcess.build('cmd.exe','/c','bundle', 'exec', 'rake', "project_namespace:testing:#{suite_name}")
          processes[suite_name].io.inherit!
          processes[suite_name].start
        end

        processes.each_key do |suite_name|
          processes[suite_name].wait
          suite_with_failures << suite_name if processes[suite_name].exit_code != 0
        end
      else
        list_of_suites.each do |suite_name|
          begin
            Rake::Task["namespace:of:#{suite_name}"].invoke
          rescue ProjectModule::TestSuiteFailure
            # Catch test suite failure so that other suites can still be run
            suite_with_failures << suite_name
          end
        end
      end


      end_time = Time.now
      total_time = end_time - start_time
      puts "All suites completed in #{Time.at(total_time).strftime('%M:%S')}"

      raise(ProjectModule::TestSuiteFailure, "The following suites had failures:\n#{suite_with_failures}".colorize(:red).bold) if suite_with_failures.any?

      puts 'All suites finished successfully.'.colorize(:green).bold
    end

  end

end
