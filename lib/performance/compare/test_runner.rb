#!/usr/bin/env ruby

require 'digest'
require 'benchmark'
require 'parallel'
require 'etc'
require 'colored2'
require 'tty-box'

module Performance
  module Compare
    class TestRunner
      attr_reader :iterations,
                  :test_matrix,
                  :algorithms,
                  :method

      # @param [Array<Integer>] iterations number of iterations per algorithm many times to test each test case
      # @param [Hash] test_matrix, keys are threads: and processes:, values is an array of ints to test
      # @param [Array<Object#method(value)>] algorithm classes to be tested. Must respond to #method defined next.
      # @param [String,Symbol] method
      def initialize(iterations: [],
                     test_matrix: [],
                     algorithms: [],
                     method:)

        @iterations  = iterations
        @test_matrix = test_matrix
        @algorithms  = algorithms
        @method      = method

        if iterations.size != algorithms.size
          raise ArgumentError, 'Iteration counts must match number of algorithms being tested.'
        end

        print_header!
      end

      def run
        Benchmark.bm(22) do |bm|
          algorithms.each_with_index do |implementation, index|
            count = iterations[index]
            h2("Testing Implementation: #{implementation}, #{count} iterations")

            test_matrix.keys.each do |key|
              test_matrix[key].each do |value|
                benchmark_test_case(bm, implementation, count, key, value)
              end
            end
          end
        end
      end

      def benchmark_test_case(bm, implementation, iterations, key, value)
        title = "#{method} | #{sprintf '%10s | %2d', key, value}"
        impl  = implementation.new

        bm.report(title) do
          Parallel.map((0...iterations).to_a, "in_#{key}": value) do |n|
            impl.send(method, iteration_to_value(n))
          end
        end
      end

      def iteration_to_value(iteration)
        'iteration.' + iteration.to_s
      end

      def print_header!
        header = <<~HEADER
          Number of CPU Cores:                 #{Etc.nprocessors}
          Method under the test:               #{method}

          Number of iterations per algorithm:  #{iterations}
          List of algorithms to compare:       #{algorithms.map(&:name)}
        HEADER

        h1(header)
      end

      def h2(text, **opts)
        params = { height: 3, padding: 0, bg: :black, fg: :bright_green }
        box(text, **params.merge(opts))
      end

      def h1(text, **opts)
        params = { bg: :black, fg: :bright_blue }
        box(text, **params.merge(opts))
      end

      def box(text, **opts)
        bg = opts.delete(:bg) || :black
        fg = opts.delete(:fg) || :bright_white

        style = { fg: fg, bg: bg, border: { fg: fg, bg: bg } }

        print TTY::Box.frame(
          width:   100,
          height:  8,
          align:   :left,
          style:   style,
          padding: 1, **opts) { text }
      end
    end
  end
end
