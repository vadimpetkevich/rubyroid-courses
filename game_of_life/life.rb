require 'matrix.rb'

class Life
  @@size = 10
  @@max_level = 6

  attr_reader :generation
  def initialize size, max_level
    @@size = size > 0 ? size : 10
    @@max_level = max_level > 0 ? max_level : 6
    @generation = Matrix.build(@@size) { Random.rand 0..@@max_level }
  end
  def to_next_generation
    new_generation = Matrix.build(@@size) {|line, cell| get_new_level line, cell }
    return nil if new_generation == @generation
    @generation = new_generation.clone
  end
  private
  def get_neighbors line, cell
    return if @generation[line, cell].nil?

    neighbors = []

    (line - 1).upto(line + 1) do |i|
      i = 0 if i == @@size

      (cell - 1).upto(cell + 1) do |j|
        next if i == line and j == cell
        j = 0 if j == @@size
        neighbors << @generation[i, j]
      end
    end
    neighbors
  end
  def get_new_level line, cell
    neighbors = get_neighbors line, cell
    current_level = @generation[line, cell]

    if current_level == 0
      return 1 if neighbors.select {|level| level > 0 }.count == 3
    else
      return ((current_level + 1) > @@max_level ? @@max_level: current_level + 1) if (2..3).include?( (neighbors.select {|level| level > 0 }).count )
      return 0 if [1, 4, 5].include? neighbors.select {|level| level > 0 }.count
      return (current_level - 1) if neighbors.count 0 == neighbors.count
      return (current_level - 1) if (6..8).include?( (neighbors.select {|level| level > 0 }).count )
    end

    current_level
  end
end

