class PhantomFormatter
  def initialize(out=nil)
    @exception = @failure = false
    @exceptions = []
    @count = 0

    @current_state = nil
  end

  def register
    MSpec.register :exception, self
    MSpec.register :before,    self
    MSpec.register :after,     self
    MSpec.register :finish,    self
    MSpec.register :abort,     self
    MSpec.register :enter,     self
  end

  def green(str)
    `console.log('\\033[32m' + str + '\\033[0m')`
  end

  def red(str)
    `console.log('\\033[31m' + str + '\\033[0m')`
  end

  def log(str)
    `console.log(str)`
  end

  def exception?
    @exception
  end

  def failure?
    @failure
  end

  def enter(describe)
    log "\n#{describe}"
  end

  def before(state=nil)
    @current_state = nil
    @failure = @exception = false
  end

  def exception(exception)
    @count += 1
    @failure = @exception ? @failure && exception.failure? : exception.failure?
    @exception = true
    @exceptions << exception
  end

  def after(state = nil)
    @current_state = nil

    unless exception?
      green "  #{state.it}"
    else
      # red(failure? ? "F" : "E")
      red "  #{state.it}"
      red "    #{@exceptions.last.exception.inspect}"
    end
  end
end
