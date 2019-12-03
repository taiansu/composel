require_relative "./test_helper"

class Klass
  def add_ten(i)
    i + 10
  end
end

class ComposelTest < Minitest::Test
  include Composel

  def test_compose_lambdas
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }
    h = ->(x) { x - 10 }

    i = compose(f, g, h)

    assert_equal(i.call(1), (f << g << h).call(1))
  end

  def test_pipe_lambdas
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }
    h = ->(x) { x - 10 }

    i = pipe(f, g, h)

    assert_equal(i.call(10), (f >> g >> h).call(10))
  end

  def test_compose_method
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }
    o = Klass.new

    i = compose(f, g, [o, :add_ten])

    assert_equal(i.call(2), (f << g << o.method(:add_ten)).call(2))
  end

  def test_pipe_method
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }
    o = Klass.new

    i = pipe(f, g, [o, :add_ten])

    assert_equal(i.call(2), (f >> g >> o.method(:add_ten)).call(2))
  end

  def test_that_it_has_a_version_number
    refute_nil ::Composel::VERSION
  end
end
