require "composel/version"

module Composel
  def compose(*args)
    composition(args, :<<)
  end

  def pipe(*args)
    composition(args, :>>)
  end

  private

  def composition(lambdas, operator)
    lambdas.reverse.reduce do |l, accu|
      lmbd = l.is_a?(Array) ? l[0].method(l[1]) : l
      accu.method(operator).call(lmbd)
    end
  end
end
