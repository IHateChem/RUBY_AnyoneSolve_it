class BaekjoonController < ApplicationController
  def validation
    api_url = 'https://solved.ac/api/v3/search/user?query='
    ids = JSON.parse(params[:ids])
    validUsers = []
    invalidUsers = []
    ids.each do |id|
      if !/^[a-zA-Z0-9]+$/.match?(id)
        invalidUsers.push(id)
        next
      end
      flag = true
      response = HTTParty.get(api_url+id)
      if response.code == 200
        result = JSON.parse(response.body)
        count = result['count']
        items = result['items']
        items.each do |item|
          if item['handle'] == id
            validUsers.push(id)
            flag = false
            break
          end
        end
        if flag
          invalidUsers.push(id)
        end
      else
        invalidUsers.push(id)
      end
    end
    respond_to do |format|
      format.json { render json: { valid: validUsers, invalid: invalidUsers } }
    end
  end

  def problem
    id = params[:id]
  end
end
