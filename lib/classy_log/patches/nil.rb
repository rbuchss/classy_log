###
# from active-support
#
class NilClass
  # Calling +try+ on +nil+ always returns +nil+.
  # It becomes especially helpful when navigating through associations that may return +nil+.
  #
  #   nil.try(:name) # => nil
  #
  # Without +try+
  #   @person && @person.children.any? && @person.children.first.name
  #
  # With +try+
  #   @person.try(:children).try(:first).try(:name)
  def try(*args)
    nil
  end

  def try!(*args)
    nil
  end
end
