module PandaCms
  class Breadcrumb
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end
  end
end
