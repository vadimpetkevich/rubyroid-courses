class HappyNewYear
  def initialize cowsay_app
  	@cowsay_app = cowsay_app
  end
  def call env
    status, headers, body = @cowsay_app.call env
    body.first['>'] = 'Happy New Year!>'
    [status, headers, body]
  end
end