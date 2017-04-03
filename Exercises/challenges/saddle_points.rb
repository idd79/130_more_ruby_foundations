# Saddle point

class Matrix
  def initialize(string)
    @string = string
  end

  def matrix
    @string.split("\n").map { |elm| elm.split.map(&:to_i)}
  end

  def rows
    matrix
  end

  def columns
    matrix.transpose
  end

  def min_by_cols
    min_by_cols = []
    columns.each_with_index do |col, j|
      indexes_with_min = all_indexes(col) { |num, array| array.min == num }
      indexes_with_min.map { |i| min_by_cols << [i, j] }
    end
    min_by_cols
  end

  def max_by_rows
    max_by_rows = []
    rows.each_with_index do |row, i|
      indexes_with_max = all_indexes(row) { |num, array| array.max == num }
      indexes_with_max.map { |j| max_by_rows << [i, j] }
    end
    max_by_rows
  end

  def saddle_points
    max_by_rows & min_by_cols
  end

  def all_indexes(array)
    array.each_index.select { |idx| yield(array[idx], array) }
  end
end

m = Matrix.new("4 5 4\n3 5 5\n1 5 4")
p m.matrix
p m.columns[1]
p m.saddle_points

def all_indexes(array)
  array.each_index.select { |idx| yield(array[idx], array) }
end

# p all_indexes([1, 4, 3, 4]) { |num, array| array.min == num }
