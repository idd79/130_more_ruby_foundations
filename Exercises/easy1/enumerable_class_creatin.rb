class Tree
  include Enumerable

  def each
  end
end

# To provide most of the functionality of the Enumerable module, all you need to
# do is include Enumerable in your class, and define an each method that yields
# each member of the collection, one at a time.
