# frozen_string_literal: true

require_relative "rbexec/version"
require "socket"

module Rbexec
  class Error < StandardError; end
  # Your code goes here...

  class Runner
    def initialize(socket)
      @socket = socket
    end

    def run
      Thread.new do
        Thread.current.name = "rbexec Runner"

        s = @socket
        s.puts("rbexec pid:#{$$}. Enter code followed by EOF.")

        code = s.read
        ok, result = evaluate(code)

        if ok
          s.write(result)
        else
          ex = result
          s.puts(ex.detailed_message)
          ex.backtrace.each do |line|
            s.puts(line)
          end
        end
      ensure
        s.close
      end
    end

    def evaluate(code)
      [true, Kernel.eval(code).inspect]
    rescue Exception => e
      [false, e]
    end
  end

  class Listener
    def initialize(path:)
      @path = path
      FileUtils.rm_f(path)
      @socket = UNIXServer.new(path)
      start
    end

    private

    def start
      @thread ||= Thread.new do
        Thread.current.name = "rbexec Listener"

        loop do
          s = @socket.accept

          euid, egid = s.getpeereid

          if Process.uid != euid
            s.puts("rbexec only accepts commands from the same user")
            s.close
          else
            Runner.new(s).run
          end
        end
      ensure
        stop
      end
    end

    def stop
      @thread&.kill unless Thread.current == @thread
      FileUtils.rm_f(@path)
    end
  end
end
