class Pinboard < Service
  include HTTParty
  base_uri 'https://api.pinboard.in/v1'

  def initialize(klass = nil)
    @klass = klass
    if @klass.present?
      @auth_token = @klass.access_token
    end
  end

  def request_token(username, password)
    response = self.class.get('/user/api_token', query: {auth_token: password, format: 'json'})
    if response.code == 401
      raise OAuth::Unauthorized
    else
      OpenStruct.new(token: password, secret: 'n/a')
    end
  end

  def add(params)
    defaults = {auth_token: @auth_token, format: 'json'}
    options = params.slice(:toread, :shared, :tags, :extended, :description, :url)
    response = self.class.get('/posts/add', query: defaults.merge(options))
    if response.code == 200
      data = JSON.load(response.body)
      if data['result_code'] == "done"
        code = 200
      else
        code = 500
      end
    else
      response.code
    end
  end

  def share(params)
    authenticated_share(@klass, params)
  end

end