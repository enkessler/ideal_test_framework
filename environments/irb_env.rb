require_relative 'common_env'

require_relative '../rakefiles/helper_methods'


def load_file(file_path)
  @previous_load_command = :load_file
  @previous_load_argument = file_path

  load(file_path)
end

alias :lf :load_file

def load_directory(directory_path)
  @previous_load_command = :load_directory
  @previous_load_argument = file_path

  load_all(directory_path)
end

alias :ld :load_directory

def reload

  unless @previous_load_command
    puts 'No previous load command'
    return
  end

  unless @previous_load_argument
    puts 'No previous load argument'
    return
  end

  send(@previous_load_command, @previous_load_argument)
end

alias :rl :reload

def retry
  reload

  previous_command = IRB.CurrentContext.io.line(-2)

  # Avoid infinite recursion
  unless ["retry\n", "rt\n"].include?(previous_command)
    @previous_irb_command = previous_command
  end


  unless @previous_irb_command
    puts 'No previous IRB command argument'
    return
  end

  # An argument must be provided. Purpose unknown
  junk_value = 1

  IRB.CurrentContext.irb.context.evaluate(@previous_irb_command, junk_value)
end

alias :rt :retry

def forget
  @previous_load_command = nil
  @previous_load_argument = nil
  @previous_irb_command = nil
end


# It is safest to forget everything if this file is changed and reloaded
forget
