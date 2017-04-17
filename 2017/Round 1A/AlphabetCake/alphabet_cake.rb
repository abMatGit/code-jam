require 'pry-nav'
# Given a cake with potential initials, fill it up with rectangles

class Cake
  attr_reader :data

  def initialize(data)
    @data = data
    @length = data.length
    @width = data.first.length
  end

  def initial_rows
    data
  end

  def row_slices
    data.map { |row| row.join }
  end
end

class CakeSolver
  attr_reader :cake

  def initialize(cake)
    @cake = cake
  end

  def solve_cake!
    cake.initial_rows.each { |initials| solve_initials!(initials, direction: :forward) }
    cake.initial_rows.each { |initials| solve_initials!(initials, direction: :backward) }

    solve_slices!(cake.row_slices, direction: :forward)
    solve_slices!(cake.row_slices, direction: :backward)
  end

  def solve_slices!(cake_slices, direction: :forward)
    valid_cake_slice = nil

    if direction == :forward
      cake_slices.each.with_index do |slice, i|
        if slice.include?('?')
          cake.data[i] = valid_cake_slice if valid_cake_slice
        else
          valid_cake_slice = cake.data[i]
        end
      end
    elsif direction == :backward
      cake_slices.reverse_each.with_index do |slice, i|
        reverse_index = cake_slices.length - i - 1

        if slice.include?('?')
          cake.data[reverse_index] = valid_cake_slice if valid_cake_slice
        else
          valid_cake_slice = cake.data[reverse_index]
        end
      end
    end
  end

  def solve_initials!(cake_initials, direction: :forward)
    valid_cake_initial = nil

    if direction == :forward
      cake_initials.each.with_index do |initial, i|
        if initial == '?'
          cake_initials[i] = valid_cake_initial if valid_cake_initial
        else
          valid_cake_initial = initial
        end
      end
    elsif direction == :backward
      cake_initials.reverse_each.with_index do |initial, i|
        reverse_index = cake_initials.length - i - 1

        if initial == '?'
          cake_initials[reverse_index] = valid_cake_initial if valid_cake_initial
        else
          valid_cake_initial = initial
        end
      end
    end
  end
end

class CodeJamRunner
  def self.solve!
    num_tests = ARGF.readline.strip.to_i

    num_tests.times do |i|
      dimensions = ARGF.readline.split(" ")
      data = []
      dimensions[0].to_i.times { data << ARGF.readline.strip.chars }

      cake = Cake.new(data)
      cake_solver = CakeSolver.new(cake)

      puts "CASE ##{i + 1}:"
      cake_solver.solve_cake!
      cake.row_slices.each { |slice| puts slice }
    end
  end
end

CodeJamRunner.solve!
