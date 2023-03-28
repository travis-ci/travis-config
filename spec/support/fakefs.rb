require 'pp' # https://github.com/fakefs/fakefs#fakefs-vs-pp-----typeerror-superclass-mismatch-for-class-file
require 'fakefs/safe'
require 'fileutils'

module Support
  module FakeFs
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.before { FakeFS.activate! }
      base.after { FakeFS.deactivate! }
      base.after { FakeFS::FileSystem.clear }
    end

    module ClassMethods
      def dir(dir)
        before { FileUtils.mkdir_p(dir) }
        after { FileUtils.rm_rf(dir) }
      end

      def file(path, content)
        before { FileUtils.mkdir_p(File.dirname(path)) }
        before { File.write(path, content) }
        after { FileUtils.rm_rf(File.dirname(path)) }
      end
    end
  end
end
