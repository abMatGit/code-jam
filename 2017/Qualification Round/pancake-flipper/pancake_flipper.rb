require 'set'
require 'pry-nav'

# Problem: Given a row of pancakes, and the size of a pancake flipper,
#          give the minimum number of flips to make all pancakes faceup
#
# Sample input: ---+-++- 3
# Sample output: 3 moves

class PancakeFlipper
  attr_reader :size
  class PancakeFlipperError < StandardError; end;

  def initialize(size)
    @size = size
  end

  def flip(pancakes:, position:)
    raise PancakeFlipperError.new('out of bounds') if (size + position) > pancakes.size

    pancakes.dup.tap do |pancakes_dup|
      size.times do |i|
        pancakes_dup[position + i] = flipped_value(pancakes[position + i])
      end
    end
  end

  def flipped_value(value)
    value == '+' ? '-' : '+'
  end
end

class Pancakes < Array
  def initialize(string)
    super(string.chars)
  end

  def [](arg)
    self.to_a[arg]
  end

  def solved?
    count { |p| p == '+' } == size
  end
end

class PancakeSolver
  FILE = 'output_file.txt'
  def initialize(string, size)
    @pancakes = Pancakes.new(string)
    @pancake_flipper = PancakeFlipper.new(size)
    @incomplete_states = Set.new
  end

  def solve!(debug = false)
    @debug = debug
    initial_state = Set.new([@pancakes])
    solve(initial_state, 0)
  end

  def solve(pancake_states, num_tries)
    begin
      return 'IMPOSSIBLE' if pancake_states.empty?
      return num_tries if pancake_states.any? { |state| state.solved? }
      @incomplete_states.merge(pancake_states)

      binding.pry if @debug
      recursive_states = pancake_states.each_with_object(Set.new) do |state, new_states|
        num_iterations.times do |i|
          new_state = @pancake_flipper.flip(state, i)
          new_states.add(new_state) unless @incomplete_states.include?(new_state)
        end
      end
      binding.pry if @debug

      return solve(recursive_states, num_tries + 1)
    rescue => e
      binding.pry if @debug
    end
  end

  private

  def num_iterations
    @pancakes.size - @pancake_flipper.size + 1
  end
end

class CodeJamRunner
  FILE = 'output_file.txt'

  def self.solve(file)
    File.foreach(file).with_index do |line, line_number|
      next if line_number == 0
      opts = line.strip.split(' ')
      pancakes = opts[0]
      flipper_size = opts[1]
      solver = PancakeSolver.new(pancakes, flipper_size.to_i)
      File.open(FILE, 'a+') { |f| f.write("Case \##{line_number}: #{solver.solve!}\n") }
    end
  end
end
