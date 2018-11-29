module BuildingBlockRenderer
  class Swift
    def self.dependencies(deps)
      deps.join("\n")
    end

    def self.run_command(command, _filename, _file_path)
      <<~HEREDOC
        ## Run your code
        We're still working on this. Bear with us
      HEREDOC
    end

    def self.create_instructions(filename)
      "Create a file named `#{filename}` and add the following code:"
    end

    def self.add_instructions(filename)
      "Add the following to `#{filename}`:"
    end
  end
end
