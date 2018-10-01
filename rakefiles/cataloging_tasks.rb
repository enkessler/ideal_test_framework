require 'cuke_cataloger'

namespace 'project_namespace' do

  # Pull in the tasks provided by the cataloging gem
  CukeCataloger.create_tasks

  task :catalog_tests do
    tagger = CukeCataloger::UniqueTestCaseTagger.new

    before_results = tagger.validate_test_ids(base_features_directory)
    current_problems = before_results.map { |result| result[:problem] }.uniq

    if current_problems.empty?
      puts 'No uncataloged tests found.'
    else
      # It's a good idea to make sure that ids are in a good state before and after cataloging. There should
      # only be missing id errors before cataloging and no errors after cataloging

      okay_problems = [:missing_tag, :missing_id_column, :missing_row_id]
      outstanding_problems = current_problems - okay_problems

      if outstanding_problems.any?
        puts "before bad results: #{outstanding_problems}"
        puts "Pre-cataloging results: #{CukeCataloger::TextReportFormatter.new.format_data(before_results)}"
        raise('Test IDs were in a bad state before cataloging. Aborting...')
      end

      tagger.tag_tests(base_features_directory, '@test_case_', determine_starting_indexes )

      after_results = tagger.validate_test_ids(base_features_directory)

      if after_results.any?
        current_problems = after_results.map { |result| result[:problem] }.uniq
        puts "after bad results: #{current_problems}"
        puts "Post-cataloging results: #{CukeCataloger::TextReportFormatter.new.format_data(after_results)}"
        raise('Test IDs were in a bad state after cataloging. Aborting...')
      end

      puts 'Successfully cataloged tests.'
    end
  end

end
