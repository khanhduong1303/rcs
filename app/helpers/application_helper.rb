module ApplicationHelper

  def menu_item(name = nil, path = nil, options = {})
    content_tag(:li, link_to(name, path), options)
  end

  def alert_dismissible(content, type = 'success')
    content_tag :div, { class: "alert alert-#{type} alert-dismissible", role: 'alert' } do
      concat(
        capture do
          content_tag :button, { class: 'close', data: { dismiss: 'alert' } } do
            concat content_tag :span, '&times;'.html_safe, { 'aria-hidden' => true }
            concat content_tag :span, 'Close', { class: 'sr-only' }
          end
        end
      )
      concat content
    end
  end

  def hash_to_object hash
    begin
      return Hashie::Mash.new hash
    rescue
      return nil
    end
  end

  API_BASE_URL = "http://rms.vn/api"
  def get_api url, parameters=nil, username_api=nil, password_api=nil
    if !url.nil? && !parameters.nil? && (username_api.nil? || password_api.nil?)
      param = '?'
      i=0
      parameters.each do |key, val|
        param += "#{key}=#{val}"
        i+=1
        if i < parameters.size
          param += '&'
        end
      end
      uri = "#{API_BASE_URL}#{url}#{param}"
      rest_resource = RestClient::Resource.new(uri, username_api, password_api)
      return JSON.parse(rest_resource.get, :symbolize_names => true)
    elsif !url.nil? && parameters.nil? && (username_api.nil? || password_api.nil?)
      uri = "#{API_BASE_URL}#{url}"
      rest_resource = RestClient::Resource.new(uri)
      return JSON.parse(rest_resource.get, :symbolize_names => true)
    elsif !url.nil? && !parameters.nil? && !username_api.nil? && !password_api.nil?
      param = '?'
      i=0
      parameters.each do |key, val|
        param += "#{key}=#{val}"
        i+=1
        if i < parameters.size
          param += '&'
        end
      end
      uri = "#{API_BASE_URL}#{url}#{param}"
      rest_resource = RestClient::Resource.new(uri, username_api, password_api)
      return JSON.parse(rest_resource.get, :symbolize_names => true)
    elsif !url.nil? && parameters.nil? && !username_api.nil? && !password_api.nil?
      uri = "#{API_BASE_URL}#{url}"
      rest_resource = RestClient::Resource.new(uri, username_api, password_api)
      return JSON.parse(rest_resource.get, :symbolize_names => true)
    else
      return  {status:'failed', message:'Get api error', data:nil}
    end
  end

  def post_api url, parameters, username_api=nil, password_api=nil
    uri = "#{API_BASE_URL}#{url}"
    rest_resource = RestClient::Resource.new(uri, username_api, password_api)
    begin
      return JSON.parse(rest_resource.post(parameters, :content_type=> 'application/json'), :symbolize_names => true)
    rescue
      return {status:'failed', message:'Post api error', data:nil}
    end
  end
end

