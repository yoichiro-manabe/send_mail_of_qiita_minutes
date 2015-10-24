module SendMailOfQiitaMinutes
  class Command
    def self.run(argv)
      new(argv).execute
    end

    def initialize(argv)
      @argv = argv
      p argv
    end

    def execute
      p 'execute'
    end
  end
end

