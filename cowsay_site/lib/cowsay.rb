class Cowsay
  def call env
    response = env['QUERY_STRING'].empty? ? `cowsay #{'What should i say?'}` : `cowsay #{env['QUERY_STRING']}`
    [200, {}, [response]]
  end
end
