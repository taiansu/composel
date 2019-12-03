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
      lmbd = to_lambda(l)
      accu.method(operator).call(lmbd)
    end
  end

  def to_lambda(maybe_proc)
    return maybe_proc if maybe_proc.is_a?(Proc)

    sym_or_obj, fun, args = Array(maybe_proc)

    unless sym_or_obj
      raise ArgumentError.new("Accept a proc/lambda, a symbol or an array contains [object, :method_symbol, [args]]")
    end

    lmbd = fun ? sym_or_obj.method(fun) : method(sym_or_obj)
    args ? lmbd.curry.call(*args) : lmbd
  end
end
