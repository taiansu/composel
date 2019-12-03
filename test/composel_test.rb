require_relative "./test_helper"

class Klass
  def add_ten(num)
    num + 10
  end

  def add_all(num1, num2, num3)
    num1 + num2 + num3
  end
end

class ComposelTest < Minitest::Test
  include Composel

  def instance_multiply_three(num)
    num * 3
  end

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

  def test_compose_curried_method
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }
    o = Klass.new

    i = compose(
          f,
          g,
          [o, :add_all, [2, 3]]
        )

    assert_equal(i.call(10),
                 (f << g << o.method(:add_all).curry.call(2, 3)).call(10))
  end

  def test_pipe_curried_method
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }
    o = Klass.new

    i = pipe(
          f,
          g,
          [o, :add_all, [10, 11]]
        )

    assert_equal(i.call(10),
                 (f >> g >> o.method(:add_all).curry.call(10, 11)).call(10))
  end

  def test_compose_symbol
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }

    i = compose(f, g, :instance_multiply_three)

    assert_equal(i.call(10),
                 (f << g << method(:instance_multiply_three)).call(10))
  end

  def test_method_not_defined
    f = ->(x) { x + 1 }
    g = ->(x) { x * 2 }

    assert_raises NameError do
      compose(f, g, :undefined_method)
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Composel::VERSION
  end
end
