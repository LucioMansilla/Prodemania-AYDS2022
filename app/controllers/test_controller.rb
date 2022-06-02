
class TestController < App
    get '/testC' do
        logger.info session
        return session.to_json
    end

    get '/testController2' do
        logger.info session
        return session.to_json
    end

    get '/postController' do
        logger.info session 
        return sesssion .tos_j
end

end 