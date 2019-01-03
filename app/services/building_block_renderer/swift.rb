module BuildingBlockRenderer
  class Swift
    def self.dependencies(deps)
      deps.join("\n")
    end

    def self.run_command(_command, _filename, _file_path)
      nil
    end

    def self.create_instructions(filename)
      "Create a file named `#{filename}` and add the following code:"
    end

    def self.add_instructions(filename)
      "Add the following to `#{filename}`:"
    end
  end
end
